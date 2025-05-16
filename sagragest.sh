#!/bin/bash

read -p "Vuoi avviare l'ambiente [dev/prod]? " ENV

if [[ "$ENV" == "prod" ]]; then
    if [ ! -f .env ]; then
        echo ".env non trovato. Avvio sagrainit.sh per la configurazione iniziale."
        bash ./sagrainit.sh
    fi
    # Seleziona il .dockerignore di produzione
    bash ./select-dockerignore.sh prod
    echo "Avvio docker-compose in modalità produzione..."
    docker compose -f docker-compose.prod.yml up --build -d
    echo "Controlla i log con: docker compose logs -f"
    echo "Avvio del container di produzione..."
elif [[ "$ENV" == "dev" ]]; then
    # Seleziona il .dockerignore di sviluppo
    bash ./select-dockerignore.sh dev
    echo "Avvio docker-compose in modalità sviluppo..."
    docker compose -f docker-compose.dev.yml up --build -d
    echo "Avvio del container di sviluppo..."
else
    echo "Scelta non valida. Usa 'dev' o 'prod'."
    exit 1
fi
