#!/bin/bash

# Colores para la salida
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # Sin color

echo -e "${GREEN}=== Actualizando el sistema... ===${NC}"
sudo apt update && sudo apt upgrade -y
if [ $? -ne 0 ]; then
    echo -e "${RED}Error durante la actualización del sistema.${NC}"
    exit 1
fi

echo -e "${GREEN}=== Instalando dependencias necesarias... ===${NC}"
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
if [ $? -ne 0 ]; then
    echo -e "${RED}Error al instalar dependencias.${NC}"
    exit 1
fi

echo -e "${GREEN}=== Agregando la clave GPG de Docker... ===${NC}"
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
if [ $? -ne 0 ]; then
    echo -e "${RED}Error al agregar la clave GPG de Docker.${NC}"
    exit 1
fi

echo -e "${GREEN}=== Agregando el repositorio oficial de Docker... ===${NC}"
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
if [ $? -ne 0 ]; then
    echo -e "${RED}Error al agregar el repositorio de Docker.${NC}"
    exit 1
fi

echo -e "${GREEN}=== Instalando Docker... ===${NC}"
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
if [ $? -ne 0 ]; then
    echo -e "${RED}Error al instalar Docker.${NC}"
    exit 1
fi

echo -e "${GREEN}=== Verificando instalación de Docker... ===${NC}"
docker --version
if [ $? -ne 0 ]; then
    echo -e "${RED}Docker no se instaló correctamente.${NC}"
    exit 1
fi

echo -e "${GREEN}=== Activando Docker para iniciar en el arranque... ===${NC}"
sudo systemctl enable docker --now

echo -e "${GREEN}=== Instalando Docker Compose... ===${NC}"
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
if [ $? -ne 0 ]; then
    echo -e "${RED}Error al instalar Docker Compose.${NC}"
    exit 1
fi

echo -e "${GREEN}=== Verificando instalación de Docker Compose... ===${NC}"
docker-compose --version
if [ $? -ne 0 ]; then
    echo -e "${RED}Docker Compose no se instaló correctamente.${NC}"
    exit 1
fi

echo -e "${GREEN}=== Instalación completa. Docker y Docker Compose están listos para usar. ===${NC}"

