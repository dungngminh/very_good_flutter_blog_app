from djongo import models

# Create your models here.
class Following(models.Model):
    _id = models.ObjectIdField(null=False)
    sender = models.CharField(null=False, max_length=26)
    receiver = models.CharField(null=True, max_length=26)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)