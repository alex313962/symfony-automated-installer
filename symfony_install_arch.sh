
#!/bin/sh
cd ~/


sudo apt update

while true; do
    read -p "Do you want to do a full-upgrade?" upgrade
    case $upgrade in
        [Yy]* ) sudo pacman -Syu --noconfirm; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

if ! command -v paru >/dev/null 2>&1; then
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

paru -Sy --needed php$version apache wget php$version-intl composer
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
