# OpenProject Docker

The Image Installs MYSQL Database if it don't already exists or throws Error and exits container if Database isn't connect able.

## Use

Use with Own DB

    OPENPROJECT_DB=$(docker run -d tutum/mysql)
    OPENPROJECT_WORKER=$(docker run -d --link=${OPENPROJECT_DB} dockerimages/openproject:stable)

use with External DB

    OPENPROJECT_WORKER=$(docker run -d \
    --env=["DB_URL" "mysql2://user:pass@host:port/dbname"] \
    --env=["SECRET" "my_token"] \ 
    dockerimages/openproject:stable)


## Reconfig Change Config

Simply run the Following command and costimise it to your needs you can replace the -t with your own image name
And Simply fill in your Credentials and Settings you don't need to reconfigure all you can use one or all settings

    docker build -t dockerimages/openproject:configed - <<DOCKERFILE
     FROM dockerimages/openprojects
     ENV DB_URL "mysql2://user:pass@host:port/dbname"
     ENV SECRET "my_token"
     RUN openproject config:set EMAIL_DELIVERY_METHOD="smtp" \
     && openproject config:set SMTP_ADDRESS="smtp.example.net" \
     && openproject config:set SMTP_PORT="587" \
     && openproject config:set SMTP_DOMAIN="example.net" \
     && openproject config:set SMTP_AUTHENTICAITON="plain" \
     && openproject config:set SMTP_USER_NAME="user" \
     && openproject config:set SMTP_PASSWORD="password" \
     && openproject config:set SMTP_ENABLE_STARTTLS_AUTO="true" \
     && openproject scale web=1 worker=1
     DOCKERFILE
