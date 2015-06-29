#!/bin/bash
#The instalation script for all Downloads

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
PASS=$( openssl rand -hex 32 )

echo "Do you wish to install all dependencies automatically (admin rights needed)?" yn
select yn in "Yes" "No"; do
	case $yn in
		Yes )

		if [ "$(uname)" == "Darwin" ]; then
				# Do something under Mac OS X platform	 
				# No display in screen session needed, run galaxy in daemon mode and pathway Downloads should work fine...   
				echo "Mac detected but not yet supported :("
				#break
		elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
			#Dependency to run screens in a screensession
			sudo apt-get install xvfb 
                        #install java 8
                        sudo add-apt-repository ppa:webupd8team/java
                        sudo apt-get update
                        sudo apt-get install oracle-java8-installer
                        sudo update-java-alternatives -s java-8-oracle

                        #maven2,git, nodejs and html2text
                        sudo apt-get install maven2 git nodejs html2text npm
		elif [ "$(expr substr $(uname -s) 1 10)" == "MINGW32_NT" ]; then
			echo "I am sorry but I am unable to run this under windows..."
			break
		fi
		####################################################
		#ORACLE Database setup...
		sudo apt-get install postgresql postgresql-contrib
		echo "CREATE USER galaxy WITH PASSWORD 'galaxy$PASS'" | sudo -u postgres psql postgres
		sudo -u postgres createdb --owner=galaxy galaxydb
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
		####################################################
		#Folder initialization
		mkdir ./Programs/
		####################################################
		#Installation of apache-jena-2.13.0
                if ! which tdblodader >/dev/null; then
                    cat "export JENAROOT=$DIR/Programs/apache-jena-2.13.0" >> ~/.bash.rc
                    cat "PATH=$JENAROOT/bin:$PATH" >> ~/.bash.rc
		    if [ ! -d ./Programs/apache-jena-2.13.0/ ]; then
			wget -nc http://apache.cs.uu.nl/jena/binaries/apache-jena-2.13.0.tar.gz -P ./Downloads/
			tar -kxvf ./Downloads/apache-jena-2.13.0.tar.gz -C ./Programs/
		    fi
                fi
		#Installation of apacke fuseki
		#if [ ! -d ./Programs/jena-fuseki1-1.1.2/ ]; then
		#	wget -nc http://mirror.nl.webzilla.com/apache/jena/binaries/jena-fuseki1-1.1.2-distribution.tar.gz -P ./Downloads/
		#	tar -kxvf ./Downloads/jena-fuseki1-1.1.2-distribution.tar.gz -C ./Programs/
		#fi
		####################################################

		break;;

		No ) exit;;
	esac
done
