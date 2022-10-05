from asyncio.log import logger
from bson import ObjectId
from apps.utils.response import ResponseMessage
from apps.utils.response import HttpResponse
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework import status
from apps.utils.jwt import JsonWebTokenHelper
from apps.utils.database import mongo_extension
from .serializers import BookmarkBodySerializer
from .models import Boorkmark
from datetime import datetime, timedelta

def convert_timestamp(data: datetime):
    local_time = (data + timedelta(hours=7))
    return int(datetime.timestamp(local_time))

# def conver_bookmark_func(x):
#     x['_id'] = str(x['_id'])
#     x['blog_detail']['_id'] = str(x['blog_detail']['_id'])
#     x['created_at'] = convert_timestamp(x['created_at'])
#     x['updated_at'] = convert_timestamp(x['updated_at'])
#     x['blog_detail']['updated_at'] = convert_timestamp(x['blog_detail']['updated_at'])
#     x['blog_detail']['created_at'] = convert_timestamp(x['blog_detail']['created_at'])
#     x['blog_detail']['category'] = x['blog_detail']['category'][0]
#     return x

def convert_bookmark_func(x):
    del x['_id']
    del x['blog_detail']['author_object_id']
    del x['blog_detail']['author_id']
    del x['blog_detail']['author_detail']['password']
    x['blog_detail']['_id'] = str(x['blog_detail']['_id'])
    x['blog_detail']['updated_at'] = convert_timestamp(x['blog_detail']['updated_at'])
    x['blog_detail']['created_at'] = convert_timestamp(x['blog_detail']['created_at'])
    x['blog_detail']['category'] = x['blog_detail']['category'][0]
    x['blog_detail']['author_detail']['_id'] = str(x['blog_detail']['author_detail']['_id'])
    x['blog_detail']['author_detail']['updated_at'] = convert_timestamp(x['blog_detail']['author_detail']['updated_at'])
    x['blog_detail']['author_detail']['created_at'] = convert_timestamp(x['blog_detail']['author_detail']['created_at'])
    x = x['blog_detail']
    return x

class BookmarksView(APIView):
    permission_classes = (AllowAny, )
    database = mongo_extension.get_database()

    def post(self, request, *a, **b):
        try:
            payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])

            if not payload:
                return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)
            else:
                id = payload['_id']
                user = self.database.users_user.find_one({ '_id': ObjectId(id) })
                if not user:
                    return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)
                serializer = BookmarkBodySerializer(data = request.data)

                if serializer.is_valid(raise_exception=True):
                    print({ 'user_id': type(id), 'blog_id': type(serializer.data['blog_id']) })
                    is_existed = self.database.bookmarks_boorkmark.find_one({ 'user_id': id, 'blog_id': serializer.data['blog_id'] })

                    if is_existed:
                        return HttpResponse.response(data = {}, message=ResponseMessage.DUPLICATED, status=status.HTTP_400_BAD_REQUEST)

                    bookmark = Boorkmark.objects.create(
                        _id = ObjectId(),
                        user_id = id,
                        blog_id = serializer.data['blog_id'] 
                    )
                    bookmark.save()
                    return HttpResponse.response(data={}, message=ResponseMessage.SUCCESS, status=status.HTTP_201_CREATED)
        except Exception as e:
            logger.error(e)
            return HttpResponse.response(data={}, message=ResponseMessage.INTERNAL_SERVER_ERROR, status=status.HTTP_500_INTERNAL_SERVER_ERROR)



    def get(self, request, *a, **b):
        try:
            payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])
            
            if not payload:
                return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)

            current_user_id = payload['_id']
                    

            # if (user_id != current_user_id):
            #     return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)

            pipeline = [
                {
                    "$match": {
                        "user_id": current_user_id,
                    },
                },
                {
                    "$addFields": {
                        "blog_object_id": {
                            "$toObjectId": "$blog_id",
                        },
                    },
                },
                {
                    "$lookup": {
                        "from": "blogs_blog",
                        "localField": "blog_object_id",
                        "foreignField": "_id",
                        "as": "blog_detail",
                    }
                },
                {
                    "$unwind": "$blog_detail",
                },
                {
                    "$addFields": {
                        "blog_detail.author_object_id": {
                            "$toObjectId": "$blog_detail.author_id",
                        },
                    },
                },
                {
                    "$lookup": {
                        "from": "users_user",
                        "localField": "blog_detail.author_object_id",
                        "foreignField": "_id",
                        "as": "blog_detail.author_detail",
                    }
                },
                {
                    "$unwind": "$blog_detail.author_detail",
                },
                {
                    "$project": {
                        "blog_detail": 1,
                        # "blog_id": 0,
                        # "_id": 0,
                        # "user_id": 0,
                        # "created_at": 0,
                        # "updated_at": 0,
                    }
                },
            ]

            bookmarks = list(self.database.bookmarks_boorkmark.aggregate(pipeline=pipeline))

            bookmarks = list(map(
                convert_bookmark_func,
                bookmarks
            ))
            
            return HttpResponse.response(data=bookmarks, message=ResponseMessage.SUCCESS, status=status.HTTP_200_OK)

        except Exception as e:
            print(e)
            return HttpResponse.response(data={}, message=str(e), status=status.HTTP_401_UNAUTHORIZED)

    # def post(self, request):
    #     return True
    
    def delete(self, request, *a, **b):
        try:
            blog_id = request.data['blog_id']
            payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])
            if not payload:
                return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)
            else:
                bookmark = dict(self.database.bookmarks_boorkmark.find_one({ 'blog_id': blog_id, 'user_id': payload['_id'] }))
                if not bookmark:
                    return HttpResponse.response(data={}, message='', status=status.HTTP_400_BAD_REQUEST)
                self.database.bookmarks_boorkmark.delete_one({ '_id': ObjectId(bookmark['_id']) })
                return HttpResponse.response(data={}, message=ResponseMessage.SUCCESS, status=status.HTTP_200_OK)

        except Exception as e:
            logger.error(e)
            return HttpResponse.response(data = {}, message=str(e), status=status.HTTP_500_INTERNAL_SERVER_ERROR)