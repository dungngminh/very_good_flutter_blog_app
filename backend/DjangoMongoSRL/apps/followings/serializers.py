from rest_framework import serializers

class FollowingSerializer(serializers.ModelSerializer):
    class Meta:
        model = Following
        field = ('id_follow', 'following', 'follower')
