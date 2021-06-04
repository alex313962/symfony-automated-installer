#!/bin/sh
cd ~/


sudo apt update

while true; do
    read -p "Do you want to do a full-upgrade?" upgrade
    case $upgrade in
        [Yy]* ) sudo apt full-upgrade -y; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done
 
sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
sudo add-apt-repository ppa:ondrej/apache2 -y
sudo apt update
while true; do
    read -p "Which php version you want to install?" version
    case $version in
        "7.4" )

         echo 7.4; break;;
        "8.0" )
        
         echo 8.0; break;;
        * ) echo "Please answer 7.4 or 8.0";;
    esac
done

sudo apt install php$version apache2 wget git php$version-xml php$version-mbstring php$version-intl php$version-mysql php$version-curl
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('sha384', 'composer-setup.php') === '756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php 
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
wget https://get.symfony.com/cli/installer -O - | bash
sudo mv ~/.symfony/bin/symfony /usr/local/bin/symfony
symfony check:requirements
sudo mkdir /var/www/git
while true; do
    read -p "is the user $user the owner of this symfony installation/project?" default_user
    case $default_user in
        [Yy]* ) sudo chown $user:$user git;break;;
        [Nn]* ) while true; do
                    read -p "insert the user that must own symfony" selected_user
                    sudo chown $selected_user:$selected_user git
                done break;;
        * ) echo "Please answer yes or no.";;
    esac
done

while true; do
    read -p "insert your git username" gitUsername
    git config --global user.name $gitUsername 
done

while true; do
    read -p "insert your git email" gitEmail
    git config --global user.email $gitEmail 
done

echo "if symfony check is successfull, you can start to use Symfony"
echo "and create new project with "
echo "symfony new your-awesome-project-name --full"
