#!/bin/sh

if [ -z "$1" ]; then
    echo "Erro: Nenhum parâmetro fornecido (1 ou 0)."
    exit 1
fi

if [ ! -d "/sys/class/gpio/gpio21" ]; then
	echo 21 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio21/direction
fi

if [ $1 -eq 1 ]; then
	echo 1 > /sys/class/gpio/gpio21/value
else
	echo 0 > /sys/class/gpio/gpio21/value
fi
