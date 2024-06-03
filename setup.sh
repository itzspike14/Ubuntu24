#!/bin/bash

# ==================================================================================================
# ========================| Comprobamos si ejecutas el script como root. |==========================
# ==================================================================================================
if [ "$(id -u)" -ne 0 ]; then
    echo "Este script debe ser ejecutado con privilegios de superusuario (sudo)"
    exit 1
fi
# ==================================================================================================



# ==================================================================================================
# =====================| Pedimos nombre de usuario para hacer las operaciones |=====================
# ==================================================================================================
echo "¿Cual es el nombre del usuario que estas usando ahora mismo?"
read usuario
# ==================================================================================================



# ==================================================================================================
# ===================| Actualizamos los repositorios y actualizamos el sistema. |===================
# ==================================================================================================
clear
echo "Actualizando sistema y repositorios..."
sleep 3

apt update
apt upgrade -y
# ==================================================================================================



# ==================================================================================================
# ======================| Eliminamos los paquetes innecesarios del sistema. |=======================
# ==================================================================================================
bloat_packages=(
    libreoffice* gnome-snapshot shotwell remmina rhythmbox
    gnome-system-monitor transmission-common transmission-gtk
    usb-creator-common usb-creator-gtk
)

snap_bloat_packages=(
    thunderbird firefox snap-store snapd-desktop-integration
    bare gtk-common-themes gnome-42-2204 firmware-updater core22 snapd
)

clear
echo "Desinstalando bloat del sistema..."
sleep 3

for package in "${bloat_packages[@]}"; do
    apt remove --purge "$package" -y
done

for package in "${snap_bloat_packages[@]}"; do
    snap remove --purge "$package"
done

apt remove --purge snapd -y
# ==================================================================================================



# ==================================================================================================
# ======================| Limpiamos todo lo que haya podido quedar por ahí. |=======================
# ==================================================================================================
clear
echo "Eliminando archivos o paquetes residuales..."
sleep 3

apt autoremove -y
# ==================================================================================================



# ==================================================================================================
# ===================| Función para verificar si Google Chrome está instalado. |====================
# ==================================================================================================
is_installed() {
    dpkg -l | grep -q "$1"
}
# ==================================================================================================



# ==================================================================================================
# =================| Instalar Google Chrome en el caso de que no este instalado. |==================
# ==================================================================================================
clear
if ! is_installed "google-chrome-stable"; then
    echo "Descargando Google Chrome..."
    sleep 3
    apt install wget -y
    wget -O googleChrome.deb https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    
    clear
    echo "Instalando Google Chrome..."
    sleep 3
    dpkg -i ./googleChrome.deb || apt --fix-broken install -y
    dpkg -i ./googleChrome.deb
else
    clear
    echo "Google Chrome ya está instalado, saltando este paso."
    sleep 3
fi
# ==================================================================================================



# ==================================================================================================
# ==========================| Instalación de otras aplicaciones útiles. |===========================
# ==================================================================================================
clear
echo "Instalando aplicaciones de interés."
sleep 3

apt install neofetch -y
echo 'neofetch' >> /home/$usuario/.bashrc

apt install gnome-music -y
apt install gnome-weather -y
apt install gnome-contacts -y
apt install gnome-maps -y
apt install gnome-extensions-app -y
apt install gnome-tweaks -y
apt install gnome-software -y
apt install bpytop -y
apt install make -y
apt --fix-broken install -y
# ==================================================================================================



# ==================================================================================================
# ==================| Aquí se aplican los cambios estéticos a Ubuntu 24.04 LTS |====================
# ==================================================================================================
clear
echo "Aplicando configuración estética en el sistema..."
sleep 1

rm /home/$usuario/.config/dconf/user
cp ./user /home/$usuario/.config/dconf/

echo "Aplicando nueva fuente en el sistema..."
sleep 1

cp ./user /home/$usuario/.config/dconf/
mkdir -p /usr/share/fonts/truetype/productSans
cp ./productSans.ttf /usr/share/fonts/truetype/productSans/
# ==================================================================================================



# ==================================================================================================
# ==================================| Fondos de pantalla nuevos. |==================================
# ==================================================================================================
echo "Aplicando nuevo fondo de escritorio..."
sleep 1

rm /usr/share/backgrounds/ubuntu-wallpaper-d.png
cp ./Backgrounds/ubuntu-wallpaper-d.png /usr/share/backgrounds/
# ==================================================================================================



# ==================================================================================================
# ========================| Cambiamos el Plymouth de arranque del sistema. |========================
# ==================================================================================================
echo "Aplicando nuevo Plymouth de arranque del sistema..."
sleep 1

rm -rf /usr/share/plymouth/themes/bgrt/*
cp -r ./Plymouth/* /usr/share/plymouth/themes/bgrt
# ==================================================================================================



# ==================================================================================================
# ==================| Eliminamos paquetes que se puedan haber instalado después. |==================
# ==================================================================================================
extra_packages=(
    imagemagick* mozc* xiterm+thai mlterm* hdate* uim-gtk* goldendict anthy*
)

clear
echo "Desinstalando posible bloat instalado posteriormente..."
sleep 3

for package in "${extra_packages[@]}"; do
    apt remove --purge "$package" -y
done
# ==================================================================================================



# ==================================================================================================
# ==============| Una vez mas, limpiamos todo aquello que ha podido quedar por ahí. |===============
# ==================================================================================================
clear
echo "Eliminando archivos o paquetes residuales..."
sleep 3

apt autoremove -y
# ==================================================================================================



# ==================================================================================================
# =========| El script ha terminado su ejecución, el equipo se reiniciara en 5 segundos. |==========
# ==================================================================================================
clear
echo "Fin del script de personalización de Ubuntu 24.04 LTS!"
echo "Reiniciando en 5 segundos para aplicar cambios..."
sleep 5
reboot
# ==================================================================================================
