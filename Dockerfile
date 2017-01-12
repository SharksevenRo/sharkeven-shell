FROM nginx

MAINTAINER shark 'shark@dodora.cn'


RUN apt-get update
RUN apt-get install git -y



RUN mkdir /root/workspace

# git clone

RUN git clone https://github.com/Gospely/hello_php.git /root/workspace


WORKDIR  /root/workspace

CMD [ "php", "./index.php" ]

EXPOSE 22
EXPOSE 80
EXPOSE 9000

ENTRYPOINT /bin/bash
