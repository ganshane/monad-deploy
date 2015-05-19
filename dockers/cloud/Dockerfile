FROM jcai/nirvana-java
MAINTAINER Jun Tsai <jcai@ganshane.com>

RUN {\
  apt-get update \
  && apt-get install -qqy numactl libaio-dev ; \
}

ADD apps/cloud-lib                               /apps/dist/apps/cloud-lib
ADD apps/lib                                     /apps/dist/apps/lib
ADD apps/doc                                     /apps/dist/apps/doc
ADD apps/cloud                                   /apps/dist/apps/cloud
ADD config                                       /apps/dist/config

WORKDIR /apps

ENV release_path /apps/dist
ENV app_path /apps
ENV _stage docker
ENV comp cloud


#cloud
RUN {\
  ln -s  ${release_path}/apps/${comp}  ${app_path}/${comp} \
  && ln -s  ${release_path}/apps/doc ${app_path}/${comp}/doc \
  && ln -s  ${release_path}/config/${_stage}/${comp}/config  ${app_path}/${comp}/ \
  && cp ${release_path}/config/${_stage}/${comp}/cloudrc ~/.cloudrc \
  && mkdir -p ${release_path}/apps/${comp}/lib \
  && ln -s  ${release_path}/apps/${comp}-lib/*  ${release_path}/apps/${comp}/lib/ \
  && ln -s  ${release_path}/apps/lib/*  ${release_path}/apps/${comp}/lib/ ; \
}

EXPOSE 3333

VOLUME ["/monad-cloud-data"]
VOLUME ["/monad-cloud-log"]

ADD dockers/cloud/run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]

