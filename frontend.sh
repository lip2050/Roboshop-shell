echo -e "\e[32mInstalling Nginx Server \e[0m"
yum install nginx -y &>>/tmp/roboshop.log

echo -e "\e[32mRemoving  Old App Content \e[0m"
rm -rf /usr/share/nginx/html/* &>>/tmp/roboshop.log

echo -e "\e[32mDownloading Frontend Content \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[32mExtract Frontend Content \e[0m"
cd /usr/share/nginx/html &>>/tmp/roboshop.log
unzip /tmp/frontend.zip &>>/tmp/roboshop.log

echo -e "\e[32mCopy Nginx Server \e[0m"
cp roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[32mStarting Nginx \e[0m"
systemctl enable nginx
systemctl restart nginx