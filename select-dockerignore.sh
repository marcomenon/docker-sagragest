#!/bin/bash
# Script per selezionare il .dockerignore corretto prima del build

if [ "$1" == "prod" ]; then
    cp .dockerignore.prod .dockerignore
    echo ".dockerignore di produzione attivo."
else
    cp .dockerignore.dev .dockerignore
    echo ".dockerignore di sviluppo attivo."
fi
