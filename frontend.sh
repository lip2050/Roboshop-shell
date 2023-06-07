source common.sh
component=frontend

echo -e "${color}Installing Nginx Server ${nocolor}"
yum install nginx -y &>>${log_file}

echo -e "${color}Removing  Old App Content ${nocolor}"
rm -rf /usr/share/nginx/html/* &>>${log_file}

echo -e "${color}Downloading ${component} Content ${nocolor}"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}

echo -e "${color}Extract ${component} Content ${nocolor}"
cd /usr/share/nginx/html &>>${log_file}
unzip /tmp/${component}.zip &>>${log_file}

echo -e "${color}Update ${component} Configuration ${nocolor}"
cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf

echo -e "${color}Starting Nginx ${nocolor}"
systemctl enable nginx
systemctl restart nginx