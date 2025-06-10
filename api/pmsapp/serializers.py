import base64
from django.core.files.storage import default_storage

from rest_framework import serializers

from . models import *

class PatientSerializer(serializers.ModelSerializer):
    imgMem = serializers.SerializerMethodField('image_memory')

    class Meta:
        model = Patient
        fields = [
            "patient_id",
            "name",
            "dob",
            "address",
            "phone",
            "gender",
            "picture",
            "imgMem"
        ]
    def image_memory(request, image:Patient):
        if image.picture.name is not None:
            with default_storage.open(image.picture.name, 'rb') as loadedfile:
                return base64.b64encode(loadedfile.read())
            
class MedicineSerializer(serializers.ModelSerializer):
    class Meta:
        model = Medicine
        fields = "__all__"


class DrugPrescribedSerializer(serializers.ModelSerializer):
    # prescription = PrescriptionSerializer()
    class Meta:
        model = DrugPrescribed
        fields = "__all__" 


class PrescriptionSerializer(serializers.ModelSerializer):
    drug_prescribed = DrugPrescribedSerializer(many=True, required=False)
    total = serializers.CharField(required=False)
    class Meta:
        model = Prescription
        fields = "__all__"

class FullPrescriptionSerializer(serializers.ModelSerializer):
    drug_prescribed = DrugPrescribedSerializer(many=True, required=False)
    total = serializers.CharField(required=False)
    patient = PatientSerializer()
    class Meta:
        model = Prescription
        fields = "__all__"


class FullDrugPrescribedSerializer(serializers.ModelSerializer):
    prescription = FullPrescriptionSerializer()
    drug = MedicineSerializer()
    class Meta:
        model = DrugPrescribed
        fields = "__all__" 
