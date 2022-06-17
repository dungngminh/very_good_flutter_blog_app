from unicodedata import category
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from apps.utils.response import ResponseMessage
from apps.utils.response import HttpResponse
from .serializers import BlogSerializer, BlogPostSerializer, BlogViewSerializer
from rest_framework.response import Response
from rest_framework import status
from bson.objectid import ObjectId
from bson import json_util
from django.core import serializers
from django.forms.models import model_to_dict
import json
from . import models
from . import middleware

class JSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return json.JSONEncoder.default(self, o)


class BlogManage(APIView):
    permission_classes = (AllowAny,)
    serializer_class = BlogSerializer
    
    def get(self, request, *args, **kwargs):
        blog_model = models.Blog.objects
        try:
            if "id" in request.query_params:
                blog_model = blog_model.filter(id=request.query_params["id"])
                
            if "content" in request.query_params:
                blog_model = blog_model.filter(content=request.query_params["content"])
                
            if "id_user" in request.query_params:
                blog_model = blog_model.filter(id_user=request.query_params["id_user"])
                
            if "category" in request.query_params:
                blog_model = blog_model.filter(category=request.query_params["category"])
                
            serializer = BlogSerializer(blog_model, many = True)
            
            return Response(serializer.data)
            
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
        
    def post(self, request):
        try:
            jwt = request.META['HTTP_AUTHORIZATION']
            # Authorization
            payload = middleware.BlogMiddleware.authorization(jwt)
            print(payload)
            if not payload:
                return HttpResponse.response(
                    data = {},
                    message = ResponseMessage.UNAUTHORIZED,
                    status = status.HTTP_401_UNAUTHORIZED,
                )

            serialize = BlogPostSerializer(data = request.data)
            if serialize.is_valid():
                # Check if user exists
                new_blog = models.Blog.objects.create(
                    _id = ObjectId(),
                    author_id = payload['_id'],
                    content = serialize.data['content'],
                    title = serialize.data['title'],
                    category = serialize.data['category'],
                )

                new_blog.save()
                dict_obj = json.loads(json_util.dumps(serializers.serialize('python', [ new_blog, ])[0]['fields']))

                return HttpResponse.response(
                    data = dict_obj,
                    message='ok',
                    status=status.HTTP_201_CREATED,
                )
            else:
                return HttpResponse.response(
                    data={},
                    message='format is not true',
                    status=status.HTTP_400_BAD_REQUEST,
                )
        except Exception as e:
            print(e)
            return HttpResponse.response(
                data={},
                message=ResponseMessage.INTERNAL_SERVER_ERROR,
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
    
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
        item.content = request.data["content"]
        item.category = request.data["category"]
        item.save(update_fields=["content", "category"])
        
        serializer = BlogSerializer(item)
        return Response(serializer.data)
        
        
    
    