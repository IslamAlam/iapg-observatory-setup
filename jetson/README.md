

ln -sf "$(pwd)/.bin" ~/.bin
chmod -R +x ~/.bin

setup ubunutu-desktop
sudo mkdir -p /opt/miniforge
sudo chown -R $UID:$GID /opt/miniforge
setup miniforge

sudo ~/.bin/setup indi

sudo touch /etc/profile.d/observatory.sh

setup supervisor

sudo cp -r ~/repos/iapg-setup/jetson/.bin/resources/supervisor/conf.d /opt/miniforge/etc/supervisord/

sudo cp ~/repos/iapg-setup/jetson/.bin/resources/systemd/supervisor.service /lib/systemd/system/supervisor.service


sudo systemctl daemon-reload 
sudo systemctl enable supervisor.service
sudo systemctl start supervisor.service 
sudo systemctl reload-or-restart supervisor.service
sudo systemctl status supervisor.service 

/usr/bin/supervisorctl status indiweb

sudo cp /opt/miniforge/etc/systemd/system/supervisord.service /etc/systemd/system/supervisord.service

sudo systemctl daemon-reload 
sudo systemctl enable supervisord.service
sudo systemctl start supervisord.service
sudo systemctl reload-or-restart supervisord.service
sudo systemctl status supervisord.service

/opt/miniforge/bin/supervisorctl status indiweb



sudo cp ~/repos/iapg-setup/jetson/.bin/resources/systemd/indiwebmanager.service /etc/systemd/system/indiwebmanager.service

sudo systemctl daemon-reload 
sudo systemctl enable indiwebmanager.service
sudo systemctl start indiwebmanager.service
sudo systemctl reload-or-restart indiwebmanager.service
sudo systemctl status indiwebmanager.service