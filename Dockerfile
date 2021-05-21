FROM centos
RUN yum -y update
RUN yum -y install epel-release
RUN yum -y install curl\ 
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
                   libxml2\
                   libxml2-devel\
                   lsof\
                   make\
                   nodejs\
                   npm\ 
                   perl\
                   postgresql\
                   sqlite-devel\
                   telnet\
                   tree\
                   wget\ 
                   which\ 
                   unzip 

# Install Project 6 required for gdal
RUN wget https://download.osgeo.org/proj/proj-6.3.2.zip && \
    unzip proj-6.3.2.zip && \
    cd proj-6.3.2 && ./configure && \
    make && make install

# Install the FileGDB API Version 1.5.1 (1.4 doesn't support latest g++)
# Required for fgdb
RUN cd /root && \ 
    wget https://github.com/Esri/file-geodatabase-api/raw/master/FileGDB_API_1.5.1/FileGDB_API_1_5_1-64gcc51.tar.gz && \
    tar xvzf FileGDB_API_1_5_1-64gcc51.tar.gz && \
    cd FileGDB_API-64gcc51 && \
    cp lib/*.so /usr/lib64 && \
    echo 'include /root/FileGDB_API-64gcc51/lib' > /etc/ld.so.conf.d/fgdb.conf

# Install gdal and fgdb driver
RUN cd /root && \
    wget https://github.com/OSGeo/gdal/releases/download/v3.3.0/gdal-3.3.0.tar.gz && \
    tar -zvxf gdal-3.3.0.tar.gz && \
    cd gdal-3.3.0 && \
    ./configure --with-fgdb=/root/FileGDB_API-64gcc51 \
                --with-proj=/usr/local \
                --with-threads \ 
                --with-libtiff=internal \
                --with-geotiff=internal \
                --with-jpeg=internal \
                --with-gif=internal \
                --with-png=internal \
                --with-libz=internal && \
    export LD_LIBRARY_PATH=/root/FileGDB_API-64gcc/lib:$LD_LIBRARY_PATH && \
    make && make install

# Install libiconv
RUN cd /root && \ 
    wget https://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.16.tar.gz && \
    tar xvzf libiconv-1.16.tar.gz && \
    cd libiconv-1.16 && \
    ./configure --prefix=/usr/local && \
    cd /root/libiconv-1.16 && \
    make && make install 

# Install postgis
RUN cd /root && \ 
    wget http://postgis.net/stuff/postgis-3.1.2dev.tar.gz && \
    tar -xvzf postgis-3.1.2dev.tar.gz && \
    cd postgis-3.1.2dev && \
    ./configure --with-pgconfig=/usr/bin/pg_config \
    ./configure --with-gdalconfig=/usr/local/bin/gdal-config \
                --with-geosconfig=/usr/bin/geos-config \
                --with-xml2config=/usr/bin/xml2-config \
                --with-projdir=/usr/local/include/proj \
                --with-libiconv=/root/libiconv-1.16/include \
		--without-protobuf && \
    make && make install

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
