from djongo import models
from apps.blogs.models import Blog

# Create your models here.
class User(models.Model):
    _id = models.ObjectIdField(null=False)
    username = models.CharField(max_length=200, null=False, unique=True)
    password = models.CharField(max_length=200, null=False)
    following_count = models.IntegerField(default=0)
    follower_count = models.IntegerField(default=0)
    first_name = models.CharField(max_length=500)
    last_name = models.CharField(max_length=100)
    avatar = models.CharField(max_length=1000)
    device_token = models.CharField(max_length=10000, default='')
    num_blog = models.IntegerField(default=0)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
