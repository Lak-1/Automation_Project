timestamp=$(date '+%d%m%Y-%H%M%S')
my_bucket=upgrad-lakshmi
my_name=lakshmi
apt update -y
dpkg -l | grep" apache2"
apt-get -qq -y install apache2
service apache2 status
systemctl enable apache2
tar -czvf /tmp/${my_name}-httpd-logs-${timestamp}.tar /var/log/apache2/*.log
aws s3 cp /tmp/${my_name}-httpd-logs-${timestamp}.tar s3://${my_bucket}/${my_name}-httpd-logs-${timestamp}.tar
