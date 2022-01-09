REPO_DIR=$(pwd)
USR=$(whoami)

sudo apt update && sudo apt upgrade

cd

sudo snap install flutter --classic
sudo apt install -y nginx
sudo apt install -y build-essential

sudo chmod -R 755 $REPO_DIR

cd $REPO_DIR
sudo cp devops/nginx/insanichess.com /etc/nginx/sites-available/insanichess.com
sudo ln -s /etc/nginx/sites-available/insanichess.com /etc/nginx/sites-enabled/insanichess.com
sudo sed -i 's/# server_names_hash_bucket_size 64/server_names_hash_bucket_size 64/g' /etc/nginx/nginx.conf
sudo nginx -t
if [ $? -ne 0 ]; then
    echo "Bad NGINX conf."
    exit 1
fi
sudo systemctl restart nginx

sudo apt install certbot python3-certbot-nginx
sudo systemctl reload nginx
sudo ufw allow 'Nginx Full'
sudo ufw enable
sudo ufw status
sudo certbot --nginx --agree-tos --redirect -m "marcel@stelynx.com" --no-eff-email -d insanichess.com -d *.insanichess.com
sudo systemctl status certbot.timer
sudo certbot renew --dry-run
sudo nginx -t
