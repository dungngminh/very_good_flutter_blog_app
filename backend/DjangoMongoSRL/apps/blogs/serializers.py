from attr import field
from rest_framework import serializers
from ..blogs import models

class BlogSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Blog
        field = ('id',
                 'title',
                 'content',
                 'id_user',
                 'like_count',
                 'like_count',
                 'category',
                 'date_added')