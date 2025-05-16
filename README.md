# SagraGest - Stack Docker

SagraGest è uno stack completo per la gestione di eventi, basato su Django, PostgreSQL, Redis, Nginx e CUPS, orchestrato tramite Docker Compose.

## Stack Tecnologico

- **Django** (Python 3.13)
- **PostgreSQL** (database)
- **Redis** (cache e task queue)
- **Nginx** (reverse proxy)
- **CUPS** (stampa)
- **Docker Compose** (orchestrazione)

## Struttura Principale

- `sagragest.sh`: script principale per avvio/gestione stack (dev/prod)
- `sagrainit.sh`: script di inizializzazione/configurazione ambiente
- `select-dockerignore.sh`: seleziona il `.dockerignore` corretto in base all'ambiente

## Comandi Utili

### Aggiornamento Sistema
```bash
sudo apt-get update && sudo apt-get upgrade -y
```

### Installazione Docker
```bash
for pkg in docker.io docker-doc docker-compose docker-compose-v2 podman-docker containerd runc; do
  sudo apt-get remove -y $pkg || true
done

sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo tee /etc/apt/keyrings/docker.asc > /dev/null
sudo chmod a+r /etc/apt/keyrings/docker.asc

echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "${UBUNTU_CODENAME:-$VERSION_CODENAME}") stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt update

sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo groupadd docker || true
sudo usermod -aG docker $USER

newgrp docker
```

### Download dello stack

Scarica la repository:

```bash
git clone https://github.com/marcomenon/docker-sagragest.git
cd docker-sagragest
```

Oppure con wget:

```bash
wget https://github.com/marcomenon/docker-sagragest/archive/refs/heads/main.zip
unzip main.zip
cd docker-sagragest-main
```

### Rendi eseguibili gli script

```bash
chmod +x sagragest.sh sagrainit.sh select-dockerignore.sh
```

## Utilizzo

- Avvio stack: `./sagragest.sh` e scegli dev o prod
- Inizializzazione: lo script `sagrainit.sh` viene chiamato automaticamente se manca `.env`
- Gestione `.dockerignore`: lo script `select-dockerignore.sh` viene chiamato automaticamente da `sagragest.sh` in base all'ambiente

---

Per dettagli su configurazione, override e personalizzazioni consulta i file `.env.example` e `docker-compose.override.yml`.
