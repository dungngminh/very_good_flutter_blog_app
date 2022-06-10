from email.policy import default
from unicodedata import category
from djongo import models
# Create your models here.

# Ref db is used when you want to populate in a query later on.

class Blog(models.Model):
    _id = models.ObjectIdField(null=False)
    title = models.CharField(max_length=400, null=False)
    # author_id = models.ObjectIdField(null=False)
    # likes = models.IntegerField(default=0, null=False)
    # category = models.JSONField(default=[], null=False)
    # image_url = models.CharField(max_length=5000, default='')
    # content = models.JSONField(null=False)
    # created_at = models.DateTimeField(auto_now_add=True)
    # updated_at = models.DateTimeField(auto_now=True)
    

