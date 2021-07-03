#!/bin/bash
set -e

# Add environement variable of apache in this context
source /etc/apache2/envvars

# Source variable of docker to make use of JOOMLA_SRC_PATH
source /.env

JOOMLA_ARCHIVE="https://www.joomla.fr/joomla/telecharger-joomla?task=download&collection=seb_download_full_package&xi=0&file=seb_download_full_package&id=15514"

# Override default folder of apache
APACHE_RUN_DIR="/var/$JOOMLA_SRC_PATH"

# TODO maybe passer par un ADD (dans le dockerfile) plutot ce serais bien plus
# TODO rapide juste il faut convertir le zip en tar.gz.... Apres on perd le fait
# TODO que le container ne se reset pas

# If no joomla installation is found download and unzip it
if [ ! -f "$APACHE_RUN_DIR/configuration.php" ]; then
	echo "Joomla not present downloading..."
	# Download joomla archive
	wget -q -O joomla3-9.zip $JOOMLA_ARCHIVE

	echo "unziping..."
	#  unzip & access right joomla
	unzip joomla3-9.zip -d $APACHE_RUN_DIR && \
	chown -R www-data:www-data $APACHE_RUN_DIR && \
	chmod -R 755 $APACHE_RUN_DIR

	echo "Done !"
fi

# disable default config and enable joomla config
a2dissite 000-default.conf
a2ensite joomla.conf

#run apache in foreground to keep container running
exec apache2 -DFOREGROUND