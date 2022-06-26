from unicodedata import category
from django.shortcuts import render
from http.client import BAD_REQUEST
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework import generics
from uritemplate import partial
from .serializers import BlogSerializer
from ..users import serializers
from rest_framework.response import Response
from rest_framework import status
from .models import Blog
from ..users.models import User
from rest_framework import filters
from django.http import HttpResponseRedirect
from rest_framework.filters import SearchFilter, OrderingFilter
# Create your views here.


class BlogManage(APIView):
    permission_classes = (AllowAny,)
    serializer_class = BlogSerializer
    
    # def get(self, request, *args, **kwargs):
    #     blog_model = Blog.objects.all()
    #     serializer = BlogSerializer(blog_model, many=True)
    #     return Response(serializer.data,status=status.HTTP_200_OK)
    def get(self, request, pk=None, format=None):
        try:
            if pk:
                blog_obj = Blog.objects.get(pk=pk)
                serializer = BlogSerializer(blog_obj)               
            else:
                query_set = Blog.objects.all()
                serializer = BlogSerializer(query_set, many=True)
                
            return Response(serializer.data)   
        except Exception as e:
                return HttpResponseRedirect('/blog/')
        
        
    def post(self, request, format=None):
        data = request.data
        serializer = BlogSerializer(data = data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
       
            
    
    def delete(self, request, pk, format=None):
        Blog.objects.get(pk=pk).delete()
        return Response({"Message":"Data deleted successfully !!"})
        
    #Update
    def put(self, request,pk, format=None):
        blog_obj = Blog.objects.get(pk=pk)
        serializer = BlogSerializer(data = request.data, instance=blog_obj)
        if serializer.is_valid():
            serializer.save()
            return Response({"Message":"Data updated successfully !!"})  
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
    #Partial Update
    def patch(self, request,pk, format=None):
        blog_obj = Blog.objects.get(pk=pk)
        serializer = BlogSerializer(data = request.data, instance=blog_obj, partial=True)
        if serializer.is_valid():
            serializer.save()
            return Response({"Message":"Data updated successfully !!"})
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
        
                
class postFilter(generics.ListAPIView):
    
    queryset = Blog.objects.all()
    
    serializer_class = BlogSerializer
    
    filter_backends = (SearchFilter, OrderingFilter)
    
    search_fields = ['^title', '^content']
        
        
    
    