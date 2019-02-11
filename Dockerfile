FROM python:3.6-jessie

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -qq update
RUN apt-get -qq install locales krb5-user

COPY src/krb5.conf /etc/
COPY src/start-nb.sh /usr/local/bin/

# Set timezone
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Add notebook user
ARG NB_USER=noobie
ARG NOTEBOOK_TOKEN=use_a_better_password_0

RUN adduser --shell /bin/bash --uid 501 $NB_USER \
    --disabled-password --gecos ""

# Install jupyter
RUN pip install jupyter jupyterlab
RUN chown $NB_USER /usr/local/bin/start-nb.sh

# Install kudu
RUN echo 'deb [trusted=yes] http://archive.cloudera.com/kudu/debian/jessie/amd64/kudu jessie-kudu5 contrib' >> /etc/apt/sources.list
RUN echo 'deb-src [trusted=yes] http://archive.cloudera.com/kudu/debian/jessie/amd64/kudu jessie-kudu5 contrib' >> /etc/apt/sources.list
RUN echo 'deb http://security.debian.org/debian-security jessie/updates main ' >> /etc/apt/sources.list
RUN apt update
RUN apt-get install libssl1.0.0 kudu libkuduclient0 libkuduclient-dev -y
RUN apt-get -qq clean

#RUN apt-get install kudu -y
#RUN apt-get install libkuduclient0 libkuduclient-dev  -y
# Kudu requires specific 1.2.0 version and deps(Latest kudu-python in pypi 2/6/19 broken with cdh 6.1)
RUN pip install Cython --install-option="--no-cython-compile"
RUN pip install kudu-python==1.2.0
RUN mkdir /data/ && chown $NB_USER /data/

# Other pip packages for web3
RUN pip install web3 requests

USER $NB_USER
WORKDIR /data
CMD ["sh", "/usr/local/bin/start-nb.sh"]
