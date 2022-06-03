from django.db import models
from ..users.models import User
# Create your models here.

class Blog(models.Model):
    id = models.AutoField(primary_key=True)
    content = models.CharField(max_length=250)
    id_user = models.ForeignKey(User, on_delete=models.CASCADE)
    category = models.CharField(max_length=250)
    

