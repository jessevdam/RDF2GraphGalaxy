#!/bin/bash
#The instalation script for all Downloads

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

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

                #git submodule init
                git submodule update
                ./programs/RDF2Graph/setup.sh 
                #git submodule foreach git pull

                sudo apt-get install postgresql postgresql-contrib
                ./setup.sh
                ####################################################
                #Folder initialization
                mkdir ./Programs/
                ####################################################
                #Installation of apache-jena-3.0.1
                if ! which tdblodader >/dev/null; then
                    echo "export JENAROOT=$DIR/Programs/apache-jena-3.0.1" >> ~/.bashrc
                    echo "PATH=\$JENAROOT/bin:\$PATH" >> ~/.bashrc
                if [ ! -d ./Programs/apache-jena-3.0.1/ ]; then
                        wget -nc http://apache.xl-mirror.nl/jena/binaries/apache-jena-3.0.1.tar.gz -P ./Downloads/
                        tar -kxvf ./Downloads/apache-jena-3.0.1.tar.gz -C ./Programs/ 
                        cp $DIR/settings/jena-log4j.properties $DIR/Programs/apache-jena-3.0.1/
                fi
                if [ -d $DIR/Programs/apache-jena-2.13.0 ]; then
                  rm -r $DIR/Programs/apache-jena-2.13.0
                fi
                fi
                echo "Please make sure that at least one app is installed in Cytoscape othwise scripting functionality does not work in Cytoscape (BUG Cytoscape)"
                if ! which Cytoscape >/dev/null; then
                    echo "PATH=$DIR/Programs/cytoscape:\$PATH" >> ~/.bashrc
                    #untested
                    if [ ! -d ./Programs/cytoscape/ ]; then
                        wget -nc http://chianti.ucsd.edu/cytoscape-3.2.0/Cytoscape_3_2_0_unix.sh -P ./Downloads/
                        chmod +x ./Downloads/Cytoscape_3_2_0_unix.sh
                        ./Downloads/Cytoscape_3_2_0_unix.sh -q -dir $DIR/Programs/cytoscape
                    fi
                fi
                #Installation of apacke fuseki
                #if [ ! -d ./Programs/jena-fuseki1-1.1.2/ ]; then
                #        wget -nc http://mirror.nl.webzilla.com/apache/jena/binaries/jena-fuseki1-1.1.2-distribution.tar.gz -P ./Downloads/
                #        tar -kxvf ./Downloads/jena-fuseki1-1.1.2-distribution.tar.gz -C ./Programs/
                #fi
                ####################################################

                break;;

                No ) exit;;
        esac
done
