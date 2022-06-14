from djongo import models

# Create your models here.
class Following(models.Model):
    # sender = models.ObjectIdField()
    # receiver = models.ObjectIdField()
    id_follow = models.ObjectIdField(null=False)
    following = models.JSONField(default=[])
    follower = models.JSONField(default=[])