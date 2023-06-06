echo -e "\e[32m Install Python\e[0m"
yum install python36 gcc python3-devel -y &>>/tmp/roboshop.log

echo -e "\e[32m Add Application User\e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[32m Create Application Directory\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[32m Download Application Content\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[32m Extract Application Content\e[0m"
unzip /tmp/payment.zip &>>/tmp/roboshop.log

echo -e "\e[32m Install Application Dependencies\e[0m"
cd /app
pip3.6 install -r requirements.txt &>>/tmp/roboshop.log

echo -e "\e[32mSetup SystemD File\e[0m"
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service

echo -e "\e[32m Start Payment Service\e[0m"
systemctl daemon-reload &>>/tmp/roboshop.log
systemctl enable payment &>>/tmp/roboshop.log
systemctl restart payment &>>/tmp/roboshop.log