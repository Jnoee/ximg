FROM cntest/centos:7.6

ENV SRC_DIR /usr/local/src
ENV NGX_DIR /usr/local/openresty/nginx
ENV TRACKER_BASE_PATH /ximg/tracker
ENV STORAGE_BASE_PATH /ximg/storage
ENV TRACKER_PORT 22122
ENV STORAGE_PORT 23000
ENV GROUP_NAME ximg
ENV HTTP_SERVER_PORT 8888
ENV IMG_DIR /ximg/imgs
ENV LUA_DIR /ximg/lua

RUN yum install -y gcc make pcre-devel openssl-devel perl

WORKDIR $SRC_DIR
ADD ./ext/libfastcommon-1.0.39.tar.gz .
RUN cd libfastcommon-1.0.39 \
    && ./make.sh \
    && ./make.sh install

WORKDIR $SRC_DIR
ADD ./ext/fastdfs-5.11.tar.gz .
RUN cd fastdfs-5.11 \
&& ./make.sh \
&& ./make.sh install \
&& cp conf/*.conf /etc/fdfs \
&& cd /etc/fdfs/ \
&& rm -rf *.sample

WORKDIR $SRC_DIR
ADD ./ext/fastdfs-nginx-module-1.20.tar.gz .
ADD ./ext/openresty-1.13.6.2.tar.gz .
RUN cd openresty-1.13.6.2 \
    && ./configure --add-module=../fastdfs-nginx-module-1.20/src \
    && make \
    && make install \
    && cp ../fastdfs-nginx-module-1.20/src/mod_fastdfs.conf /etc/fdfs/

RUN yum install -y gettext
WORKDIR $SRC_DIR
ADD ./conf/nginx.conf .
RUN envsubst '$IMG_DIR $LUA_DIR $STORAGE_BASE_PATH' < nginx.conf > $NGX_DIR/conf/nginx.conf

RUN yum install -y libpng libjpeg libpng-devel libjpeg-devel ghostscript libtiff libtiff-devel freetype freetype-devel
WORKDIR $SRC_DIR
ADD ./ext/GraphicsMagick-1.3.31.tar.gz .
RUN cd GraphicsMagick-1.3.31 \
    && ./configure --enable-shared \
    && make \
    && make install

RUN mkdir -p $TRACKER_BASE_PATH \
	&& mkdir -p $STORAGE_BASE_PATH \
	&& mkdir -p $IMG_DIR \
	&& mkdir -p $LUA_DIR
COPY ./lua/*.lua $LUA_DIR/

WORKDIR $SRC_DIR
ADD ./sh/tracker.sh .
ADD ./sh/storage.sh .