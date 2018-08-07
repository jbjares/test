FROM python:3.7.0-alpine3.8
LABEL maintainer="luk.zim91@gmail.com"

COPY app /opt/app
COPY requirements.txt /opt/requirements.txt

WORKDIR /opt
RUN addgroup -S app && \
    adduser -s /bin/sh -G app -S -D -H app && \
    pip install -U --no-cache-dir -r requirements.txt && \
    rm /opt/requirements.txt && \
    chown -R app:app /opt && \
    rm -rf /tmp/* /var/tmp/*

USER app
WORKDIR /opt/app
ENTRYPOINT [ "python" , "app.py" ]
EXPOSE 5000

