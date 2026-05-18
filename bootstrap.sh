#!/bin/bash

echo "Configurando el laboratorio AVR Bare-Metal..."

# 1. Construir la imagen de Docker en esta nueva PC
echo " Construyendo la imagen de Docker 'avr-toolchain'..."
docker build -t avr-toolchain .

echo "¡Entorno listo! Ya puedes abrir esta carpeta en CLion."