echo -e "This is an Installation Script For ==>> "
echo ""
echo "Server Version : Ubuntu 18.04"
echo "FreePBX Version : FreePBX 14"
echo "Asterisk Version: Asterisk 13.18.3"
echo ""

echo "The script will only work if you are ROOT user"
echo "Become ROOT user if you did not already"
echo ""


echo "The script will work for the clean server image without any installation"
echo "If you want to reinstall FreePBX, the script will fail"
echo ""

echo "https://wiki.freepbx.org/display/FOP/Installing+FreePBX+14+on+Ubuntu+18.04 page is used"
echo ""


while true; do
            read -p "Do you wish to install this program? [Y/N]" yn
                case $yn in
                                [Yy]* )
                                                        apt-get update
                                                        apt-get upgrade

                                                        #Enable ssh logins as root.

                                                        sed -ir 's/#?PermitRootLog.+/PermitRootLogin yes/' /etc/ssh/sshd_config
                                                        systemctl restart sshd


                                                        #Update Your System

                                                        #You must run the entire process as root.

                                                        add-apt-repository ppa:ondrej/php < /dev/null
                                                        apt-get update && apt-get upgrade

                                                        #You must have older php5.6 for the FreePBX 15 usage

                                                        apt-get install -y openssh-server apache2 mysql-server mysql-client \
                                                                      mongodb curl sox mpg123 sqlite3 git uuid libodbc1 unixodbc unixodbc-bin \
                                                                        asterisk asterisk-core-sounds-en-wav asterisk-core-sounds-en-g722 \
                                                                          asterisk-dahdi asterisk-flite asterisk-modules asterisk-mp3 asterisk-mysql \
                                                                            asterisk-moh-opsound-g722 asterisk-moh-opsound-wav asterisk-opus \
                                                                              asterisk-voicemail dahdi dahdi-dkms dahdi-linux libapache2-mod-security2 \
                                                                                php5.6 php5.6-cgi php5.6-cli php5.6-curl php5.6-fpm php5.6-gd php5.6-mbstring \
                                                                                  php5.6-mysql php5.6-odbc php5.6-xml php5.6-bcmath php-pear libicu-dev gcc \
                                                                                    g++ make postfix libapache2-mod-php5.6

                                                          #As part of this install, you may be asked (possibly several times) for a mysql password. DO NOT SET A MYSQL PASSWORD AT THIS POINT.


                                                            #Install nodejs

                                                            curl -sL https://deb.nodesource.com/setup_10.x | bash -
                                                            apt-get install  nodejs


                                                              #Fix permissions for the Asterisk user

                                                              useradd -m asterisk
                                                              chown asterisk. /var/run/asterisk
                                                              chown -R asterisk. /etc/asterisk
                                                              chown -R asterisk. /var/{lib,log,spool}/asterisk
                                                              chown -R asterisk. /usr/lib/asterisk
                                                              chsh -s /bin/bash asterisk
                                                              rm -rf /var/www/html



                                                                #Remove any 'sample' config files left over, and fix errors

                                                                rm -rf /etc/asterisk/ext* /etc/asterisk/sip* /etc/asterisk/pj* /etc/asterisk/iax* /etc/asterisk/manager*
                                                                sed -i 's/.!.//' /etc/asterisk/asterisk.conf


                                                                  #Update Apache configuration
                                                                  sed -i 's/\(^upload_max_filesize = \).*/\120M/' /etc/php/5.6/cgi/php.ini
                                                                  sed -i 's/www-data/asterisk/' /etc/apache2/envvars
                                                                  sed -i 's/AllowOverride None/AllowOverride All/' /etc/apache2/apache2.conf
                                                                  a2enmod rewrite
                                                                  service apache2 restart


                                                                    #Fix 'Pear-GetOpt' compatibility issue.
                                                                    sed -i 's/ each(/ @each(/' /usr/share/php/Console/Getopt.php


                                                                      #Install MySQL ODBC Connector
                                                                      mkdir -p /usr/lib/odbc
                                                                      curl -s http://ftp.airnet.ne.jp/mirror/mysql/Downloads/Connector-ODBC/5.3/mysql-connector-odbc-5.3.11-linux-ubuntu18.04-x86-64bit.tar.gz  | \
                                                                                          tar -C /usr/lib/odbc --strip-components=2 --wildcards -zxvf - */lib/*so



                                                                        #Configure ODBC

                                                                        cat > /etc/odbc.ini << EOF
[MySQL-asteriskcdrdb]
Description=MySQL connection to 'asteriskcdrdb' database
driver=MySQL
server=localhost
database=asteriskcdrdb
Port=3306
Socket=/var/run/mysqld/mysqld.sock
option=3
Charset=utf8
EOF

cat > /etc/odbcinst.ini << EOF
[MySQL]
Description=ODBC for MySQL
Driver=/usr/lib/odbc/libmyodbc5w.so
Setup=/usr/lib/odbc/libodbcmy5S.so
FileUsage=1
EOF


#Fix Ubuntu/Debian Paths

rm -rf /var/lib/asterisk/moh
ln -s /usr/share/asterisk/moh /var/lib/asterisk/moh
rm -rf /usr/share/asterisk/sounds
ln -s /var/lib/asterisk/sounds /usr/share/asterisk/sounds
chown -R asterisk.asterisk /usr/share/asterisk




#Download and Install FreePBX 14.

cd /usr/src
wget http://mirror.freepbx.org/modules/packages/freepbx/freepbx-14.0-latest.tgz
tar zxf freepbx-14.0-latest.tgz
cd freepbx
./install -n
;;

        [Nn]* ) exit;;
                * ) echo "Please answer yes or no.";;
                    esac
            done