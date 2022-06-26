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
                        
            # print(user_id)
            print(current_user_id)

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
                    "$project": {
                        "blog_detail": 1,
                        "blog_id": 1,
                        "_id": 1,
                        "user_id": 1,
                        "created_at": 1,
                        "updated_at": 1,
                    }
                },
            ]

            bookmarks = list(self.database.bookmarks_boorkmark.aggregate(pipeline=pipeline))
            print(bookmarks)

            bookmarks = list(map(
                conver_bookmark_func,
                bookmarks
            ))

            print(bookmarks)
            
            return HttpResponse.response(data=bookmarks, message=ResponseMessage.SUCCESS, status=status.HTTP_200_OK)

        except Exception as e:
            print(e)
            return HttpResponse.response(data={}, message=str(e), status=status.HTTP_401_UNAUTHORIZED)

    # def post(self, request):
    #     return True
    
    def delete(self, request, *a, **b):
        try:
            bookmark_id = b['id']
            payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])
            if not payload:
                return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)
            else:
                bookmark = self.database.bookmarks_boorkmark.find_one({ '_id': ObjectId(bookmark_id) })
                if not bookmark:
                    return HttpResponse.response(data={}, message='', status=status.HTTP_400_BAD_REQUEST)
                if bookmark['user_id'] != payload['_id']:
                    return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)
                self.database.bookmarks_boorkmark.delete_one({ '_id': ObjectId(bookmark_id) })
                return HttpResponse.response(data={}, message=ResponseMessage.SUCCESS, status=status.HTTP_200_OK)

        except Exception as e:
            logger.error(e)
            return HttpResponse.response(data = {}, message=str(e), status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    def patch(self, request, id=None):
        item = models.Boorkmark.objects.get(id = id)
        
        # item.user_id = request.data["user_id"]
        item.blog_id = request.data["blog_id"]
        item.created_at = request.data["created_at"]
        item.updated_at = request.data["updated_at"]
        
        item.save(update_fields=["blog_id", "created_at", "updated_at"])
        
        serializer = BookmarkSerializer(item)
        return Response(serializer.data)