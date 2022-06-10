from djongo import models

# Create your models here.
class Boorkmark(models.Model):
    _id = models.ObjectIdField(null=False)
    # user_id = models.ObjectIdField(required=True)
    # blog_id = models.ObjectIdField(required=True)
    # created_at = models.DateTimeField(auto_now_add=True)
    # updated_at = models.DateTimeField(auto_now=True)