# Run with option 
# opf_cdb will install database and configure it
# opf_init (default) will use supplyed DB and Start
# - TODO: Add a :db tag to discover databases.
# Create token sudo openproject run rake secret | tail -1

FROM dockerimages/ubuntu-upstart:14.04

ENV SECRET my_token
ENV DB_URL mysql2://user:pass@host:port/dbname
ENV SCALE "web=1 worker=1"
ENV EMAIL_DELIVERY_METHOD "smtp" 
ENV SMTP_ADDRESS "smtp.example.net" 
ENV SMTP_PORT "587" 
ENV SMTP_DOMAIN "example.net" 
ENV SMTP_AUTHENTICAITON "plain" 
ENV SMTP_USER_NAME "user" 
ENV SMTP_PASSWORD "password" 
ENV SMTP_ENABLE_STARTTLS_AUTO "true" 
RUN screen -dmSL init /sbin/init \
 && apt-get update && apt-get install -y screen wget sudo apt-transport-https ca-certificates \
 && wget -qO - https://deb.packager.io/key | sudo apt-key add - \
 && apt-key adv --keyserver keyserver.ubuntu.com --recv-keys \
 && echo "deb https://deb.packager.io/gh/tessi/openproject trusty feature/pkgr" | sudo tee /etc/apt/sources.list.d/openproject.list \
 && apt-get update \
 && apt-get install -y openproject*=3.0.1-1400061402.f476e5c.trusty
COPY ./inst_db /usr/bin/opf_cdb
COPY ./opf_init /usr/bin/opf_init
COPY ./opf_init_mail /usr/bin/opf_init_mail
RUN chmod +x /usr/bin/opf_init_mail /usr/bin/opf_init /usr/bin/opf_cdb
CMD ["opf_init_mail"]
