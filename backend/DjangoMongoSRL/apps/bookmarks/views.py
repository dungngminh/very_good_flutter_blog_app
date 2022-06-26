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
class BookmarksView(APIView):
    permission_classes = (AllowAny,)
    serializer_class = BookmarkSerializer
    
    def get(self, request, *args, **kwargs):
        bookmark_model = models.Boorkmark.objects
        
        try:
            if "id" in request.query_params:
                bookmark_model = bookmark_model.filter(id=request.query_params["id"])
                
            if "user_id" in request.query_params:
                bookmark_model = bookmark_model.filter(user_id=request.query_params["user_id"])
                
            if "blog_id" in request.query_params:
                bookmark_model = bookmark_model.filter(blog_id=request.query_params["blog_id"])
                
            if "created_at" in request.query_params:
                bookmark_model = bookmark_model.filter(created_at=request.query_params["created_at"])
                
            if "updated_at" in request.query_params:
                bookmark_model = bookmark_model.filter(updated_at=request.query_params["updated_at"])
                
            serializer = BookmarkSerializer(bookmark_model, many=True)
            return Response(serializer.data)
            
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
        
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