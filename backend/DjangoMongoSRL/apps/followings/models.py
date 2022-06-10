from djongo import models

# Create your models here.
class Following(models.Model):
    sender = models.ObjectIdField()
    receiver = models.ObjectIdField()