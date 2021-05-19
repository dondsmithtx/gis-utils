FROM centos
RUN dnf -y install unzip wget curl telnet nodejs npm tree lsof postgresql initscripts gcc-c++ gcc libpng libtiff make file diffutils sqlite-devel

RUN wget https://download.osgeo.org/proj/proj-6.3.2.zip
RUN unzip proj-6.3.2.zip
RUN cd proj-6.3.2 && ./configure && make && make install

RUN export LD_LIBRARY_PATH=/root/FileGDB_API-64gcc/lib:$LD_LIBRARY_PATH
RUN cd /root/ && \ 
wget https://github.com/Esri/file-geodatabase-api/raw/master/FileGDB_API_1.4/FileGDB_API_1_4-64gcc.zip && \
unzip FileGDB_API_1_4-64gcc.zip && \
cd FileGDB_API-64gcc/samples && \
export LD_LIBRARY_PATH=/root/FileGDB_API-64gcc/lib:$LD_LIBRARY_PATH \
make
RUN echo /root/FileGDB_API-64gcc/lib > /etc/ld.so.conf.d/fgdb.conf

RUN wget https://github.com/OSGeo/gdal/releases/download/v3.3.0/gdal-3.3.0.tar.gz
RUN tar -zvxf gdal-3.3.0.tar.gz
RUN cd gdal-3.3.0 && ./configure --with-proj=/usr/local --with-threads  --with-fgdb=/root/FileGDB_API-64gcc/ --with-libtiff=internal --with-geotiff=internal --with-jpeg=internal --with-gif=internal --with-png=internal --with-libz=internal && export LD_LIBRARY_PATH=/root/FileGDB_API-64gcc/lib:$LD_LIBRARY_PATH && make && make install
RUN dnf -y install unzip wget curl telnet nodejs npm tree lsof postgresql 

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]

