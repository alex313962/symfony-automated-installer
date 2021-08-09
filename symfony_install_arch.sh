
#!/bin/sh
cd ~/


sudo pacman -Sy --needed git

sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
sudo pacman-key --lsign-key 3056513887B78AEB
sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
echo '[chaotic-aur]' | tee -a /etc/pacman.conf
echo 'Include = /etc/pacman.d/chaotic-mirrorlist' | tee -a /etc/pacman.conf
echo '' | tee -a /etc/pacman.conf

while true; do
    read -p "Do you want to do a full-upgrade?" upgrade
    case $upgrade in
        [Yy]* ) sudo pacman -Syu --noconfirm; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if ! command -v paru &> /dev/null ; then
  sudo pacman -S --needed base-devel
  git clone https://aur.archlinux.org/paru.git
  cd paru
  makepkg -si
  cd ..
  rm -r paru
fi
 
while true; do
    read -p "Which php version you want to install?" version
    case $version in
        "7.4" )
         version=74 
         echo 7.4; break;;
        "8.0" )
         version=80
         echo 8.0; break;;
        * ) echo "Please answer 7.4 or 8.0";;
    esac
done
php$version -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php$version -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php$version composer-setup.php 
php$version -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
paru -Sy --needed php$version apache wget php$version-intl 
sudo sed -i 's/;extension=iconv/extension=iconv/' /etc/php/php.ini
sudo sed -i 's/;extension=intl/extension=intl/' /etc/php/php.ini

wget https://get.symfony.com/cli/installer -O - | bash
sudo mv ~/.symfony/bin/symfony /usr/local/bin/symfony
symfony check:requirements
sudo mkdir /var/www/git

while true; do
    read -p "is the user $USER the owner of this symfony installation/project?" default_user
    case $default_user in
        [Yy]* ) sudo chown -R $USER:$USER /var/www/git;break;;
        [Nn]* ) while true; do
                    read -p "insert the user that must own symfony" selected_user
                    sudo chown -R $selected_user:$selected_user /var/www/git
                done; 
                break;;
        * ) echo "Please answer yes or no.";;
    esac
done


echo "if symfony check is successfull, you can start to use Symfony"
echo "and create new project with "
echo "symfony new your-awesome-project-name --full"
