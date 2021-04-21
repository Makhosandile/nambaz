FROM python:3.9-alpine
LABEL maintainer="Makhosandile"
LABEL version="1.0"

ENV PYTHONUNBUFFERED 1

# Install dependencies
COPY ./requirements.txt /requirements.txt
RUN apk add --update --no-cache postgresql-client jpeg-dev
RUN apk add --no-cache --update \
    python3 python3-dev gcc \
    gfortran musl-dev g++ \
    libffi-dev openssl-dev \
    libxml2 libxml2-dev \
    libxslt libxslt-dev \
    libc-dev linux-headers postgresql-dev \
    libjpeg-turbo-dev zlib-dev musl-dev zlib \
     --virtual .tmp-build-deps   
RUN pip install -r /requirements.txt
RUN apk del .tmp-build-deps

# Setup directory structure
RUN mkdir /users
WORKDIR /users
COPY ./users/ /users

RUN mkdir -p /vol/web/media
RUN mkdir -p /vol/web/static
RUN adduser -D user
RUN chown -R user:user /vol/
RUN chmod -R 755 /vol/web
USER user