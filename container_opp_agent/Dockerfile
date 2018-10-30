FROM centos:centos7

ARG OKTA_ORG_TYPE
ARG OKTA_ORG
ENV OKTA_ORG=$OKTA_ORG
ENV OKTA_ORG_TYPE=$OKTA_ORG_TYPE

RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN yum install -y initscripts; yum clean all

ADD . /src
RUN echo "https://${OKTA_ORG}-admin.${OKTA_ORG_TYPE}.com/static/agents/ProvisioningAgent/OktaProvisioningAgent-01.02.03.x86_64.rpm"
ADD "https://${OKTA_ORG}-admin.${OKTA_ORG_TYPE}.com/static/agents/ProvisioningAgent/OktaProvisioningAgent-01.02.03.x86_64.rpm" /src
RUN cd /src; yum -y localinstall OktaProvisioningAgent-01.02.03.x86_64.rpm
RUN cp /src/configure_agent.sh /opt/OktaProvisioningAgent/configure_agent.sh
RUN /opt/OktaProvisioningAgent/configure_agent.sh
RUN chmod 777 /src/OktaProvisioningAgentForeground; cp /src/OktaProvisioningAgentForeground /opt/OktaProvisioningAgent

CMD ["/opt/OktaProvisioningAgent/OktaProvisioningAgentForeground"]
