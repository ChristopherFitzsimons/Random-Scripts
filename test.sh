line="@reboot /path/to/command"
(crontab -u root -l; echo "$line" ) | crontab -u root -

