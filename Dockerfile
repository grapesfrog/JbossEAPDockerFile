#######################################################################
# Creates a base Fedora image with JBoss EAP-6.3.0.GA r1              #
#######################################################################

# Use the fedora base image
FROM fedora:latest 

MAINTAINER cmondesir <cmondesi@redhat.com> gmollison <grapesfrog@gmail.com>

# Update the system
RUN yum -y update;yum clean all

# enabling sudo group for jboss
RUN echo '%jboss ALL=(ALL) ALL' >> /etc/sudoers

# Create jboss user
RUN useradd -m -d /home/jboss -p jboss jboss


##########################################################
# Install Java JDK
##########################################################
RUN yum -y install java-1.7.0-openjdk
ENV JAVA_HOME /usr/lib/jvm/jre


############################################
# Install EAP 6.3.0.GA and r1
############################################
USER jboss
ENV INSTALLDIR /home/jboss/EAP-6.3.0
ENV HOME /home/jboss
RUN mkdir $INSTALLDIR && \
   mkdir $INSTALLDIR/installer && \
   mkdir $INSTALLDIR/patches && \
   mkdir $INSTALLDIR/resources

ADD installer/jboss-eap-6.3.0-installer.jar $INSTALLDIR/installer/jboss-eap-6.3.0-installer.jar 
ADD patches/jboss-eap-6.3.1-patch.zip $INSTALLDIR/patches/jboss-eap-6.3.1-patch.zip
ADD resources/auto.xml $INSTALLDIR/resources/auto.xml
ADD resources/auto.xml.variables $INSTALLDIR/resources/auto.xml.variables
RUN java -jar $INSTALLDIR/installer/jboss-eap-6.3.0-installer.jar $INSTALLDIR/resources/auto.xml -variablefile $INSTALLDIR/resources/auto.xml.variables
RUN $INSTALLDIR/jboss-eap-6.3/bin/jboss-cli.sh "patch apply $INSTALLDIR/patches/jboss-eap-6.3.1-patch.zip"


############################################
# Create start script to run EAP instance
############################################
USER root
RUN echo "#!/bin/sh" >> $HOME/start.sh
RUN echo "echo JBoss EAP Start script" >> $HOME/start.sh
RUN echo "runuser -l jboss -c '$HOME/EAP-6.3.0/jboss-eap-6.3/bin/standalone.sh -c standalone-full.xml -b 0.0.0.0 -bmanagement 0.0.0.0'" >> $HOME/start.sh
RUN chmod +x $HOME/start.sh


############################################
# Remove install artifacts
############################################
RUN rm -rf $INSTALLDIR/installer
RUN rm -rf $INSTALLDIR/patches
RUN rm -rf $INSTALLDIR/resources

EXPOSE 22 5455 9999 8080 5432 4447 5445 9990 3528    

CMD /home/jboss/start.sh

# Finished
