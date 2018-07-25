FROM python:3.6-alpine
LABEL maintainer="luk.zim91@gmail.com"

COPY app /opt/app
COPY requirements.txt /opt/requirements.txt

WORKDIR /opt
RUN addgroup -S app && \
    adduser -s /bin/sh -G app -S -D -H app && \
    pip install --no-cache-dir -r requirements.txt && \
    chown -R app:app /opt

USER app
WORKDIR /opt/app
ENTRYPOINT [ "python" , "app.py" ]
EXPOSE 5000

