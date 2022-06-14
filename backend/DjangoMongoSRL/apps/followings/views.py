from django.shortcuts import render
from http.client import BAD_REQUEST
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from apps.utils.response import HttpResponse

from apps.utils.jwt import JsonWebTokenHelper
from .serializers import FollowingSerializer
from apps.followings import serializers
from rest_framework.response import Response
from rest_framework import status
from . import models
from ..followings.models import Following
# Create your views here.

class FollowingManage(APIView):
    permission_classes = (AllowAny,)
    serializer_class = FollowingSerializer
    
    def get(self, request, *args, **kwargs):
        following_model = models.Following.objects
        try:
            if "id_follow" in request.query_params:
                following_model = following_model.filter(id=request.query_params["id_follow"])
                
            if "following" in request.query_params:
                following_model = following_model.filter(content=request.query_params["following"])
                
            if "follower" in request.query_params:
                following_model = following_model.filter(id_user=request.query_params["follower"])
                 
            serializer = FollowingSerializer(following_model, many = True)
            
            return Response(serializer.data)
            
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
    
    def add(self, request):
        following_model = models.Following.objects
        data = request.data
        new_follow = models.Following.objects.create(
            follower = data['follower'],
            following = data['following'],   
        )
        new_follow.save()
        serializer = BlogSerializer(new_blog)
        return Response(serializer.data)
        
    
    def patch(self, request, id=None):
        item = models.Following.objects.get(id = id)
        item.following = request.data["following"]
        item.follower = request.data["follower"]
        item.save(update_fields=["following", "follower"])
        
        serializer = FollowingSerializer(item)
        return Response(serializer.data)
