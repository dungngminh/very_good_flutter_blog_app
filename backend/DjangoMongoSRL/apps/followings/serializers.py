from rest_framework import serializers
from .models import Following

class FollowingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Following
        field = ('id_follow', 'following', 'follower')