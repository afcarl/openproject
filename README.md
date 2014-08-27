# OpenProject Docker ## WARNING: NONE WORKING!

The Image Installs MYSQL Database if it don't already exists or throws Error and exits container if Database isn't connect able.

## Use

Use Create OWN DB

# Start Database container with var OPENPROJECT_DB

    $ OPENPROJECT_DB=$(docker run -d tutum/mysql)
    
# This Will Install Database First Time

    $ docker run --rm --link=${OPENPROJECT_DB} dockerimages/openproject:stable opf_cdb

# Start Server

    $ OPENPROJECT_WORKER=$(docker run -d --link=${OPENPROJECT_DB} dockerimages/openproject:stable)

Create DB in External Database Server

# Prepare DB

    $ docker run --rm \
        --env=["DB_URL" "mysql2://user:pass@host:port/dbname"] \
        --env=["SECRET" "my_token"] \ 
    dockerimages/openproject:stable \
    opf_cdb
    
# Start Server

    $ OPENPROJECT_WORKER=$(docker run -d \
        --env=["DB_URL" "mysql2://user:pass@host:port/dbname"] \
        --env=["SECRET" "my_token"] \ 
    dockerimages/openproject:stable)


## Reconfig Change Config

Simply run the Following command and costimise it to your needs you can replace the -t with your own image name
And Simply fill in your Credentials and Settings you don't need to reconfigure all you can use one or all settings

    $ docker build -t dockerimages/openproject:configed - <<DOCKERFILE
     FROM dockerimages/openprojects
     ENV DB_URL "mysql2://user:pass@host:port/dbname"
     ENV SECRET "my_token"
     ENV SCALE "web=1 worker=1"
     ENV EMAIL_DELIVERY_METHOD="smtp" \
     ENV SMTP_ADDRESS="smtp.example.net" \
     ENV SMTP_PORT="587" \
     ENV SMTP_DOMAIN="example.net" \
     ENV SMTP_AUTHENTICAITON="plain" \
     ENV SMTP_USER_NAME="user" \
     ENV SMTP_PASSWORD="password" \
     ENV SMTP_ENABLE_STARTTLS_AUTO="true" \
     CMD ["opf_init_mail"
     DOCKERFILE
