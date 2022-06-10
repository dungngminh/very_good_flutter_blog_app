from statistics import mode
from django.db import models
from matplotlib.pyplot import title
from pytz import timezone
from ..users.models import User
# Create your models here.

class Blog(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=100)
    content = models.CharField(max_length=500)
    id_user = models.ForeignKey(User, on_delete=models.CASCADE)
    like_count = models.IntegerField(default=0)
    photourl = models.CharField(max_length=500)
    category = models.JSONField()
    date_added = models.DateTimeField(default=timezone.now)
    

