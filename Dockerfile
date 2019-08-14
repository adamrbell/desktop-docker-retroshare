FROM linuxserver/docker-baseimage-guacgui

# set variables
# User/Group Id gui app will be executed as default are 99 and 100
ENV USER_ID=99 GROUP_ID=100 APP_NAME="Retroshare" WIDTH=1280 HEIGHT=720 TERM=xterm

# Use baseimage-docker's init system
CMD ["/sbin/my_init"]

# Add local files
ADD src/ /

#Install instructions from https://retroshare.cc/downloads.html
RUN source /etc/os-release && \
wget -qO - https://download.opensuse.org/repositories/network:/retroshare/xUbuntu_${VERSION_ID}/Release.key | sudo apt-key add - && \
sudo sh -c "echo 'deb https://download.opensuse.org/repositories/network:/retroshare/xUbuntu_${VERSION_ID}/ /' >> /etc/apt/sources.list.d/retroshare_OBS.list" && \

# repositories
echo 'deb http://ppa.launchpad.net/retroshare/stable/ubuntu bionic main' >> /etc/apt/sources.list && \
echo 'deb-src http://ppa.launchpad.net/retroshare/stable/ubuntu bionic main' >> /etc/apt/sources.list && \

#RUN echo 'deb http://archive.ubuntu.com/ubuntu bionic main universe restricted' > /etc/apt/sources.list && \
#echo 'deb http://archive.ubuntu.com/ubuntu bionic-updates main universe restricted' >> /etc/apt/sources.list && \
#add-apt-repository ppa:retroshare/stable && \

# install dependencies
apt-get update && \ 
apt-get install -y \
gnome-themes-standard \
# install retroshare
retroshare \
# install pyshaper dependencies
build-essential \
iproute2 \
python \
python-geoip \
python-setuptools \
subversion && \
# install SQLObject
cd /tmp && \
svn co http://svn.colorstudy.com/SQLObject/branches/0.6/ && \
cd 0.6 && \
easy_install . && \
python setup.py install && \
# install ezsqlobject
cd /tmp &&\ 
wget http://freenet.mcnabhosting.com/python/ezsqlobject/ezsqlobject-0.1.1.tar.gz && \
tar -xzvf ezsqlobject-0.1.1.tar.gz && \
cd ezsqlobject-0.1.1 && \
python setup.py install && \
# download pyshaper to /tmp
cd /tmp && \
wget http://freenet.mcnabhosting.com/python/pyshaper/pyshaper-0.1.3.tar.gz && \
tar -xzvf pyshaper-0.1.3.tar.gz && \
cd pyshaper-0.1.3 && \
make install && \

# clean up
apt-get clean && \
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 8080
#VOLUME /config /downloads
VOLUME /nobody/.retroshare/ /downloads
