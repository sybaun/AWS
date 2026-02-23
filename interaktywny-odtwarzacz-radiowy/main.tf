resource "aws_security_group" "react_app_sg" {
 name = "react_app_sg"
 description = "Security group for React app"
 vpc_id = "vpc-08f4b33183436d641" 
 ingress {
 from_port = 22
 to_port = 22
 protocol = "tcp"
 cidr_blocks = ["95.48.21.33/32"]
 }
 ingress {
 from_port = 80
 to_port = 80
 protocol = "tcp"
 cidr_blocks = ["0.0.0.0/0"]
 }
 egress {
 from_port = 0
 to_port = 0
 protocol = "-1"
 cidr_blocks = ["0.0.0.0/0"]
 }
}
resource "aws_instance" "react_app" {
 ami = "ami-01f79b1e4a5c64257" # Ubuntu 22.04 LTS w Twoim regionie
 instance_type = "t3.micro"
 subnet_id = "subnet-0a8d2653e49dbf408" 
 vpc_security_group_ids = ["sg-0a3c7e3655902b9e9"]
 associate_public_ip_address = true
 key_name = "serwer_key"
 user_data = <<-EOF
 #!/bin/bash
 apt-get update -y
 apt-get install -y git nginx curl
 curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
 apt-get install -y nodejs
 git clone https://github.com/sybaun/AWS.git
/home/ubuntu/AWS
 cd /home/ubuntu/AWS/interaktywny-odtwarzacz-radiowy
 npm install
 npm run build
 rm -rf /var/www/html/*
 cp -r build/* /var/www/html/
 cat > /etc/nginx/sites-available/default <<EOL
 server {
 listen 80 default_server;
 server_name _;
 root /var/www/html;
 index index.html;
 location / {
 try_files \$uri /index.html;
 }
 }
 EOL
 systemctl restart nginx
 EOF
}