## eap docker
This project builds a docker container for running JBoss EAP 6.3.0.GA. with roll-up patch 1


Before running the build:

1. Install [Docker](https://www.docker.io/gettingstarted/#1)
2. Download the JBoss EAP 6.3.0 install jar
3  Download roll-up patch 1
4. Put the install jar file into installer directory and the patch into the patches
	
Once you have completed steps 1..4 you can build an image using the following command:

		$ docker build -t eap631 . 



You can run the container with the following command:

		$ docker run -P -d -t eap631 

This will run the eap631 container and automatically start an EAP instance.


You can confirm that the container is running with the ps command:      	

	$ docker ps
	CONTAINER ID        IMAGE               COMMAND                CREATED             STATUS              PORTS                                                                                                                                                                                                                           NAMES
	65922270e9c2        eap631:latest       "/bin/sh -c /home/jb   12 seconds ago      Up 10 seconds  

	0.0.0.0:49188->22/tcp,   
	0.0.0.0:49189->5432/tcp,  
	0.0.0.0:49190->5445/tcp,   
	0.0.0.0:49191->5455/tcp,  
	0.0.0.0:49192->8080/tcp,   
	0.0.0.0:49193->9990/tcp,  
	0.0.0.0:49194->9999/tcp,   
	0.0.0.0:49195->3528/tcp,  
	0.0.0.0:49196->4447/tcp  
   	goofy_ritchie

You can access the console at:

 	http://localhost:PORT/console/App.html
  
Where PORT is the port mapped to 9990, in the example above 49193 is the port from the host mapped to 9990 in the container


To start a shell in the container you can run the following command:

		$ docker run -P -i -t eap631 /bin/bash

**Dissection of the DockerFile**


	# Use the fedora base image
	FROM fedora:latest

This is aimed at being a development environment hence starting from a fedora base image. For production use you may wish to use RHEL or centos . 

Note the number of ports open 

	EXPOSE 22 5455 9999 8080 5432 4447 5445 9990 3528 

The ports you need open depend on the services you need. For production you may want to restrict the ports that are opened. You can also set the port mappings at run time by modifyng the run command to set the port maps  for example to map the port 9990 to the host 9990 you would do this 

	$ docker run -P  9990:9990 -i -t eap631 /bin/bash
	
Refer to the Docker docmentation on [Linking containers together](http://docs.docker.com/userguide/dockerlinks/) as it has a great section on network port mappings


	ADD resources/auto.xml $INSTALLDIR/resources/auto.xml
	ADD resources/auto.xml.variables $INSTALLDIR/	resources/auto.xml.variables

auto.xml - when you run the  installer in text mode this is the anwser file. The one supplied in this repository is set to default. You can change the values  but need to run the  installer again to generate or take your chances editing the xml

Note if generating yourself make sure you have the appropriate read permissions set.

auto.xml.variables -  This is where you supply the password for the admin user. This needs modifying before you build your image








