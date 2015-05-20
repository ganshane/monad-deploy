FROM jcai/nirvana-java
MAINTAINER Jun Tsai <jcai@ganshane.com>

RUN {\
  apt-get update \
  && apt-get install -qqy numactl libaio-dev ; \
}

ADD apps/lib                                     /apps/dist/apps/lib
ADD apps/doc                                     /apps/dist/apps/doc
ADD config                                       /apps/dist/config
ADD apps/group                                   /apps/dist/apps/group
ADD apps/group-lib                               /apps/dist/apps/group-lib

WORKDIR /apps

ENV release_path /apps/dist
ENV app_path /apps
ENV _stage docker
ENV comp group


#group
RUN {\
  ln -s  ${release_path}/apps/${comp}  ${app_path}/${comp} \
  && ln -s  ${release_path}/apps/doc ${app_path}/${comp}/doc \
  && ln -s  ${release_path}/config/${_stage}/${comp}/config  ${app_path}/${comp}/ \
  && cp ${release_path}/config/${_stage}/${comp}/${group}rc ~/.${group}rc \
  && mkdir -p ${release_path}/apps/${comp}/lib \
  && ln -s  ${release_path}/apps/${comp}-lib/*  ${release_path}/apps/${comp}/lib/ \
  && ln -s  ${release_path}/apps/lib/*  ${release_path}/apps/${comp}/lib/ ; \
}

EXPOSE 3333

VOLUME ["/monad-group-data"]
VOLUME ["/monad-group-log"]

ADD dockers/group/run.sh /run.sh
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]

