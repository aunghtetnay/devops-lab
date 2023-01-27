#!/bin/bash
ssh -i /home/ec2-user/key.pem ec2-user@10.0.3.11  "sudo yum update -y && sudo yum install docker -y &&   sudo service docker start &&
sudo usermod -a -G docker ec2-user && sudo chmod 666 /var/run/docker.sock &&   docker pull ahnay2019/nodejs &&    docker run -d -p 80:8080  --name assignment  ahnay2019/nodejs"
 ssh -i /home/ec2-user/key.pem ec2-user@10.0.3.11 "docke ps  && docker ps -a "
 echo "Your container is Now up and Running"
 
