echo -e "\e[32mConfiguring Nodejs Repos \e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>/tmp/roboshop.log

echo -e "\e[32mInstll Nodejs\e[0m"
yum install nodejs -y &>>/tmp/roboshop.log

echo -e "\e[32mAdd Application User \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[32mCreate Application Directory\e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[32mDownload Application Content\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[32mExtract Application Content\e[0m"
unzip /tmp/catalogue.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[32m Install Nodejs Dependencies\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[32mSetup SystemD Service\e[0m"
cp catalogue.service /etc/systemd/system/catalogue.service &>>/tmp/roboshop.log

echo -e "\e[32mStart Catalogue Service \e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[32mCopy MongoDB Repo file \e[0m"
cp mongodb.repo /etc/yum.repos.d/mongo.repo &>>/tmp/roboshop.log

echo -e "\e[32mInstall mongodb client\e[0m"
yum install mongodb-org-shell -y &>>/tmp/roboshop.log

echo -e "\e[32mLoad Schema \e[0m"
mongo --host mongodb-dev.lipdevopspro.site </app/schema/catalogue.js &>>/tmp/roboshop.log