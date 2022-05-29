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

cd /tmp/
log_type="httpd-logs"
type="tar"
filesize=$(ls -lh "${my_name}-httpd-logs-${timestamp}.tar" | awk '{print  $5}')
cd /var/www/html/
if [ -e /var/www/html/inventory.html ]
then

 echo "${log_type}              ${timestamp}            ${type}         ${filesize}" >> inventory.html

else
        touch inventory.html

        echo  "Log Type         Date Created            Type            Size " >> inventory.html
        echo "${log_type}              ${timestamp}            ${type}         ${filesize}" >> inventory.html

fi

cd /etc/cron.d/
if [ -e automation ]
then
echo " Job has been scheduled "
else
touch automation
echo " @daily root /root/Automation_Project/automation.sh " >> /etc/cron.d/automation
fi
