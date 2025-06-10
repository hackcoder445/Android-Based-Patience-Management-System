import base64
from django.core.files.storage import default_storage

from rest_framework import serializers
from dj_rest_auth.serializers import UserDetailsSerializer

from . models import User


class UserDetailsSerializer(UserDetailsSerializer):

    class Meta(UserDetailsSerializer.Meta):
        # imageMem = serializers.SerializerMethodField('image_memory')
        fields = [
            'pk',
            'username',
            'name',
            # 'imageMem'

        ]

    def image_memory(request, image:User):
        if image.profile_pic.name is not None:
            with default_storage.open(image.profile_pic.name, 'rb') as loadedfile:
                return base64.b64encode(loadedfile.read())