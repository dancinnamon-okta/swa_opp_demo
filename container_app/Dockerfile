FROM centos:centos7

ARG APP_CODEBASE
ARG API_KEY
ARG OKTA_APP_NAME
ENV APP_CODEBASE=$APP_CODEBASE
ENV API_KEY=$API_KEY
ENV OKTA_APP_NAME=$OKTA_APP_NAME

ENV DEVELOP=0

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum -y install centos-release-scl; yum clean all
RUN yum install -y initscripts; yum clean all
RUN yum install -y  rh-python36; yum clean all
RUN yum install -y git; yum clean all
RUN source /opt/rh/rh-python36/enable && pip install django
RUN source /opt/rh/rh-python36/enable && pip install django-sslserver

ADD . /src

RUN chmod 777 /src/RunWebApp

CMD ["/src/RunWebApp"]
