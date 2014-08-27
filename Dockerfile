# Runn with option 
# - setup will install database and configure it
# - use (default) will use linked in DB and Start
# - TODO: Add a :db tag to discover databases.
# Create token sudo openproject run rake secret | tail -1

FROM dockerimages/ubuntu-core:14.04

ENV SECRET_TOKEN my_token
ENV DATABASE_URL mysql2://user:pass@host:port/dbname
RUN wget -qO - https://deb.packager.io/key | sudo apt-key add - \
 && echo "deb https://deb.packager.io/gh/tessi/openproject trusty feature/pkgr" | sudo tee /etc/apt/sources.list.d/openproject.list
 && apt-get update
 && apt-get install sudo openproject*=3.0.1-1400061402.f476e5c.trusty \
 && openproject config:set EMAIL_DELIVERY_METHOD="smtp" \
 && openproject config:set SMTP_ADDRESS="smtp.example.net" \
 && openproject config:set SMTP_PORT="587" \
 && openproject config:set SMTP_DOMAIN="example.net" \
 && openproject config:set SMTP_AUTHENTICAITON="plain" \
 && openproject config:set SMTP_USER_NAME="user" \
 && openproject config:set SMTP_PASSWORD="password" \
 && openproject config:set SMTP_ENABLE_STARTTLS_AUTO="true" \
 && openproject scale web=1 worker=1
COPY ./inst_db /usr/bin/opf_cdb
COPY ./opf_init /opf_init /usr/bin/opf_cdb
RUN chmod +x /opf_init 
CMD ["/opf_init"]
