from rest_framework import serializers
from .models import Blog

class BlogSerializer(serializers.ModelSerializer):
    class Meta:
        model = Blog
        field = ('id', 'content', 'id_user', 'category')

class BlogPostSerializer(serializers.Serializer):
    content = serializers.JSONField()
    title = serializers.CharField()
    image_url = serializers.CharField()
    category = serializers.JSONField()

class BlogViewSerializer(serializers.Serializer):
    _id = serializers.CharField()
    content = serializers.JSONField(required=True)
    title = serializers.CharField(required=True)
    image_url = serializers.CharField()
    category = serializers.JSONField()
    author_id = serializers.CharField()
    likes = serializers.IntegerField()
    created_at = serializers.DateTimeField()
    updated_at = serializers.DateTimeField()
    