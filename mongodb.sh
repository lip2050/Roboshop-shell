echo -e "${color}Copy Monogodb Repo file ${nocolor}"
cp mogodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

echo -e "${color}Installing ${component} Server${nocolor}"
yum install ${component}-org -y &>>${log_file}

echo -e "${color}Update ${component} listen Address ${nocolor}"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>${log_file}

echo -e "${color}Start ${component} Service ${nocolor}"
systemctl enable mongod &>>${log_file}
systemctl start mongod &>>${log_file}