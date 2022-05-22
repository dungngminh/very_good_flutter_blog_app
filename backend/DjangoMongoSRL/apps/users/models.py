from django.db import models

# Create your models here.
class User(models.Model):
    _id = models.CharField(primary_key=True, max_length=50)
    username = models.CharField(max_length=200, help_text="username", null=False)
    password = models.CharField(max_length=200, help_text="password", null=False)
    last_name = models.CharField(max_length=200, null=True, help_text="International identification number assigned to the right owner.")
    first_name = models.CharField(max_length=200)
    email = models.CharField(max_length=200)