#!/bin/bash
set -e

echo "[django] Applico le migration..."
python manage.py makemigrations accounts printers reports sagragest sagrarapid --noinput
python manage.py migrate --noinput

echo "[django] Colleziono static..."
python manage.py collectstatic --noinput

# Crea superuser solo se non esiste
echo "[django] Verifico superuser..."
python manage.py shell <<PYTHON_EOF
from django.contrib.auth import get_user_model
from django.contrib.sites.models import Site
import os

User = get_user_model()
username = os.environ.get("DJANGO_SUPERUSER_USERNAME", "admin")
email = os.environ.get("DJANGO_SUPERUSER_EMAIL", "admin@example.com")
password = os.environ.get("DJANGO_SUPERUSER_PASSWORD", "changeme")
dominio = os.environ.get("DOMINIO", "example.com")

if not User.objects.filter(username=username).exists():
    print(f"[django] Creo superuser '{username}'")
    User.objects.create_superuser(username=username, email=email, password=password)
else:
    print(f"[django] Superuser '{username}' già presente")

# Aggiorna SITE_ID=1
try:
    site = Site.objects.get(id=1)
    site.name = "SagraGest"
    site.domain = dominio
    site.save()
    print(f"[django] Aggiornato Site 1: name='SagraGest', domain='{dominio}'")
except Site.DoesNotExist:
    print("[django][WARNING] Site con id=1 non trovato, impossibile aggiornare name/domain.")
PYTHON_EOF

# Preparo una sottocartella per il socket
mkdir -p /run/gunicorn
chmod 777 /run/gunicorn

echo "[django] Avvio Gunicorn..."
exec gunicorn --bind unix:/run/gunicorn/gunicorn.sock --umask 000 core.wsgi:application
