# Install Docker-CE on Yum based OS
#echo '[dockerrepo]' > /etc/yum.repos.d/docker.repo
#echo 'name=Docker Repository' >> /etc/yum.repos.d/docker.repo
#echo 'baseurl=https://yum.dockerproject.org/repo/main/centos/7/' >> /etc/yum.repos.d/docker.repo
#echo 'enabled=1' >> /etc/yum.repos.d/docker.repo
#echo 'gpgcheck=0' >> /etc/yum.repos.d/docker.repo
#yum clean all
#yum -y install docker-engine-1.12.3
#service network restart
#sysctl -w net.ipv4.ip_forward=1
#service docker start

# Install Docker CE on ubuntu
# Ref: https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#recommended-extra-packages-for-trusty-1404
sudo apt-get update
# Install the linux-image-extra-* packages, which allow Docker to use the aufs storage drivers.
sudo apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual

# Install packages to allow apt to use a repository over HTTPS:
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Add Docker’s official GPG key:
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# set up the stable repository.
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install the latest version
sudo apt-get update
sudo apt-get install docker-ce

# To install a specific version:
# List the available versions
#apt-cache madison docker-ce
# Install the choosen version
#sudo apt-get install docker-ce=<VERSION>
