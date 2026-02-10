FROM debian:12-slim AS temporal

RUN apt-get update && apt-get install -y wget && apt-get clean

COPY cdnjs/urls.txt /home/cdnjs/

WORKDIR /home/cdnjs/

RUN wget --directory-prefix downloads --no-host-directories --force-directories --input-file urls.txt

FROM nginx:stable

COPY wikipedia/Blue_Marble_2002.png /usr/share/nginx/wikipedia/
COPY --from=temporal /home/cdnjs/downloads/ /usr/share/nginx/cdnjs/

RUN rm /etc/nginx/conf.d/default.conf

COPY dmoj.conf /etc/nginx/conf.d/
