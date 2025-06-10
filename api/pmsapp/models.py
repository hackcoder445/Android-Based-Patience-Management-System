import uuid
from django.db import models

# Create your models here.
class Patient(models.Model):
    patient_id = models.UUIDField(default=uuid.uuid4, primary_key=True, editable=False, unique=True)
    name = models.CharField(max_length=30)
    address = models.TextField(max_length=1000)
    dob = models.DateField()
    phone = models.CharField(max_length=15)
    gender = models.CharField(max_length=10)
    picture = models.ImageField(upload_to='static/img', default='static/default.jpg')

    def __str__(self):
        return self.name
    

class Medicine(models.Model):
    medicine_id = models.UUIDField(default=uuid.uuid4, primary_key=True, editable=False, unique=True)
    name = models.CharField(max_length=30)
    price = models.FloatField()

    def __str__(self):
        return self.name
    
class Prescription(models.Model):
    pres_id = models.UUIDField(default=uuid.uuid4, primary_key=True, editable=False, unique=True)
    date = models.DateField(auto_now_add=True)
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE)
    diagnosis = models.CharField(max_length=100, null=True, blank=True)
    total = models.FloatField()
    payment_made = models.BooleanField(default=False)

    def __str__(self):
        return f"{self.patient} - {self.total} - {self.payment_made}"

class DrugPrescribed(models.Model):
    drugpres_id = models.UUIDField(default=uuid.uuid4, primary_key=True, editable=False, unique=True)
    drug = models.ForeignKey(Medicine, on_delete=models.DO_NOTHING)
    qty = models.IntegerField()
    dosage = models.IntegerField()
    price = models.FloatField(default=0.0)
    total = models.FloatField()
    prescription = models.ForeignKey(Prescription, on_delete=models.CASCADE, default=None)

    def __str__(self):
        return f"{self.drug} - {self.total}"
    
# class Receipt(models.Model):
#     receipt_id = models.UUIDField(default=uuid.uuid4, primary_key=True, editable=False, unique=True)
#     prescribed_drug = models.ForeignKey(DrugPrescribed, on_delete=models.CASCADE)
#     receipt_no = models.CharField(max_length=20) 
    





