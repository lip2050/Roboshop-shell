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
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[32mExtract Application Content\e[0m"
unzip /tmp/cart.zip &>>/tmp/roboshop.log
cd /app

echo -e "\e[32m Install Nodejs Dependencies\e[0m"
npm install &>>/tmp/roboshop.log

echo -e "\e[32mSetup SystemD Service\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service &>>/tmp/roboshop.log

echo -e "\e[32mStart cart Service \e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart
