FROM centos
RUN dnf -y install unzip wget curl telnet nodejs npm tree lsof postgresql initscripts gcc-c++ gcc libpng libtiff make file diffutils sqlite-devel

RUN wget https://download.osgeo.org/proj/proj-6.3.2.zip
RUN unzip proj-6.3.2.zip
RUN cd proj-6.3.2 && ./configure && make && make install

RUN wget https://github.com/OSGeo/gdal/releases/download/v3.3.0/gdal-3.3.0.tar.gz
RUN tar -zvxf gdal-3.3.0.tar.gz
RUN cd gdal-3.3.0 && ./configure --with-proj=/usr/local --with-threads --with-libtiff=internal --with-geotiff=internal --with-jpeg=internal --with-gif=internal --with-png=internal --with-libz=internal && make && make install

ENTRYPOINT ["tail"]
CMD ["-f","/dev/null"]
