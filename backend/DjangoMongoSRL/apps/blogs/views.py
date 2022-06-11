from unicodedata import category
from django.shortcuts import render
from http.client import BAD_REQUEST
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from .serializers import BlogSerializer
from ..users import serializers
from rest_framework.response import Response
from rest_framework import status
from ..blogs import models
from ..users.models import User
# Create your views here.


class BlogManage(APIView):
    permission_classes = (AllowAny,)
    serializer_class = BlogSerializer
    
    def get(self, request, *args, **kwargs):
        blog_model = models.Blog.objects
        
        try:
            if "id" in request.query_params:
                blog_model = blog_model.filter(id=request.query_params["id"])
                
            if "title" in request.query_params:
                blog_model = blog_model.filter(category=request.query_params["title"])
                
            if "content" in request.query_params:
                blog_model = blog_model.filter(content=request.query_params["content"])
                
            if "id_user" in request.query_params:
                blog_model = blog_model.filter(id_user=request.query_params["id_user"])
                
            if "like_count" in request.query_params:
                blog_model = blog_model.filter(id_user=request.query_params["like_count"])
                
            if "imageUrl" in request.query_params:
                blog_model = blog_model.filter(id_user=request.query_params["imageUrl"])
                
            if "category" in request.query_params:
                blog_model = blog_model.filter(category=request.query_params["category"])
                
            if "date_added" in request.query_params:
                blog_model = blog_model.filter(category=request.query_params["date_added"])
                
            if "offset" in request.query_params and "limit" in request.query_params:
                offset = int(request.query_params["offset"])
                limit = int(request.query_params["limit"])
                blog_model = blog_model.all()[offset:offset+limit]
            
                
            serializer = BlogSerializer(blog_model, many=True)
            return Response(serializer.data)
            
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
        
    def post(self, request):
        data = request.data
        new_blog = models.Blog.objects.create(
            content = data['content'],
            title = data['title'],
            imageUrl = data['imageUrl'],       
            category = data['category']         
        )
        new_blog.save()
        serialize_user = serializers.UserViewSerializer(data = request.data)
        id_user_obj = User.objects.get(_id = serialize_user.data['_id'])
        new_blog.id_user.add(id_user_obj)
        
        serializer = BlogSerializer(new_blog)
        return Response(serializer.data)
    
    def delete(self, request):
        try:
            blog_model = models.Blog.objects
            if "id" in request.query_params:
                blog_model = blog_model.filter(id=request.query_params["id"])
                blog_model.delete()
                return Response(status=status.HTTP_200_OK)
            else:
                return Response(status=status.HTTP_400_BAD_REQUEST)
        
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
        
    
    def patch(self, request, id=None):
        item = models.Blog.objects.get(id = id)
        
        item.title = request.data["title"]
        item.content = request.data["content"]
        item.imageUrl = request.data["imageUrl"]
        item.category = request.data["category"]
        
        item.save(update_fields=["title", "content", "imageUrl", "category"])
        
        serializer = BlogSerializer(item)
        return Response(serializer.data)
        
        
    
    