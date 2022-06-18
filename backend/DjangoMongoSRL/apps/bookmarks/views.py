from apps.utils.response import ResponseMessage
from apps.utils.response import HttpResponse
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from apps.utils.jwt import JsonWebTokenHelper
from apps.utils.database import mongo_extension

class BookmarksView(APIView):
    permission_classes = (AllowAny, )
    database = mongo_extension.get_database()

    def get(self, request, *a, **b):
        try:
            user_id = b['user_id']
            payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])
            
            if not payload:
                return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)
            
            current_user_id = payload['_id']
            if (user_id != current_user_id):
                return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)

            pipeline = [
                {
                    "$match": {
                        "user_id": user_id,
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
                    }
                },
                {
                    "$unset": [],
                }
            ]

            bookmarks = list(self.database.bookmarks_bookmark.aggregate(pipeline=pipeline))
            
            return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)

        except:
            return HttpResponse.response(data={}, message=ResponseMessage.UNAUTHORIZED, status=status.HTTP_401_UNAUTHORIZED)

    # def post(self, request):
    #     return True
    
    # def delete(self, request):
    #     return True