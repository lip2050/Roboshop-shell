source common.sh
component=Dispatch

echo -e "${color} Installing Golang${nocolor}"
yum install golang -y &>>${log_file}

echo -e "${color} Add Application Use${nocolor}"
useradd roboshop &>>${log_file}

echo -e "${color} Create Application Directory${nocolor}"
rm -rf app_path &>>${log_file}
mkdir app_path

echo -e "${color} Download Application Content${nocolor}"
curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>${log_file}

echo -e "${color} Extract Application Content${nocolor}"
cd app_path
unzip /tmp/${component}.zip &>>${log_file}

echo -e "${color} Download Dependencies${nocolor}"
cd app_path &>>${log_file}
go mod init ${component} &>>${log_file}

echo -e "${color} Get Temp File ${nocolor}"
go get &>>${log_file}

echo -e "${color} Build Software${nocolor}"
go build &>>${log_file}

echo -e "${color} Setup SystemD File${nocolor}"
cp /home/centos/roboshop-shell/${component}.service /etc/systemd/system/${component}.service &>>${log_file}

echo -e "${color} Start Payment Service${nocolor}"
systemctl daemon-reload &>>${log_file}
systemctl enable ${component} &>>${log_file}
systemctl start ${component} &>>${log_file}