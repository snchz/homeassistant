echo Dar permisos al sh con "chmod +x homeassitant_install.sh"
echo Despues ejecutar con ./homeassitant_install.sh

echo "-------------------------------------------------------------"
echo "Purgando todo lo instalado de Python"
echo "-------------------------------------------------------------"
apt-get purge Python*

echo "-------------------------------------------------------------"
echo "Instalando dependencias"
echo "-------------------------------------------------------------"
apt-get install -y build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev tar wget
apt-get install -y python3-dev libjpeg-dev zlib1g-dev autoconf libopenjp2-7 libtiff5 libturbojpeg0 tzdata
wget https://www.python.org/ftp/python/3.8.0/Python-3.8.0.tgz
tar zxf Python-3.8.0.tgz
cd Python-3.8.0

echo "-------------------------------------------------------------"
echo "Instalando Python 3.8"
echo "-------------------------------------------------------------"
./configure --enable-optimizations
make -j 4
make altinstall
cd ..
rm -rf Python-3.8.0.tgz
rm -rf Python-3.8.0
echo apt-get remove -y build-essential tk-dev libncurses5-dev libncursesw5-dev libreadline6-dev libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev libffi-dev
echo apt-get install python3-pip
pip3.8 install --upgrade pip

echo "-------------------------------------------------------------"
echo "Instalar Home Assistant"
echo "-------------------------------------------------------------"
pip3.8 install --no-cache-dir homeassistant
echo "Instalado en:"
hasspath=$(which hass)
echo $hasspath

echo "-------------------------------------------------------------"
echo "-- Configurando arranque automatico"
echo "-------------------------------------------------------------"
rm -rf /etc/systemd/system/home-assistant@leif.service
file="/etc/systemd/system/home-assistant@leif.service"
echo "[Unit]" >> $file
echo "Description=Home Assistant" >> $file
echo "After=network-online.target" >> $file
echo "" >> $file
echo "[Service]" >> $file
echo "Type=simple" >> $file
echo "User=%i" >> $file
echo "ExecStart="$hasspath >> $file
echo "" >> $file
echo "[Install]" >> $file
echo "WantedBy=multi-user.target" >> $file
cat $file

echo "-------------------------------------------------------------"
echo "-- Iniciando servicio"
echo "-------------------------------------------------------------"
cd /etc/systemd/system/
chmod 664 home-assistant@leif.service
systemctl enable home-assistant@leif.service
systemctl start home-assistant@leif.service

