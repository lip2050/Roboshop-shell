color="\e[35m"
nocolor="\e[0m"
log_file="/tmp/roboshop.log"
app_path="/app"

app_presetup(){
  echo -e "${color}Add Application User ${nocolor}"
  useradd roboshop &>>${log_file}

  echo -e "${color}Create Application Directory${nocolor}"
  rm -rf app_path &>>${log_file}
  mkdir app_path

  echo -e "${color}Download Application Content${nocolor}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}

  echo -e "${color}Extract Application Content${nocolor}"
  cd app_path
  unzip /tmp/${component}.zip &>>${log_file}
}

systemD_postsetup(){
    echo -e "${color}Setup SystemD Service${nocolor}"
    cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}

    echo -e "${color}Start ${component} Service ${nocolor}"
    systemctl daemon-reload
    enable_system
}

enable_system(){
      systemctl enable ${component}
      systemctl restart ${component}
}

nodejs(){
  echo -e "${color}Configuring Nodejs Repos ${nocolor}"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

  echo -e "${color}Install Nodejs${nocolor}"
  yum install nodejs -y &>>${log_file}

  app_presetup

  echo -e "${color} Install Nodejs Dependencies${nocolor}"
  npm install &>>${log_file}

  systemD_postsetup
}

golang(){
  echo -e "${color} Installing Golang${nocolor}"
  yum install golang -y &>>${log_file}

  app_presetup

  echo -e "${color} Download Dependencies${nocolor}"
  cd app_path &>>${log_file}
  go mod init ${component} &>>${log_file}

  echo -e "${color} Get Temp File ${nocolor}"
  go get &>>${log_file}

  echo -e "${color} Build Software${nocolor}"
  go build &>>${log_file}

  systemD_postsetup
}

nginx(){
  echo -e "${color}Installing ${component} Server ${nocolor}"
  yum install ${component} -y &>>${log_file}

  echo -e "${color}Removing  Old App Content ${nocolor}"
  rm -rf /usr/share/${component}/html/* &>>${log_file}

  echo -e "${color}Downloading frontend Content ${nocolor}"
  curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}

  echo -e "${color}Extract frontend Content ${nocolor}"
  cd /usr/share/${component}/html &>>${log_file}
  unzip /tmp/frontend.zip &>>${log_file}

  echo -e "${color}Update frontend Configuration ${nocolor}"
  cp /home/centos/roboshop-shell/roboshop.conf /etc/${component}/default.d/roboshop.conf

  enable_system
}

python(){
  echo -e "${color} Install Python${nocolor}"
  yum install python36 gcc python3-devel -y &>>${log_file}

  app_presetup

  echo -e "${color} Install Application Dependencies${nocolor}"
  cd ${app_path}
  pip3.6 install -r requirements.txt &>>${log_file}

  systemD_postsetup
}

erlang(){
  echo -e "${color} Configure Erlang repos${nocolor}"
  curl -s https://packagecloud.io/install/repositories/${component}/erlang/script.rpm.sh | bash &>>${log_file}

  echo -e "${color} Configure ${component} Repos${nocolor}"
  curl -s https://packagecloud.io/install/repositories/${component}/${component}-server/script.rpm.sh | bash &>>${log_file}

  echo -e "${color} Install ${component} Server${nocolor}"
  yum install ${component}-server -y &>>${log_file}

  echo -e "${color} Start ${component} Service ${nocolor}"
  systemctl enable ${component}-server &>>${log_file}
  systemctl restart ${component}-server &>>${log_file}

  echo -e "${color} Add ${component} Application User${nocolor}"
  ${component}ctl add_user roboshop roboshop123 &>>${log_file}
  ${component}ctl set_permissions -p / roboshop ".*" ".*" ".*" &>>${log_file}
}

maven(){
  echo -e "${color} Install Maven${nocolor}"
  yum install maven -y &>>${log_file}

  app_presetup

  echo -e "${color} Download Maven Dependencies${nocolor}"
  mvn clean package    &>>${log_file}
  mv target/${component}-1.0.jar ${component}.jar  &>>${log_file}

  systemD_postsetup

  echo -e "${color} Install MySQL Client${nocolor}"
  yum install mysql -y &>>${log_file}

  echo -e "${color} Load Schema${nocolor}"
  mysql -h mysql-dev.lipdevopspro.site -uroot -pRoboShop@1 < ${app_path}/schema/${component}.sql &>>${log_file}
}

mongo_schema_setup(){
  echo -e "${color}Copy MongoDB Repo file ${nocolor}"
  cp /home/centos/roboshop-shell/mongodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

  echo -e "${color}Install mongodb client${nocolor}"
  yum install mongodb-org-shell -y &>>${log_file}

  echo -e "${color}Load Schema ${nocolor}"
  mongo --host mongodb-dev.lipdevopspro.site <${app_path}/schema/${component}.js &>>${log_file}
}

mongod_setup(){
  echo -e "${color}Copy ${component}b Repo file ${nocolor}"
  cp mogodb.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

  echo -e "${color}Installing ${component}b Server${nocolor}"
  yum install ${component}b-org -y &>>${log_file}

  echo -e "${color}Update ${component}b listen Address ${nocolor}"
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/${component}.conf &>>${log_file}

  enable_system
}

mysql_setup(){
  echo -e "${color}Disable ${component} Default Version${nocolor}"
  yum module disable ${component} -y &>>${log_file}

  echo -e "${color}Copy ${component} repo file${nocolor}"
  cp ${component}.repo /etc/yum.repos.d/${component}.repo &>>${log_file}

  echo -e "${color}Install ${component} Community Server${nocolor}"
  yum install ${component}-community-server -y &>>${log_file}

  enable_system

  echo -e "${color}Setup ${component} Password${nocolor}"
  ${component}_secure_installation --set-root-pass RoboShop@1 &>>${log_file}
}

redis_setup(){
  echo -e "${color}Install ${component} Repos${nocolor}"
  yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>${log_file}

  echo -e "${color}Enable ${component} 6 Version ${nocolor}"
  yum module enable ${component}:remi-6.2 -y &>>${log_file}

  echo -e "${color}Install ${component}${nocolor}"
  yum install ${component} -y &>>${log_file}

  echo -e "${color}Update ${component} Listen address${nocolor}"
  sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/${component}.conf /etc/${component}/${component}.conf &>>${log_file}

  enable_system
}