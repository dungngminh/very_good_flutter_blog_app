from http.client import BAD_REQUEST
from rest_framework import viewsets
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from rest_framework.generics import ListAPIView
from .serializers import BookSerializer, StaffLoginSerializer, RatingSerializer, StaffSerializer
from . import models
from rest_framework.decorators import action, api_view, permission_classes
import string
import random
from django.contrib.auth import authenticate, login, logout, hashers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from django.conf import settings
import json
from django.db.models import Avg
import math

# from myapi import serializers
from rest_framework.permissions import AllowAny


class StaffLoginView(APIView):
    permission_classes = (AllowAny,)

    def post(self, request):
        serializer = StaffLoginSerializer(data=request.data)
        if serializer.is_valid():
            user = authenticate(
                request,
                username=serializer.validated_data['username'],
                password=serializer.validated_data['password']
            )
            if user:
                refresh = TokenObtainPairSerializer.get_token(user)
                data = {
                    'refresh_token': str(refresh),
                    'access_token': str(refresh.access_token),
                    'access_expires': int(settings.SIMPLE_JWT['ACCESS_TOKEN_LIFETIME'].total_seconds()),
                    'refresh_expires': int(settings.SIMPLE_JWT['REFRESH_TOKEN_LIFETIME'].total_seconds())
                }
                return Response(data, status=status.HTTP_200_OK)

            return Response({
                'error_message': 'Email or password is incorrect!',
                'error_code': 400
            }, status=status.HTTP_400_BAD_REQUEST)

        return Response({
            'error_messages': serializer.errors,
            'error_code': 400
        }, status=status.HTTP_400_BAD_REQUEST)


class BookManage(APIView):
    serializer_class = BookSerializer

    def get_queryset(self):
        books = models.Book.objects.all()
        return books

    def get(self, request, *args, **kwargs):
        book_model = models.Book.objects
        try:
            if "id" in request.query_params:
                book_model.filter(
                    id=request.query_params["id"])
            serializer = BookSerializer(book_model, many=True)
            return Response(serializer.data)
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def post(self, request):
        data = request.data
        new_book = models.Book.objects.create(
            title=data["title"], photourl=data["photourl"])
        new_book.save()
        for genre in data["genres"]:
            genre_obj = models.Genre.objects.get(id=genre["id"])
            new_book.genre.add(genre_obj)

        serializer = BookSerializer(new_book)
        return Response(serializer.data)

    def delete(self, request, *args, **kwargs):
        try:
            book_model = models.Book.objects
            if "id" in request.query_params:
                book_model = book_model.filter(
                    id=request.query_params["id"])
                book_model.delete()
                return Response(status=status.HTTP_200_OK)
            else:
                return Response(status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, id=None):
        item = models.Book.objects.get(id=id)
        item.title = request.data["title"]
        item.photourl = request.data["photourl"]
        item.save(update_fields=["title", "photourl"])

        item.genre.clear()
        for genre in request.data["genres"]:
            genre_obj = models.Genre.objects.get(id=genre["id"])
            item.genre.add(genre_obj)

        serializer = BookSerializer(item)
        return Response(serializer.data)


class RatingManage(APIView):
    permission_classes = (AllowAny,)
    serializer_class = RatingSerializer
    
    def get(self, request, *args, **kwargs ):
        rating_model = models.Rating.objects
        try:
            if "user" in request.query_params:
                rating_model = rating_model.filter(user_id=request.query_params["user_id"])
                
            if "book" in request.query_params:
                rating_model = rating_model.filter(book_id=request.query_params["book_id"])
            if "rating" in request.query_params:
                rating_model = rating_model.filter(rating=request.query_params["rating"])
            serializer = RatingSerializer(rating_model, many=True)
            return Response(serializer.data)
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)    
        
    def patch(self, request, book_id = None, user_id = None):
        item = models.Rating.objects.get(book_id=book_id, user_id=user_id)
        item.rating = request.data["rating"]
        item.save(update_fields = ["rating"])
        
        serializer = RatingSerializer(item)
        return Response(serializer.data)
        
class UserManage(APIView):
    permission_classes = (AllowAny,)
    serializer_class = StaffSerializer
    
    def getUser_REQUIRED_FIELDS(self, request, *args, **kwargs):
        user_model = models.User.objects
        try:
            if "id" in request.query_params:
                user_model = user_model.filter(id=request.query_params["id"])
            if "username" in request.query_params:
                user_model = user_model.filter(username=request.query_params["username"])
            if "REQUIRED_FIELDS" in request.query_params == 1:
                serializer = StaffSerializer(user_model, many=True)
                return Response(serializer.data)   
            return; 
         
        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)
        