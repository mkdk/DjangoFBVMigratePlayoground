# Use the AWS Elastic Beanstalk Python 3.4 image
# original file here https://github.com/aws/aws-eb-python-dockerfiles/blob/master/3.4.2-aws-eb-onbuild/Dockerfile
# i decide get source and create own configurations cz last update for repository was 4 years ago and there 4 openissue
# seems repo was died

FROM       python:3.4.2

ENV        UWSGI_NUM_PROCESSES    1
ENV        UWSGI_NUM_THREADS      15
ENV        UWSGI_UID              uwsgi
ENV        UWSGI_GID              uwsgi
ENV        UWSGI_LOG_FILE         /var/log/uwsgi/uwsgi.log
ENV        DJANGO_SETTINGS_MODULE conduit.settings
ENV        DOCKER                 1

WORKDIR    /var/app
ADD . /var/app

RUN        apt-get update && apt-get install -y vim cron

ADD cronos /etc/cron.d/cronos
RUN chmod 0644 /etc/cron.d/cronos
RUN crontab /etc/cron.d/cronos
RUN touch /var/log/grab_rss.log
RUN touch /var/log/cron.log

RUN        pip3 install setuptools==18.5
RUN        pip3 install -r /var/app/requirements.txt
RUN        useradd uwsgi -s /bin/false
RUN        mkdir /var/log/uwsgi
RUN        chown -R uwsgi:uwsgi /var/log/uwsgi



EXPOSE 8080
ADD        uwsgi-start.sh /

CMD        []

RUN ["chmod", "+x", "/uwsgi-start.sh"]
ENTRYPOINT ["/uwsgi-start.sh"]


