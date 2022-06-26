from rest_framework import serializers
from .models import User

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(required=True)

class UpdatePasswordSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True)
    new_password_confirmation = serializers.CharField(required=True)

class RegisterSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(required=True)
    first_name = serializers.CharField(required=True)
    last_name = serializers.CharField(required=True)
    confirmation_password = serializers.CharField(required=True)

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            '_id',
            'username',
            'password',
            'last_name',
            'first_name',
            'following_count',
            'follower_count',
        ]

class UserViewSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    last_name = serializers.CharField(required=False)
    first_name = serializers.CharField(required=False)
    _id = serializers.CharField(required=True)
    avatar = serializers.CharField()
    follower_count = serializers.IntegerField()
    following_count = serializers.IntegerField()
    num_blog = serializers.IntegerField()

class UserViewPutSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    last_name = serializers.CharField(required=False)
    first_name = serializers.CharField(required=False)
    _id = serializers.CharField(required=True)
    avatar = serializers.CharField()
