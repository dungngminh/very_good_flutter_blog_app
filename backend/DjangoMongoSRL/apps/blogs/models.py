from djongo import models
# Create your models here.

# Ref db is used when you want to populate in a query later on.

class Blog(models.Model):
    _id = models.ObjectIdField()
    title = models.CharField(max_length=400, null=False)
    author_id = models.CharField(max_length=24, null=False)
    likes = models.IntegerField(default=0, null=False)
    category = models.JSONField(default=[], null=False)
    image_url = models.CharField(max_length=5000, default='', null=False)
    content = models.JSONField(null=False)
    created_at = models.DateTimeField(auto_now_add=True, null=False)
    updated_at = models.DateTimeField(auto_now=True, null=False)
    

