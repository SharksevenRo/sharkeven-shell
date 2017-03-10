sudo add-apt-repository ppa:webupd8team/java
sudo apt-get update
sudo apt-get install oracle-java8-installer -y

wget http://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz

tar xzvf apache-maven-3.3.9-bin.tar.gz
mv apache-maven-3.3.9 /opt/maven
echo 'export M2_HOME=/opt/maven' >> /etc/profile
echo 'PATH=$M2_HOME/bin:$PATH' >> /etc/profile
source /etc/profile
