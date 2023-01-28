FROM centos:latest
LABEL MAINTAINER codingmywork@gmail.com 
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
RUN yum -y install java

ADD https://www.free-css.com/assets/files/free-css-templates/download/page287/eflyer.zip /var/www/html/
WORKDIR /var/www/html/
RUN unzip eflyer.zip
RUN cp -rvf eflyer/* .
RUN rm -rf eflyer eflyer.zip
CMD [ "/usr/sbin/httpd","-D","FOREGROUND" ]
EXPOSE 80 22