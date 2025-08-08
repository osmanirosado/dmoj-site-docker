FROM debian:12-slim as temporal

RUN apt-get update && apt-get install -y wget && apt-get clean

COPY cdnjs/urls.txt /home/cdnjs/
COPY cdnjs/wget-urls.sh /home/cdnjs/

WORKDIR /home/cdnjs/

RUN bash wget-urls.sh

COPY wikipedia/wget-map.sh /home/wikipedia/

WORKDIR /home/wikipedia/

RUN bash wget-map.sh

FROM nginx:stable

COPY --from=temporal /home/cdnjs/downloads/ /usr/share/nginx/cdnjs/
COPY --from=temporal /home/wikipedia/downloads/ /usr/share/nginx/wikipedia/

COPY nginx.conf /etc/nginx/conf.d/default.conf
