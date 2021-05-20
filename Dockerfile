FROM centos
RUN yum -y update
RUN yum -y install epel-release 
RUN yum -y install which unzip wget curl telnet nodejs npm tree lsof postgresql gcc-c++ gcc libpng libtiff make file diffutils sqlite-devel

#RUN wget https://www.sqlite.org/snapshot/sqlite-snapshot-202105171714.tar.gz && \
#tar xvzf sqlite-snapshot-202105171714.tar.gz && \
#cd sqlite-snapshot-202105171714 && \
#./configure --prefix=/usr --disable-static        \
#            CFLAGS="-g -O2 -DSQLITE_ENABLE_FTS3=1 \
#            -DSQLITE_ENABLE_COLUMN_METADATA=1     \
#            -DSQLITE_ENABLE_UNLOCK_NOTIFY=1       \
#            -DSQLITE_SECURE_DELETE=1              \
#            -DSQLITE_ENABLE_DBSTAT_VTAB=1" &&     \
#make -j1
#RUN cd /sqlite-snapshot-202105171714 && make install

RUN wget https://download.osgeo.org/proj/proj-6.3.2.zip
RUN unzip proj-6.3.2.zip
RUN cd proj-6.3.2 && ./configure && make && make install

RUN cd /root/ && \ 
  wget https://github.com/Esri/file-geodatabase-api/raw/master/FileGDB_API_1.5.1/FileGDB_API_1_5_1-64gcc51.tar.gz && \
  tar xvzf FileGDB_API_1_5_1-64gcc51.tar.gz && \
  cd FileGDB_API-64gcc51 && \
  cp lib/*.so /usr/lib64
RUN echo 'include /root/FileGDB_API-64gcc51/lib' > /etc/ld.so.conf.d/fgdb.conf

RUN wget https://github.com/OSGeo/gdal/releases/download/v3.3.0/gdal-3.3.0.tar.gz
RUN tar -zvxf gdal-3.3.0.tar.gz
RUN cd gdal-3.3.0 && ./configure --with-proj=/usr/local --with-threads  --with-fgdb=/root/FileGDB_API-64gcc51 --with-libtiff=internal --with-geotiff=internal --with-jpeg=internal --with-gif=internal --with-png=internal --with-libz=internal && export LD_LIBRARY_PATH=/root/FileGDB_API-64gcc/lib:$LD_LIBRARY_PATH && make && make install

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
