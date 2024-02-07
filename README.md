<h1 align="center"> Raspberry Server </h1>
<p align="center">
    <img loading="lazy" src="http://img.shields.io/static/v1?label=STATUS&message=EM%20DESENVOLVIMENTO&color=GREEN&style=for-the-badge"/>
</p>

# Raspberry PI 4 Model B
<h2>Pinout</h2>
<p align="center">
    <img loading="lazy" width="40%" src="https://i0.wp.com/randomnerdtutorials.com/wp-content/uploads/2023/03/Raspberry-Pi-Pinout-Random-Nerd-Tutorials.png?quality=100&strip=all&ssl=1"/>
</p>
<h2>Fan circuit</h2>
<p align="center">
    <img loading="lazy" width="30%" src="https://i.imgur.com/ynC6IiP.jpg"/>
</p>


# Sistema Operacional

Escolher um sistema operacional para o Raspberry:
https://www.raspberrypi.com/software/operating-systems/

Instalar uma ferramenta para gravar a ISO no cartão SD. Softwares livres recomendáveis: Rufus ou BalenaEtcher
https://etcher.balena.io/#download-etcher

Fazer a inicialização da OS dentro do Raspberry

# Configuração OS
<h2>Inicialização</h2>

1. Criar username e password
2. Configurar Wifi, GPIO, Fan, SSH: **sudo raspi-config** 
3. Atualizar pacotes: **sudo apt-get update && apt-get upgrade** 

<h2>Segurança</h2>

1. Alterar senha root: **sudo passwd root**
2. Checar usuários root: **nano /etc/sudoers**
3. Atualizar user: **sudo nano /etc/sudoers.d/010_pi-nopasswd**
- **user ALL=(ALL) PASSWD: ALL**
5. Instalar e habilitar firewall: 
- **sudo apt install ufw**
- **sudo ufw enable**
- **sudo ufw allow 80, 443**
- **sudo ufw limit ssh/tcp**
- **sudo ufw status**
6. Proteger SSH:
- **nano etc/ssh/sshd_config**
- **Port ##**
- **MaxAuthTries 3**
- **MaxSession 2**
- **AllowUsers USER**
7. Mudar host name:
- **hostnamectl set-hostname dominio.com.br**
- **nano etc/hosts**
8. Habilitar certificado ssl:
- **apt install python3-certbot-apache**
- **certbot --apache**
9. Instalar segurança contra ataques:
- **sudo apt-get install fail2ban**
- **apt install python3-systemd**
- **cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local**
- **sudo cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local**
- **sudo nano /etc/fail2ban/jail.local**
- **backend=systemd**
- **enabled = true**

Referências: https://forums.raspberrypi.com/viewtopic.php?t=193892

# Diminuir Consumo:

1. Desativar funcionalidades e dispositivos: **nano /boot/config.txt**
- **dtparam=audio=off**
- **disable_camera=1**
- **dtparam=spi=off**
- **dtparam=act_led_trigger=none**

2. Diminuir frequência da CPU: **sudo cpufreq-set -g powersave**
3. Para normalizar frequência: **sudo cpufreq-set -g ondemand**

# Aplicação Web 

<h2>Apache</h2>

- **apt install apache2**
- **nano etc/apache2/apache2.conf**
- **ServerSignature Off**
- **ServerTokens Prod**
- **Options FollowSymLinks**
  
Para mudar a porta do apache:
- **nano etc/apache2/sites-available/seusite**
- **nano etc/apache2/sites-available/000-default.conf**
- **nano etc/apache2/ports.conf**
- **Listen 8080**

<h2>MariaDB</h2>

- **sudo apt install mariadb-server**
- **sudo systemctl start mariadb.service**
- **sudo mysql_secure_installation**
- **CREATE USER 'novousuario'@'localhost' IDENTIFIED BY 'minhasenha';**
- **GRANT ALL PRIVILEGES ON * . * TO 'novousuario'@'localhost';**
- **FLUSH PRIVILEGES;**

<h2>PHP</h2>

- **sudo apt install php libapache2-mod-php php-mysql**
- **php -v**

<h2>PHPMYADMIN</h2>

- **sudo apt install phpmyadmin**
- **sudo nano /etc/apache2/apache2.conf**
- **Include /etc/phpmyadmin/apache.conf**

<h2>Configurando serviço</h2>

- **sudo mkdir /var/www/your_domain**
- **sudo chown -R $USER:$USER /var/www/your_domain**
- **sudo nano /etc/apache2/sites-available/your_domain.conf**
- **sudo a2ensite your_domain**
- **sudo a2dissite 000-default**
- **sudo apache2ctl configtest**
- **sudo nano /etc/apache2/mods-enabled/dir.conf**

Referências: https://www.nerdlivre.com.br/como-instalar-apache-php-mysql-e-phpmyadmin-no-ubuntu-e-derivados/

## Monitorar parâmetros do sistema

1. Instalar bibliotecas para monitoramento
- **sudo apt-get install bc**
- **sudo apt-get install cpufrequtils**

2. Habilitar porta GPIO para fan:
- **cd sys/class/gpio**
- **echo 21 > export**
- **echo out > direction**
- **echo 1 > value**

3. Criar arquivo SHELL para automatizar usando CRON
- **sudo nano ./auto.sh**
- **sudo bash ./auto.sh**
- **chmod +x auto.sh**
- **sudo crontab -e**
- **\*/2 * * * * /auto.sh**

## Aplicações com Python

1. O Raspberry OS já vem com o Python instalado para o sistema, será necessário apenas instalar o pip:
- **python -V**
- **sudo apt-get install python3-pip**
- **pip list**
  
2. Caso haja a necessidade de instalar vários pacotes para um projeto é recomendável separar um ambiente virtual com um novo Python para não corromper o do próprio sistema:
Foi criado no diretório home/user/projetos_python:

- **mkdir home/user/projetos_python**
- **cd home/user/projetos_python**
- **python -m venv env**
- Para ativar o ambiente virtual: **source env/bin/activate**
- Agora pode-se utilizar o pip de forma segura **pip install numpy**
- Para desativar o ambiente virtual: **deactivate**

<h2>Selenium</h2>
Como utilizamos um sistema headless é necessário instalar um display virtual para rodar o selenium

- **pip install selenium**
- **sudo apt-get install chromium-chromedriver**
- **sudo apt-get install xvfb**
- **pip3 install pyvirtualdisplay**
- **pip install pyscreenshot Pillow**
- **pip install selenium-recaptcha-solver**
- sudo apt-get install ffmpeg
  
Para rodar o chromium selenium é necessário estar como USER

Referências: https://www.raspberrypi.com/documentation/computers/os.html#python-on-raspberry-pi
https://pypi.org/project/PyVirtualDisplay/0.2/
  
## Clonar o microSD

Instalar o win32 disk imager: https://win32diskimager.org/

<h4 align="center"> 
    :construction:  Projeto em construção  :construction:
</h4>
