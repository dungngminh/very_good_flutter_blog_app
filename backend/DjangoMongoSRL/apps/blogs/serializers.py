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
                 'photourl',
                 'category',
                 'date_added')
        depth = 1