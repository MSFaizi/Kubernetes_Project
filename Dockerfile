FROM centos:latest
LABEL MAINTAINER codingmywork@gmail.com 
RUN yum install -y httpd \
zip\
unzip
ADD https://www.free-css.com/assets/files/free-css-templates/download/page287/eflyer.zip /var/www/html/
WORKDIR /var/www/html/
RUN unzip eflyer.zip
RUN cp -rvf eflyer/* .
RUN rm -rf eflyer eflyer.zip
CMD [ "/usr/sbin/httpd","-D","FOREGROUND" ]
EXPOSE 80 22