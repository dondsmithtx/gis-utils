FROM centos
RUN yum -y update
RUN echo "#################### Installing base packages and PostgreSQL 13 ####################" &&\
    yum -y install epel-release &&\
    yum install -y https://download.postgresql.org/pub/repos/yum/reporpms/EL-8-x86_64/pgdg-redhat-repo-latest.noarch.rpm &&\
    yum -qy module disable postgresql &&\
    yum -y install curl\ 
                   diffutils\ 
                   file\ 
                   gcc\
                   gcc-c++\
                   geos\
                   geos-devel\
                   json-c\
                   libtiff\
                   libpng\
                   libpq-devel\
#                   libxml2\
#                   libxml2-devel\
                   lsof\
                   make\
                   nodejs\
                   npm\ 
                   p7zip\
                   perl\
                   postgresql13-server\
                   postgresql13-devel\
                   rsync\
                   sqlite-devel\
                   telnet\
                   tree\
                   wget\ 
                   which\ 
                   unzip\
                   zip

RUN echo "#################### Installing Proj6 required for gdal ####################" &&\
    cd /root &&\
    wget https://download.osgeo.org/proj/proj-6.3.2.zip &&\
    unzip proj-6.3.2.zip &&\
    cd proj-6.3.2 &&\
    ./configure &&\
    make &&\
    make install

RUN echo "#################### Installing FileGDB API 1.5.1 for fgdb gdal driver ####################" &&\
    cd /root && \ 
    wget https://github.com/Esri/file-geodatabase-api/raw/master/FileGDB_API_1.5.1/FileGDB_API_1_5_1-64gcc51.tar.gz &&\
    tar xvzf FileGDB_API_1_5_1-64gcc51.tar.gz &&\
    cd FileGDB_API-64gcc51 &&\
    cp -R /root/FileGDB_API-64gcc51 /usr/lib64/ &&\
    echo 'include /usr/lib64/FileGDB_API-64gcc51/lib' > /etc/ld.so.conf.d/fgdb.conf
#    cp lib/*.so /usr/lib64 &&\
#    echo 'include /root/FileGDB_API-64gcc51/lib' > /etc/ld.so.conf.d/fgdb.conf

RUN echo "#################### Installing gdal with the fgdb driver ####################" &&\
    cd /root &&\
    wget https://github.com/OSGeo/gdal/releases/download/v3.3.0/gdal-3.3.0.tar.gz &&\
    tar -zvxf gdal-3.3.0.tar.gz &&\
    cd gdal-3.3.0 &&\
    ./configure --with-fgdb=/root/FileGDB_API-64gcc51 \
                --with-proj=/usr/local\
                --with-threads\ 
                --with-libtiff=internal\
                --with-geotiff=internal\
                --with-jpeg=internal\
                --with-gif=internal\
                --with-png=internal\
                --with-libz=internal &&\
    export LD_LIBRARY_PATH=/usr/lib64/FileGDB_API-64gcc/lib:$LD_LIBRARY_PATH &&\
    make &&\
    make install

RUN echo "#################### Installing libiconv ####################" &&\
    cd /root &&\  
    wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz &&\
    tar xvzf libiconv-1.16.tar.gz &&\
    cd libiconv-1.16 &&\
    ./configure --prefix=/usr/local &&\
    cd /root/libiconv-1.16 &&\
    make &&\
    make install 

RUN echo "#################### Installing postgis ####################" &&\
    cd /root && \ 
    wget http://postgis.net/stuff/postgis-3.2.0dev.tar.gz &&\
    tar -xvzf postgis-3.2.0dev.tar.gz &&\
    cd postgis-3.2.0dev &&\
    ./configure --with-pgconfig=/usr/pgsql-13/bin/pg_config\
                --with-gdalconfig=/usr/local/bin/gdal-config\
                --with-geosconfig=/usr/bin/geos-config \
#                --with-xml2config=/usr/bin/xml2-config \
                --with-projdir=/usr/local/include/proj \
                --with-libiconv=/root/libiconv-1.16/include \
		--without-protobuf && \
    make &&\
    make install

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
