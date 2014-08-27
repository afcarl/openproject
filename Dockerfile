# Runn with option 
# - setup will install database and configure it
# - use (default) will use linked in DB and Start
# - TODO: Add a :db tag to discover databases.
FROM dockerimages/ubuntu-core:14.04

RUN wget -qO - https://deb.packager.io/key | sudo apt-key add - \
 && echo "deb https://deb.packager.io/gh/tessi/openproject trusty feature/pkgr" | sudo tee /etc/apt/sources.list.d/openproject.list
 && apt-get update
 && apt-get install sudo openproject*=3.0.1-1400061402.f476e5c.trusty \
 && openproject config:set DATABASE_URL=mysql2://user:pass@host:port/dbname \
 && openproject config:set EMAIL_DELIVERY_METHOD="smtp" \
 && openproject config:set SMTP_ADDRESS="smtp.example.net" \
 && openproject config:set SMTP_PORT="587" \
 && openproject config:set SMTP_DOMAIN="example.net" \
 && openproject config:set SMTP_AUTHENTICAITON="plain" \
 && openproject config:set SMTP_USER_NAME="user" \
 && openproject config:set SMTP_PASSWORD="password" \
 && openproject config:set SMTP_ENABLE_STARTTLS_AUTO="true" \
 && openproject scale web=1 worker=1 
CMD ["opf_init"]
