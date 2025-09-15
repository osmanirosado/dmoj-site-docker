FROM debian:12-slim AS temporal

RUN apt-get update && apt-get install -y wget && apt-get clean

COPY cdnjs/urls.txt /home/cdnjs/

WORKDIR /home/cdnjs/

RUN wget --directory-prefix downloads --no-host-directories --force-directories --input-file urls.txt

WORKDIR /home/wikipedia/

RUN wget --directory-prefix downloads 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/23/Blue_Marble_2002.png/1024px-Blue_Marble_2002.png'

FROM nginx:stable

COPY --from=temporal /home/cdnjs/downloads/ /usr/share/nginx/cdnjs/
COPY --from=temporal /home/wikipedia/downloads/ /usr/share/nginx/wikipedia/

RUN rm /etc/nginx/conf.d/default.conf

COPY dmoj.conf /etc/nginx/conf.d/
