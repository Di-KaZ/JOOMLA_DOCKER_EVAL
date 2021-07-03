FROM debian

ARG JOOMLA_SRC_PATH

# packages and create a folder to store joomla cms
RUN apt update -y && apt install apache2 \
    php7.2  php-xml php-mysql wget unzip -y && \
    mkdir -p /var/${JOOMLA_SRC_PATH}

ENTRYPOINT ["bash", "/launch_joomla.sh"]

EXPOSE 80