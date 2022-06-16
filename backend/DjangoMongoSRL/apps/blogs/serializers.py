from attr import field
from rest_framework import serializers
from ..blogs import models

class BlogSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Blog
        fields = ('id',
                 'title',
                 'content',
                 'id_user',
                 'like_count',
                 'imageUrl',
                 'category',
                 'date_added')