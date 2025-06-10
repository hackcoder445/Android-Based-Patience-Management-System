from django.contrib import admin
from django.contrib.auth.admin import UserAdmin

from . models import User
# Register your models here.
class UserAdmin(UserAdmin):
    list_display = ('username', 'name', 'email', 'date_joined', 'last_login', 'is_staff', 'is_superuser',)
    search_fields = ('username','name','email',)
    ordering = ('username',)
    readonly_fields = ('date_joined', 'last_login',)

    filter_horizontal = ()
    list_filter = ()
    fieldsets = ()

admin.site.register(User, UserAdmin)