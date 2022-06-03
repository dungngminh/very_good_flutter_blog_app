from attr import field
from rest_framework import serializers
from blogs import models

class BlogSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Blog
        field = ('id', 'content', 'id_user', 'category')