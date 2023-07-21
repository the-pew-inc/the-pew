[Unit]
Description=ThePew Puma Server
After=network.target

[Service]
Type=simple
User=deploy
EnvironmentFile=/home/deploy/thepew/.rbenv-vars
Environment=RAILS_ENV=production
WorkingDirectory=/home/deploy/thepew/current/
ExecStart=/home/deploy/.rbenv/bin/rbenv exec bundle exec puma -C /home/deploy/thepew/current/config/puma.rb --ssl-key=/etc/letsencrypt/live/demo.thepew.io/privkey.pem --ssl-cert=/etc/letsencrypt/live/demo.thepew.io/fullchain.pem
ExecStop=/home/deploy/.rbenv/bin/rbenv exec bundle exec pumactl -F /home/deploy/thepew/current/config/puma.rb stop
ExecReload=/home/deploy/.rbenv/bin/rbenv exec bundle exec pumactl -F /home/deploy/thepew/current/config/puma.rb phased-restart
TimeoutSec=15
Restart=always
KillMode=process

[Install]
WantedBy=multi-user.target

// To adapt to the file name
sudo systemctl daemon-reload
sudo systemctl enable puma.service
sudo systemctl start puma.service

sudo systemctl start puma-thepew51
sudo systemctl stop puma-thepew51
sudo systemctl status puma-thepew51
ps -eo pid,comm,euser,supgrp | grep nginx

When using SSL add the following to ExecStart to enable Puma over HTTPS
--ssl-key=/etc/letsencrypt/live/demo.thepew.io/privkey.pem --ssl-cert=/etc/letsencrypt/live/demo.thepew.io/fullchain.pem

RAILS_ENV=production bundle exec puma --daemon --bind unix://home/deploy/thepew/shared/tmp/sockets/puma.sock --state home/deploy/thepew/shared/tmp/sockets/puma.state --control unix://home/deploy/thepew/shared/tmp/sockets/pumactl.sock
