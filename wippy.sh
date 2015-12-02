#!/bin/bash
#
# Wippy (｡◕‿◕｡)
# Automatize your WordPress installation
#
# By @mthchz (Proximit), based on @maximebj project (maxime@smoothie-creative.com)
#
# *** Recommended for Lazy people like me ***
#
# How to launch wippy ?
# cd /path/to/localhost/wippy
# bash wippy.sh <repertoire du site> <url du site> <Nom du site>
#     > $1 (Repertoire du site) chemin complet pour l'installation du site (ex : /Users/mthchz/Sites/2015/client/monNouveauWordpress/). Pour pas se tromper dans le chemin, glissez le dossier dans le terminal puis ajouter le nom du repertoire pour le site.
#     > $2 (Url du site) URL complete utilisée pour le site (ex : http://localhost:8888/2015/client/monNouveauWordpress ou http://wp.client.2015 si vous utilisez des sous-domaines)
#     > $3 (Nom du site) Le nom du site, qui sera ajouté au paramètre WP, à mettre entre quotes.

# Configuration
. "config.txt"

# local url login
# --> Change to fit your server URL model (eg: http://localhost:8888/my-project)
sitedir=$1
url=$2
sitename=$3

# path to plugins.txt
pluginfilepath="$(pwd)/plugins.txt"

# end Configuration ---

#  ===============
#  = Fancy Stuff =
#  ===============
# not mandatory at all

# Stop on error
set -e

# colorize and formatting command line
# You need iTerm and activate 256 color mode in order to work : http://kevin.colyar.net/wp-content/uploads/2011/01/Preferences.jpg
green='\x1B[0;32m'
cyan='\x1B[1;36m'
blue='\x1B[0;34m'
grey='\x1B[1;30m'
red='\x1B[0;31m'
bold='\033[1m'
normal='\033[0m'

# Jump a line
function line {
  echo " "
}

# Wippy has something to say
function bot {
  line
  echo -e "${blue}${bold}(｡◕‿◕｡)${normal}  $1"
}
function agree {
  line
  echo -e "${green}${bold}(｡◕‿◕｡)${normal}  $1"
}
function question {
  printf "         ${blue}${bold}[?]${normal} $1 : "
}

#  ===============
#  = HELP =
#  ===============
if [ $1 = "help" ]
then
    line
    echo -e "         ${bold}bash wippy.sh <repertoire du site> <url du site> <Nom du site>${normal}"
    line
    echo -e "         ${bold}<repertoire du site>${normal} chemin complet pour l'installation du site (ex : /Users/mthchz/Sites/2015/client/monNouveauWordpress). Pour pas se tromper dans le chemin, glissez le dossier dans le terminal puis ajouter le nom du repertoire pour le site."
    echo -e "         ${bold}<url du site>${normal} URL complete utilisée pour le site (ex : http://localhost:8888/2015/client/monNouveauWordpress ou http://wp.client.2015 si vous utilisez des sous-domaines)"
    echo -e "         ${bold}<Nom du site>${normal} Le nom du site, qui sera ajouté au paramètre WP, à mettre entre quotes."
    echo -e "         Exemple de commande : bash wippy.sh /Users/mthchz/Sites/2015/client/monNouveauWordpress http://wp.client.2015 \"Mon nouveau Wordpress\""
    line
    line

    # Lire le readme.txt ?
    while true; do
        read -p "Voulez-vous lire le readme.txt ? [Y/N] " yn
        case $yn in
            [Yy]* ) cat "readme.md"; break;;
            [Nn]* ) break;;
            * ) echo "Please answer yes or no.";;
        esac
    done

    exit 1
fi

#  ==============================
#  = The show is about to begin =
#  ==============================

# Welcome !
bot "${blue}${bold}Bonjour ! Je suis Wippy.${normal}"
echo -e "         Je vais installer WordPress pour votre site : ${cyan}$2${normal}"

# On regarde si le repertoire n'existe pas
if [ -d ".$sitedir" ]; then
  echo "${red}Le dossier ${cyan}$1${red}existe déjà${normal}."
  echo "         Par sécurité, je ne vais pas plus loin pour ne rien écraser."
  exit 1 # quit script
fi

# Création du repertoire
bot "Je crée le dossier : ${cyan}$sitedir${normal}"
mkdir $sitedir

# On s'y rend
bot "Je me place dans le dossier créé..."
cd $sitedir

# Download WP
bot "Je télécharge WordPress..."
wp core download --locale=fr_FR --force

