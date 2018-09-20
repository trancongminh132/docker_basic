FROM ubuntu:16.04

CMD echo "Hello Ubuntu"

# Update repositoty
RUN apt-get update

# Install necessary tools
RUN apt-get install -y nano wget dialog net-tools vim git

# Download and install nginx
RUN apt-get install -y nginx php7.0-fpm supervisor && \ 
    rm -rf /var/lib/apt/lists/*

# Define ENV variable
ENV nginx_vhost /etc/nginx/sites-available/default
ENV php_conf /etc/php/7.0/fpm/php.ini
ENV nginx_conf /etc/nginx/nginx.conf
ENV supervisor_conf /etv/supervisor/supervisord.conf

# Enable php-fpm on nginx virtualhost configuration
COPY default ${nginx_vhost}
RUN sed -i -e 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' ${php_conf} && \ 
    echo "\ndaemon off;" >> ${nginx_conf}

# Copy supervisor configuration
COPY supervisord.conf ${supervisor_conf}

RUN mkdir -p /run/php && \ 
    chown -R www-data:www-data /var/www/html && \
    chown -R www-data:www-data /run/php

# Volume configuration
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/var/www/html"]

# Configure Services and Port
COPY start.sh /start.sh
RUN chmod +x start.sh
CMD ["./start.sh"]

EXPOSE 80 443

