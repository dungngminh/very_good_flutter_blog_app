from django.http import HttpResponse
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from ..bookmarks import models
from ..users.models import User
from ..blogs.models import Blog
from .serializers import BookmarkSerializer
from ..users import serializers
from ..blogs import serializers
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
    permission_classes = (AllowAny,)
    serializer_class = BookmarkSerializer
    
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

        
    def add(self, request):
        data = request.data
        new_bookmark = models.Boorkmark.objects.create(
            # user_id = data['user_id'],
            blog_id = data['blog_id'],
            created_at = data['created_at'],       
            updated_at = data['updated_at']         
        )
        new_bookmark.save()
        serialize_user = serializers.UserViewSerializer(data = request.data)
        id_user_obj = User.objects.get(_id = serialize_user.data['_id'])
        new_bookmark.user_id.add(id_user_obj)
        
        serializer = BookmarkSerializer(new_bookmark)
        return Response(serializer.data)
    
    def delete(self, request):
        try:
            bookmark_model = models.Boorkmark.objects
            if "id" in request.query_params:
                bookmark_model = blog_model.filter(id=request.query_params["id"])
                bookmark_model.delete()
                return Response(status=status.HTTP_200_OK)
            else:
                return Response(status=status.HTTP_400_BAD_REQUEST)
        
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
        
    
    def patch(self, request, id=None):
        item = models.Boorkmark.objects.get(id = id)
        
        # item.user_id = request.data["user_id"]
        item.blog_id = request.data["blog_id"]
        item.created_at = request.data["created_at"]
        item.updated_at = request.data["updated_at"]
        
        item.save(update_fields=["blog_id", "created_at", "updated_at"])
        
        serializer = BookmarkSerializer(item)
        return Response(serializer.data)