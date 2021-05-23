FROM centos

ARG postgresql_url="https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm"

ARG proj6_url="https://download.osgeo.org/proj"
ARG proj6_dir="proj-6.3.2"
ARG proj6_pkg="proj-6.3.2.zip"

ARG fgdb_url="https://github.com/Esri/file-geodatabase-api/raw/master/FileGDB_API_1.5.1"
ARG fgdb_pkg="FileGDB_API_1_5_1-64gcc51.tar.gz"
ARG fgdb_dir="FileGDB_API-64gcc51"

ARG gdal_url="https://github.com/OSGeo/gdal/releases/download/v3.3.0/"
ARG gdal_pkg="gdal-3.3.0.tar.gz"
ARG gdal_version="3.3.0"

ARG libiconv_url="https://ftp.gnu.org/pub/gnu/libiconv"
ARG libiconv_pkg="libiconv-1.16.tar.gz"
ARG libiconv_version="1.16"

ARG postgis_url="http://postgis.net/stuff"
ARG postgis_pkg="postgis-3.2.0dev.tar.gz"
ARG postgis_version="3.2.0"

RUN yum -y update
RUN echo "#################### Installing base packages and PostgreSQL 13 ####################" && \
    yum -y install epel-release && \
    yum -y install ${postgresql_url} && \
    yum -qy module disable postgresql && \
    yum -y install curl \
                   diffutils \
                   file \
                   gcc \
                   gcc-c++ \
                   geos \
                   geos-devel \
                   json-c \
                   libtiff \
                   libxml2-devel \
                   libpng \
                   libpq-devel \
                   lsof \
                   make \
                   nodejs \
                   npm \
                   p7zip \
                   perl \
                   postgresql13-server \
                   postgresql13-devel \
                   rsync \
                   sqlite-devel \
                   telnet \
                   tree \
                   wget \
                   which \
                   unzip \
                   zip

RUN echo "#################### Installing Proj6 required for gdal ####################" && \
    cd /root && \
    wget ${proj6_url}/${proj6_pkg} && \
    unzip ${proj6_pkg} && \
    cd ${proj6_dir} && \
    ./configure && \
    make && \
    make install
    
RUN echo "#################### Installing FileGDB API for fgdb gdal driver ####################" && \
    cd /root && \
    wget ${fgdb_url}/${fgdb_pkg} && \
    tar xvzf ${fgdb_pkg} && \
    cp -R /root/${fgdb_dir} /usr && \
    cp -R /root/${fgdb_dir}/lib/* /usr/lib && \
    cp -R /root/${fgdb_dir}/include/* /usr/include && \
    echo 'include /usr/${fgdb_dir}/lib' > /etc/ld.so.conf.d/fgdb.conf

RUN echo "#################### Installing libiconv ####################" && \
    cd /root && \
    wget ${libiconv_url}/${libiconv_pkg} && \
    tar xvzf ${libiconv_pkg} && \
    cd libiconv-${libiconv_version} && \
    ./configure --prefix=/usr/local && \
    cd /root/libiconv-${libiconv_version} && \
    make && \
    make install

RUN echo "#################### Installing gdal with the fgdb driver ####################" && \
    cd /root && \
    wget ${gdal_url}/${gdal_pkg} && \
    tar -zvxf ${gdal_pkg} &&\
    cd gdal-${gdal_version} && \
    ./configure --with-fgdb=/usr/${fgdb_dir} \
                --with-proj=/usr/local \
                --with-threads \
                --with-libtiff=internal \
                --with-geotiff=internal \
                --with-jpeg=internal \
                --with-gif=internal \
                --with-png=internal \
                --with-libz=internal && \
    make && \
    make install

RUN yum -y remove libxml2-devel
RUN echo "#################### Installing postgis ####################" && \
    cd /root && \
    wget ${postgis_url}/${postgis_pkg} && \
    tar -xvzf ${postgis_pkg} && \
    cd postgis-${postgis_version}dev && \
    cp /root/libiconv-${libiconv_version}/include/* /usr/include && \
    ./configure --with-pgconfig=/usr/pgsql-13/bin/pg_config \
                --with-gdalconfig=/usr/local/bin/gdal-config \
                --with-geosconfig=/usr/bin/geos-config \
                --with-projdir=/usr/local/include/proj \
                --with-libiconv=/usr/include \
		        --without-protobuf && \
#               libxml2 removed due to incompatibility between with the embedded copy within libFileGDBAPI
#               --with-xml2config=/usr/bin/xml2-config \
    make && \
    make install
RUN yum -y install libxml2-devel

RUN echo "#################### Clean up software packages ####################" && \
    rm -rf /root/FileGDB_API* && \
    rm -rf /root/proj-* && \
    rm -rf /root/gdal-* && \
    rm -rf /root/libiconv-* && \
    rm -rf /root/postgis-*

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
