#!/bin/bash

# Script interattivo per generare il file .env di sagragest
set -e

# Funzione per generare una secret key Django
function generate_secret_key() {
    tr -dc 'a-zA-Z0-9!@#$%^&*(-_=+)' < /dev/urandom | head -c 50
}

# Parametri fissi
echo "Impostazione parametri fissi..."
POSTGRES_DB="sagra_db"
POSTGRES_USER="sagragest"
POSTGRES_PASSWORD="sagrapsw"
POSTGRES_HOST="db"
POSTGRES_PORT="5432"
REDIS_URL="redis://redis:6379/1"
STATIC_ROOT="/app/staticfiles"
MEDIA_ROOT="/app/media"
CUPS_SERVER="cups"
CUPS_ADMIN="admin"
CUPS_PASSWORD="admin"
TZ="Europe/Rome"

# Parametri generati
echo "Generazione DJANGO_SECRET_KEY..."
DJANGO_SECRET_KEY=$(generate_secret_key)

# Parametri interattivi
read -p "Aggiungi altri ALLOWED_HOSTS (separati da virgola, opzionale): " EXTRA_HOSTS
if [ -n "$EXTRA_HOSTS" ]; then
    ALLOWED_HOSTS="localhost,127.0.0.1,$EXTRA_HOSTS"
else
    ALLOWED_HOSTS="localhost,127.0.0.1"
fi

read -p "Vuoi configurare l'email SMTP? (y/n) " SET_EMAIL
if [[ "$SET_EMAIL" =~ ^[Yy]$ ]]; then
    read -p "DJANGO_EMAIL_HOST: " DJANGO_EMAIL_HOST
    read -p "DJANGO_EMAIL_PORT [587]: " DJANGO_EMAIL_PORT
    DJANGO_EMAIL_PORT=${DJANGO_EMAIL_PORT:-587}
    read -p "DJANGO_EMAIL_HOST_USER: " DJANGO_EMAIL_HOST_USER
    read -s -p "DJANGO_EMAIL_HOST_PASSWORD: " DJANGO_EMAIL_HOST_PASSWORD
    echo
    read -p "DJANGO_EMAIL_USE_TLS [True]: " DJANGO_EMAIL_USE_TLS
    DJANGO_EMAIL_USE_TLS=${DJANGO_EMAIL_USE_TLS:-True}
else
    DJANGO_EMAIL_HOST="smtp.tuodominio.com"
    DJANGO_EMAIL_PORT="587"
    DJANGO_EMAIL_HOST_USER="utente@tuodominio.com"
    DJANGO_EMAIL_HOST_PASSWORD="superpassword"
    DJANGO_EMAIL_USE_TLS="True"
fi
DJANGO_EMAIL_BACKEND="django.core.mail.backends.smtp.EmailBackend"

read -p "Ambiente Django (prod/dev) [prod]: " DJANGO_ENV
DJANGO_ENV=${DJANGO_ENV:-prod}
read -p "Superuser username [admin]: " DJANGO_SUPERUSER_USERNAME
DJANGO_SUPERUSER_USERNAME=${DJANGO_SUPERUSER_USERNAME:-admin}
read -p "Superuser email [admin@example.com]: " DJANGO_SUPERUSER_EMAIL
DJANGO_SUPERUSER_EMAIL=${DJANGO_SUPERUSER_EMAIL:-admin@example.com}
read -s -p "Superuser password [superpassword]: " DJANGO_SUPERUSER_PASSWORD
DJANGO_SUPERUSER_PASSWORD=${DJANGO_SUPERUSER_PASSWORD:-superpassword}
echo

read -p "Dominio per il sito [example.com]: " DOMINIO
DOMINIO=${DOMINIO:-example.com}

# Parametri Samba
read -p "Samba user [smbuser]: " SAMBA_USER
SAMBA_USER=${SAMBA_USER:-smbuser}
read -s -p "Samba password [smbpass]: " SAMBA_PASS
SAMBA_PASS=${SAMBA_PASS:-smbpass}
echo

cat > .env <<EOF
# 🔐 Sicurezza
DJANGO_SECRET_KEY=$DJANGO_SECRET_KEY

# 🗄️ Database PostgreSQL
POSTGRES_DB=$POSTGRES_DB
POSTGRES_USER=$POSTGRES_USER
POSTGRES_PASSWORD=$POSTGRES_PASSWORD
POSTGRES_HOST=$POSTGRES_HOST
POSTGRES_PORT=$POSTGRES_PORT

# 🌐 Host consentiti
ALLOWED_HOSTS=$ALLOWED_HOSTS

# 🔁 Redis
REDIS_URL=$REDIS_URL

# 🧾 Static & Media (assoluti nel container)
STATIC_ROOT=$STATIC_ROOT
MEDIA_ROOT=$MEDIA_ROOT

# ✉️ Email SMTP
DJANGO_EMAIL_BACKEND=$DJANGO_EMAIL_BACKEND
DJANGO_EMAIL_HOST=$DJANGO_EMAIL_HOST
DJANGO_EMAIL_PORT=$DJANGO_EMAIL_PORT
DJANGO_EMAIL_HOST_USER=$DJANGO_EMAIL_HOST_USER
DJANGO_EMAIL_HOST_PASSWORD=$DJANGO_EMAIL_HOST_PASSWORD
DJANGO_EMAIL_USE_TLS=$DJANGO_EMAIL_USE_TLS

# 🖨️ CUPS server
CUPS_SERVER=$CUPS_SERVER
CUPS_ADMIN=$CUPS_ADMIN
CUPS_PASSWORD=$CUPS_PASSWORD

# 🐍 Python
DJANGO_ENV=$DJANGO_ENV
DJANGO_SUPERUSER_USERNAME=$DJANGO_SUPERUSER_USERNAME
DJANGO_SUPERUSER_EMAIL=$DJANGO_SUPERUSER_EMAIL
DJANGO_SUPERUSER_PASSWORD=$DJANGO_SUPERUSER_PASSWORD

# 🐳 Docker
TZ=$TZ

# 🖧 Samba
SAMBA_USER=$SAMBA_USER
SAMBA_PASS=$SAMBA_PASS

DOMINIO=$DOMINIO
EOF

echo ".env generato con successo!"
