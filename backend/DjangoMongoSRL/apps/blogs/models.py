from statistics import mode
from django.db import models
from matplotlib.pyplot import title
from pytz import timezone
from ..users.models import User
# Create your models here.

class Blog(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=200)
    category = models.CharField(max_length=100)
    id_user = models.ForeignKey(User, on_delete=models.CASCADE)
    like_count = models.IntegerField(default=0)
    imageUrl = models.CharField(max_length=500)
    date_added = models.DateTimeField(auto_now_add=True)
    content = models.JSONField()
    

