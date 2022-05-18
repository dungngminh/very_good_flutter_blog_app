from django.db import models
from django.conf import settings
import time

from django.contrib.auth.models import AbstractUser


class Book(models.Model):
    id = models.AutoField(primary_key=True)
    title = models.CharField(max_length=60)
    photourl = models.CharField(max_length=200)
    genre = models.ManyToManyField('Genre')

    def __str__(self):
        return self.title


class Genre(models.Model):
    id = models.AutoField(primary_key=True)
    name = models.CharField(max_length=60)

    def __str__(self):
        return self.name


class User(AbstractUser):
    # Delete not use field
    last_login = None

    password = models.CharField(max_length=100)
    books = models.ManyToManyField(Book, through='Rating')
    REQUIRED_FIELDS = []

    def __str__(self):
        return self.username


class Rating(models.Model):
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    rating = models.IntegerField()

