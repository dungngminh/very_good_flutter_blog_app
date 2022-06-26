from rest_framework import serializers

class BookmarkSerializer(serializers.ModelSerializer):
    class Meta:
        model = models.Boorkmark
        field = ('id',
                 'user_id',
                 'blog_id',
                 'created_at',
                 'updated_at')
        depth = 1