# poc_dec_2022
poc for public sapient

SCM(Github) ---> Jenkins ----> terraform ----> GCP infratrucute
Ansible role of changing the port is done thru apache2.sh (https://github.com/amaresh435/poc_dec_2022/blob/develop/apache2.sh),
this scripit file in turn is called in the vm instance creation and installing Apache2 web server.

1. SCM github
   https://github.com/amaresh435/poc_dec_2022
	
   https://github.com/amaresh435/poc_dec_2022.git  ---Develop branch is configured into Jenkins server VM instance

2. Details steps of terraform written in the below main.tf and comment added to each steps
https://github.com/amaresh435/poc_dec_2022/blob/develop/main.tf 

3. Jenkins machine 
  http://34.66.156.115:8080  user name "admin" password "admin"

4. pipeline
  http://34.66.156.115:8080/job/Terrafor-Ansible/
  
5. Service account created with compute instance restart
amaresh-webserver-restart@internal-interview-candidates.iam.gserviceaccount.com
