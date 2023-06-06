echo -e "\e[32m Installing Golang\e[0m"
yum install golang -y &>>/tmp/roboshop.log

echo -e "\e[32m Add Application Use\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[32m Create Application Directory\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[32m Download Application Content\e[0m"
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>/tmp/roboshop.log

echo -e "\e[32m Extract Application Content\e[0m"
cd /app
unzip /tmp/dispatch.zip &>>/tmp/roboshop.log

echo -e "\e[32m Download Dependencies\e[0m"
cd /app &>>/tmp/roboshop.log
go mod init dispatch &>>/tmp/roboshop.log

echo -e "\e[32m Get Temp File \e[0m"
go get &>>/tmp/roboshop.log

echo -e "\e[32m Build Software\e[0m"
go build &>>/tmp/roboshop.log

echo -e "\e[32m Setup SystemD File\e[0m"
cp /home/centos/roboshop-shell/Dispatch.service /etc/systemd/system/dispatch.service &>>/tmp/roboshop.log

echo -e "\e[32m Start Payment Service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable dispatch &>>/tmp/roboshop.log
systemctl start dispatch &>>/tmp/roboshop.log