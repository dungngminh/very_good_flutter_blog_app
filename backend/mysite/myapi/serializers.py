# serializers.py
from rest_framework import serializers

from myapi import models


class StaffSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Staff
        fields = ('username', 'password')
        extra_kwargs = {'password': {'write_only': True}}


class StaffLoginSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(required=True)


class BookSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Book
        fields = ('id', 'title', 'photourl', 'genre')
        depth = 1


class RatingSerializer(serializers.ModelSerializer):

    class Meta:
        model = models.Rating
        fields = ('user', 'book', 'rating')

class GenreSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Genre
        fields = ('id', 'name')