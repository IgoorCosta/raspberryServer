#!/bin/bash

export TZ=America/Sao_Paulo

# Dados do database sql
host="localhost"
usuario=""
senha=""
banco_de_dados=""

data_hora=$(date +"%d/%m/%Y %H:%M")

# Temperatura
temperatura=$(vcgencmd measure_temp)
temperatura_numerica=$(echo "$temperatura" | grep -oP '\d+\.\d+')

# Espaço na memória
info_espaco=$(df /dev/mmcblk0p2 | awk 'NR==2 {print $2 " " $3}')
memoria_total_kb=$(echo "$info_espaco" | awk '{print $1}')
memoria_usada_kb=$(echo "$info_espaco" | awk '{print $2}')
memoria_total_gb=$(echo "scale=3; $memoria_total_kb / (1024 * 1024)" | bc)
memoria_usada_gb=$(echo "scale=3; $memoria_usada_kb / (1024 * 1024)" | bc)

# Uso da RAM
info_ram=$(free -h | awk 'NR==2 {print $2 " " $3}')
ram_total=$(echo "$info_ram" | awk '{gsub(/[A-Za-z]/, "", $1); print $1}')
ram_usada_kb=$(echo "$info_ram" | awk '{gsub(/[A-Za-z]/, "", $2); print $2}')
ram_usada=$(echo "scale=3; $ram_usada_kb / 1024" | bc)

# Frequência e uso da CPU
carga_media_1min=$(uptime | awk -F'load average: ' '{print $2}' | awk -F', ' '{print $1}')
frequencia_cpu_raw=$(vcgencmd measure_clock arm | cut -d '=' -f2)
frequencia_cpu=$(echo "scale=3; $frequencia_cpu_raw / 1000000000" | bc)

# Atualiza table
comando_sql_insert="INSERT INTO table (time, temp, memTotal, memUsada, ramTotal, ramUsada, freqCPU, cargaMedia) VALUES ('$data_hora', '$temperatura_numerica', '$memoria_total_gb', '$memoria_usada_gb', '$ram_total', '$ram_usada', '$frequencia_cpu', '$carga_media_1min');"
comando_sql_update="UPDATE table SET time = '$data_hora',temp = '$temperatura_numerica',memTotal = '$memoria_total_gb',memUsada = '$memoria_usada_gb',ramTotal = '$ram_total',ramUsada = '$ram_usada',freqCPU = '$frequencia_cpu',cargaMedia = '$carga_media_1min' WHERE id = 1;"
echo "$comando_sql_insert" | mysql -h"$host" -u"$usuario" -p"$senha" "$banco_de_dados"
echo "$comando_sql_update" | mysql -h"$host" -u"$usuario" -p"$senha" "$banco_de_dados"

# Controle da temperatura
if [ "$(echo "$temperatura_numerica > 80" | bc -l)" -eq 1 ]; then
        sudo shutdown -h now
elif [ "$(echo "$temperatura_numerica > 44" | bc -l)" -eq 1 ]; then
        echo 1 > /sys/class/gpio/gpio21/value
else
        echo 0 > /sys/class/gpio/gpio21/value
fi

exit 1

