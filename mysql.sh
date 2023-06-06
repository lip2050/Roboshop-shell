echo -e "\e[32mDisable MySQl Default Version\e[0m"
yum module disable mysql -y &>>/tmp/roboshop.log

echo -e "\e[32mCopy MySQL repo file\e[0m"
cp mysql.repo /etc/yum.repos.d/mysql.repo &>>/tmp/roboshop.log

echo -e "\e[32mInstall MySQL Community Server\e[0m"
yum install mysql-community-server -y &>>/tmp/roboshop.log

echo -e "\e[32mStart MySQL Service\e[0m"
systemctl enable mysqld
systemctl restart mysqld

echo -e "\e[32mSetup MySQL Password\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1 &>>/tmp/roboshop.log