# Imagen base mínima con soporte para Debian y Apache
FROM bitnami/minideb

# Establecer el frontend no interactivo
ENV DEBIAN_FRONTEND="noninteractive"

# Actualización de paquetes y herramientas necesarias
RUN apt-get update && apt-get install -y \
    apache2 \
    perl \
    libcgi-pm-perl \
    vim \
    bash \
    locales \
    tree \
    systemctl

# Configuración de localización a español (Perú)
RUN echo -e 'LANG=es_PE.UTF-8\nLC_ALL=es_PE.UTF-8' > /etc/default/locale && \
    sed -i 's/^# *\(es_PE.UTF-8\)/\1/' /etc/locale.gen && \
    /sbin/locale-gen es_PE.UTF-8

# Habilitar módulos necesarios para CGI en Apache
RUN a2enmod cgid

# Crear estructura de carpetas y establecer permisos
RUN mkdir -p /var/www/html && \
    mkdir -p /usr/lib/cgi-bin && \
    chown www-data:www-data /var/www/html && \
    chown www-data:www-data /usr/lib/cgi-bin && \
    chmod 750 /var/www/html && \
    chmod 750 /usr/lib/cgi-bin

# Copiar los archivos del proyecto al contenedor
COPY ./index.html /var/www/html/
COPY ./css/ /var/www/html/css/
COPY ./cgi-bin/lab06.pl /usr/lib/cgi-bin/
# Copiar el archivo CSV al contenedor
COPY ./cgi-bin/Data_Universidades_LAB06.csv /usr/lib/cgi-bin/Data_Universidades_LAB06.csv

# Establecer permisos para los scripts CGI
RUN chmod +x /usr/lib/cgi-bin/lab06.pl

# Limpiar cachés de instalación para reducir el tamaño de la imagen
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Exponer los puertos requeridos
EXPOSE 80

# Iniciar Apache en primer plano
CMD ["bash", "-c", "apachectl -D FOREGROUND"]
