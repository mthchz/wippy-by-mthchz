# Wippy by mthchz
Version customisée du script d'automatisation de l'installation et configuration de Wordpress par [@maximebj](https://twitter.com/maximebj)

*Ce srcrip est utilisé sous MAC OSX El captain, non testé sous Windows.*

## Pré-requis
Installez WP-CLI : [http://wp-cli.org/](http://wp-cli.org/)

Testez la bonne installation en tapant *wp* dans le terminal.

## Documentation WP-CLI
[Documentation de WP-CLI](http://wp-cli.org/commands/)

## Avec MAMP
Pour les utilisateurs de MAMP, il faut faire une petite modification du fichier .bash_profile et/ou .profile, simplement en suivant les instructions de [ce topic Stackoverflow](http://stackoverflow.com/questions/4145667/how-to-override-the-path-of-php-to-use-the-mamp-path/10653443#10653443)

La varibale *MAMP_PHP*, doit **ABSOLUMENT être placé avant la varibale ${PATH}** et/ou toutes les autres déclarations de cette variable (sinon ça marche pas, le système va chercher la version PHP sytème et non celle de MAMP).

Pensez à modifier la version PHP dans le chemin de la librairie php par celle de MAMP (/Applications/MAMP/bin/php/**phpx.x.x**/bin). Pour la connaitre, dans MAMP, Settings > PHP.

Pour vérifier la version de PHP utilisée par le système :
   * Soit par une commande système : *php -v* et/ou *which php*. La première doit donnée la même version que MAMP. La deuxième le chemin vers la librairie php de MAMP.
   * Soit par une commande WP CLI : *wp --info*. Idem, on doit retrouvé les informations de MAMP.

## Utilisation
Avant d'éxécuter Wippy :
   1. Placez le repertoire */wippy* à la racine du localhost (optionnel),
   2. Editez le fichier */wippy/config.txt* en renseignant les informations des différentes variables,
   3. (Optionnel) Editez, en ajoutant/supprimant les plugins souhaités à l'installation dans le fichier */wippy/plugins.txt*,
   4. (Optionnel) Editez, en commentant/décommentant les étapes voulus dans le script */wippy/wippy.sh*.

Une fois que tout est prêt, on prépare l'installation et on lance Wippy :
   1. Ouvrir le terminal,
   2. Se placer dans le repertoire de Wippy : cd /path/to/localhost/wippy (ou en glissant le repertoire dans le terminal),
   3. Lancer Wippy avec ses paramètres : *bash wippy.sh <repertoire du site> <url du site> <Nom du site>*
      * **Repertoire du site :** chemin complet pour l'installation du site *(ex : /Users/mthchz/Sites/2015/client/monNouveauWordpress/)*. Pour pas se tromper dans le chemin, glissez le dossier dans le terminal puis ajouter le nom du repertoire pour le site.
      * **Url du site :** URL complete utilisée pour le site *(ex : http://localhost:8888/2015/client/monNouveauWordpress ou http://wp.client.2015 si vous utilisez des sous-domaines)*
      * **Nom du site :** Le nom du site, qui sera ajouté au paramètre WP, à mettre entre quotes.
   4. Laissez vous ensuite guider par Wippy, et remplissez les différents champs demandés, et c'est prêt !

> Exemple de commande : bash wippy.sh /Users/mthchz/Sites/2015/client/monNouveauWordpress http://wp.client.2015 "Mon nouveau Wordpress"

## Les erreurs possibles
**Erreur pendant l'installation :** Si il y a une erreur pendant l'installation, il faudra faire le ménage, en supprimant la table SQL qui a été crée, et les fichiers de Wordpress dans le repertoire du site.

**Connexion à la base de données n'a pas pu être faite :** Si lors de l'installation de Wordpress (après la création de la base), une erreur s'affiche disant que la connexion à la base de données n'a pas pu être faite :
   1. Vérifier les informations de connexion au MySQL de MAMP dans le fichier config.txt
   2. Vérifier que la version PHP utilisée est bien celle de MAMP.

**Mauvais paramètrage de la page d'accueil et d'actualités :** Si vous avez ajouter l'activiation automatique des plugins à l'installation, certains plugins ajoutent du contenu et peuvent provoquer un mauvais paramètrage de la page d'accueil et d'actualités via Wippy.

## Crédits
* Projet orignal par [@maximebj](https://twitter.com/maximebj) : [Tuto WP-CLI : Comment installer et configurer wordpress en moins d’une minute et en seulement un clic](http://www.wp-spread.com/tuto-wp-cli-comment-installer-et-configurer-wordpress-en-moins-dune-minute-et-en-seulement-un-clic/)
* [WP-CLI](http://wp-cli.org/)
* [Proximit Agency](http://www.proximit-agency.fr)
