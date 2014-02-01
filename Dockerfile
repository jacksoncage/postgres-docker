FROM 		base:ubuntu-quantal
MAINTAINER 	Love Nyberg <love.nyberg@lovemusic.se>

# Update apt sources
RUN echo "deb http://archive.ubuntu.com/ubuntu/ quantal main universe multiverse" > /etc/apt/sources.list

# Update the package repository
RUN apt-get update; apt-get upgrade -y; apt-get install locales

# Configure timezone and locale
RUN echo "Europe/Stockholm" > /etc/timezone; dpkg-reconfigure -f noninteractive tzdata
RUN export LANGUAGE=en_US.UTF-8; export LANG=en_US.UTF-8; export LC_ALL=en_US.UTF-8; locale-gen en_US.UTF-8; DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install base system
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y curl psmisc

# Exposes
EXPOSE 5432

# Install Dockyard
RUN curl -o /usr/local/bin/dockyard https://raw.github.com/dynport/dockyard/master/dockyard
RUN chmod 0755 /usr/local/bin/dockyard

RUN dockyard install postgresql 9.2.4

RUN useradd postgres

ADD pg_hba.conf     /etc/postgresql/9.2/main/
ADD pg_ident.conf   /etc/postgresql/9.2/main/
ADD postgresql.conf /etc/postgresql/9.2/main/

ADD start /start
RUN chmod 0755 /start
CMD ["bash", "start.sh"]