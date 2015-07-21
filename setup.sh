#!/bin/bash

PASS=$( openssl rand -hex 32 )
#setup without the installation of all the dependencies               
####################################################
#Database setup...
echo "Do you wish to resetup the config OLD CONFIG AND DB WILL BE LOST!!!!!!!! ?" yn
select yn in "Yes" "No"; do
        case $yn in
                Yes )
                        rm ../../config/galaxy.ini
                        echo "DROP DATABASE rdfdb" | sudo -u postgres psql postgres
                        echo "DROP USER rdf" | sudo -u postgres psql postgres
                break;;
                No )
                break;;
        esac
done
echo "CREATE USER rdf WITH PASSWORD 'rdf$PASS'" | sudo -u postgres psql postgres
sudo -u postgres createdb --owner=rdf rdfdb
####################################################
#Galaxy configure scripts
cp ./settings/tool_conf.xml ../../config/
cp ./settings/datatypes/*.py ../../lib/galaxy/datatypes/
#IF file already exists skip
if [ ! -f ../../config/galaxy.ini ]; then
        #Run replace command tobereplaced@email.com
        echo "Type in the email adress that will be used for galaxy admin user:"
        read emailGalaxy
        sed -e s/tobereplaced@email.com/$emailGalaxy/g ./settings/galaxy.ini.sample | sed -e s/rdf1234/rdf$PASS/g > ../../config/galaxy.ini
fi
cp ./settings/datatypes_conf.xml ../../config/
cp -r settings/static/ ../../
