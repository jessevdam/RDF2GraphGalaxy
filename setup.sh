#!/bin/bash
#setup without the installation of all the dependencies               
####################################################
#ORACLE Database setup...
sudo apt-get install postgresql postgresql-contrib
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
        sed -e s/tobereplaced@email.com/$emailGalaxy/g ./settings/galaxy.ini.sample | sed -e s/galaxy1234/galaxy$PASS/g > ../../config/galaxy.ini
fi
cp ./settings/datatypes_conf.xml ../../config/
cp -r settings/static/ ../../static/
