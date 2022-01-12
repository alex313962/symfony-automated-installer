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
php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php 
php -r "unlink('composer-setup.php');"
sudo mv composer.phar /usr/local/bin/composer
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
