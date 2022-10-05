from rest_framework import serializers

class BookmarkBodySerializer(serializers.Serializer):
    blog_id = serializers.CharField()