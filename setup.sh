# Update System to latest binaries.
sudo apt-get update
sudo apt-get upgrade

# Default Raspian does not have all locales
# Causes Perl environment errors during apt process.
#
# This takes a while to run, so hopefully we can 
# do it once and keep in base image. Uncomment to setup locales
#sudo apt-get install locales
#dpkg-reconfigure locales

# Install packages for ZTP Process.
# Expect some of these to fail startup process.
sudo apt-get install isc-dhcp-server
sudo apt-get install nginx-full
sudo apt-get install atftpd
sudo apt-get install vsftpd
sudo apt-get install git

# Install generic network tools
sudo apt-get install screen
sudo apt-get install mtr
sudo apt-get install nmap
sudo apt-get install traceroute
sudo apt-get install whois
sudo apt-get install tcpdump
sudo apt-get install dhcpdump

# Create Base directory structure.
# This will be moved to a git repo before final
sudo groupadd ztp
sudo usermod -a -G ztp pi

sudo mkdir /ztp
sudo mkdir /ztp/etc
sudo mkdir /ztp/files
sudo mkdir /ztp/utils
sudo chgrp -R ztp /ztp
sudo chmod -R 775 /ztp/

# Insert step here to copy files from remote repo

# Set vsftpd user homedir to /ztp/files
sudo usermod -d /ztp/files ftp
sudo rm -rf /srv/ftp
sudo ln -s /ztp/files /srv/ftp
sudo rm -rf /etc/vsftpd.conf
sudo ln -s /ztp/etc/vsftpd.conf /etc/vsftpd.conf
sudo /etc/init.d/vsftpd restart

# Set vsftpd user homedir to /ztp/files
sudo rm -rf /etc/default/atftpd
sudo rm -rf /srv/tftp
sudo ln -s /ztp/files /srv/tftp
sudo ln -s /ztp/etc/atftpd /etc/default/atftpd
sudo update-rc.d atftpd defaults
sudo touch /var/log/atftpd.log
sudo chown nobody.nogroup /var/log/atftpd.log
sudo /etc/init.d/atftpd restart


# Set ISC to source files from /ztp/etc which sets DHCP to eth1 and default config
sudo rm -rf /etc/default/isc-dhcp-server
sudo rm -rf /etc/dhcp/dhcpd.conf
sudo ln -s /ztp/etc/isc-dhcp-server /etc/default/isc-dhcp-server
sudo ln -s /ztp/etc/dhcpd.conf /etc/dhcp/dhcpd.conf
sudo update-rc.d isc-dhcp-server defaults
sudo /etc/init.d/isc-dhcp-server restart

# Make Symbolic link for nginx webroot to point to /ztp/files
sudo rm -rf /usr/share/nginx/www
sudo ln -s /ztp/files /usr/share/nginx/www
sudo update-rc.d nginx defaults
sudo /etc/init.d/nginx restart

# Repoint rsyslog file + enable network syslog
sudo rm -rf /etc/rsyslog.conf
sudo ln -s /ztp/etc/rsyslog.conf /etc/rsyslog.conf
sudo ln -s /ztp/etc/rsyslogd-ztp /etc/rsyslog.d/ztp_log.conf
sudo ln -s /ztp/etc/logrotate-ztp /etc/logrotate.d/ztp
sudo /etc/init.d/rsyslog restart
