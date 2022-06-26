from djongo import models


class Likes(models.Model):
    _id = models.ObjectIdField(null=False)
    user_id = models.CharField(null=False, max_length=26)
    blog_id = models.CharField(null=True, max_length=26)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)