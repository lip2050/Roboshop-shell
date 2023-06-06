echo -e "\e[32m Install Maven\e[0m"
yum install maven -y &>>/tmp/roboshop.log

echo -e "\e[32m Add Application user \e[0m"
useradd roboshop &>>/tmp/roboshop.log

echo -e "\e[32m Create Application Directory \e[0m"
rm -rf /app &>>/tmp/roboshop.log
mkdir /app

echo -e "\e[32m Download Application Content\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "\e[32m Extract application Content\e[0m"
unzip /tmp/shipping.zip &>>/tmp/roboshop.log
cd /app &>>/tmp/roboshop.log

echo -e "\e[32m Download Maven Dependencies\e[0m"
mvn clean package    &>>/tmp/roboshop.log
mv target/shipping-1.0.jar shipping.jar  &>>/tmp/roboshop.log

echo -e "\e[32m Setup SystemD File\e[0m"
cp /home/centos/roboshop-shell/shipping.service /etc/systemd/system/shipping.service  &>>/tmp/roboshop.log

echo -e "\e[32m Install MySQL Client\e[0m"
yum install mysql -y &>>/tmp/roboshop.log

echo -e "\e[32m Load Schema\e[0m"
mysql -h mysql-dev.lipdevopspro.site -uroot -pRoboShop@1 < /app/schema/shipping.sql &>>/tmp/roboshop.log

echo -e "\e[32m Start Shipping Service\e[0m"
systemctl daemon-reload  &>>/tmp/roboshop.log
systemctl enable shipping  &>>/tmp/roboshop.log
systemctl restart shipping  &>>/tmp/roboshop.log