# On demande le nom de la base à créer...
while [ -z ${dbname} ]; do
bot "Saisir le nom de la base de donnée à créer :"
line
question "Nom de la base de données"
read dbname
done
agree "Je vais créer la base de données ${bold}${cyan}$dbname${normal}"

while [ -z ${dbprefix} ]; do
bot "Saisir le prefix pour les tables de la base de donnée :"
line
question "Prefix de la base de données (format : wp_)"
read dbprefix
done
agree "C'est parti pour ${bold}${cyan}$dbprefix${normal}"

# create base configuration
bot "Je lance la configuration..."
wp core config --dbname=$dbname --dbuser=${dbuser} --dbpass=${dbpass} --dbprefix=${dbprefix} --skip-check --extra-php <<PHP
define('WP_POST_REVISIONS', 3);
define('DISALLOW_FILE_EDIT', true);
PHP

# Create database
bot "Je crée la base de données..."
wp db create

# launch install
bot "et j'installe !"
wp core install --url=$url --title="$sitename" --admin_user=$admin --admin_email=$email --admin_password=$password

# Plugins install
bot "J'installe les plugins à partir de la liste des plugins :"
cat $pluginfilepath
line
while read line
do
    wp plugin install $line
done < $pluginfilepath

# Download theme from git repository
bot "Je télécharge le thème Paperplane (Proximit Agency starter theme) :"
cd wp-content/themes/ # On se place dans wp-content/themes
git clone https://github.com/mthchz/paperplane.git
wp theme activate paperplane

# Download mu-plugin from git repository
bot "Je télécharge le MU plugin de configuration de base"
cd .. # On remonte dans wp-content
git clone https://github.com/mthchz/mu-plugins.git

# Create standard pages
bot "Je crée les pages habituelles (Accueil, blog, contact...)"
wp post create --post_type=page --post_title='Accueil' --post_status=publish
wp post create --post_type=page --post_title='Actualités' --post_status=publish
wp post create --post_type=page --post_title='Contact' --post_status=publish
wp post create --post_type=page --post_title='Mentions Légales' --post_status=publish

# Create fake posts
bot "Je crée quelques faux articles"
curl http://loripsum.net/api/5 | wp post generate --post_content --count=5

# Change Homepage
bot "Je met à jour les paramètres de $sitename"
wp option update show_on_front page
wp option update page_on_front 3
wp option update page_for_posts 4
wp option update timezone_string "Europe/Paris"
wp option update date_format "j F Y"
wp option update time_format "G\\hi"
wp option update rss_use_excerpt "1"
wp option update blog_public "0"
wp option update default_pingback_flag "0"
wp option update default_ping_status "0"

# Menu stuff
bot "Je crée le menu principal, assigne les pages, et je lie l'emplacement du thème : "
wp menu create "mainmenu"
wp menu item add-post mainmenu 3
wp menu item add-post mainmenu 4
wp menu item add-post mainmenu 5
wp menu location assign mainmenu header-menu

# Misc cleanup
bot "Je supprime Hello Dolly, les thèmes de base, les articles exemples et les widget par defaut"
wp post delete 1 --force # Article exemple - no trash. Comment is also deleted
wp post delete 2 --force # page exemple
wp plugin delete hello
wp theme delete twentyfifteen
wp theme delete twentythirteen
wp theme delete twentyfourteen
wp widget delete search-2 recent-posts-2 recent-comments-2 archives-2 categories-2 meta-2
wp option update blogdescription ''

# TODO : Not working (Warning: Regenerating a .htaccess file requires special configuration. See usage docs.)
# Permalinks to /%postname%/
# bot "J'active la structure des permaliens"
# wp rewrite structure "/%postname%/" --hard
# wp rewrite flush --hard

# Copy password in clipboard
bot "Une dernière petits chose..."
while true; do
    read -p "Voulez-vous que je copie le mot de passe dans le presse-papier ? [Y/N] " yn
    case $yn in
        [Yy]* ) echo $password | pbcopy; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# Open in browser
open $url
open "${url}/wp-admin"

# That's all ! Install summary
bot "${green}L'installation est terminée !${normal}"
line
echo "URL du site:   $user"
echo "Login admin :  $admin"
echo -e "Password :  ${cyan}${bold} $password ${normal}${normal}"
line
echo -e "${grey}(N'oubliez pas le mot de passe ! Je l'ai copié dans le presse-papier)${normal}"

line
bot "à Bientôt !"
line
line
