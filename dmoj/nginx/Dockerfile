FROM bash:5.3 as temporal

COPY cdnjs/urls.txt /home/cdnjs/
COPY cdnjs/wget-urls.sh /home/cdnjs/

RUN bash /home/cdnjs/wget-urls.sh

FROM nginx:stable

COPY --from=temporal /home/cdnjs/downloads /usr/share/nginx/cdnjs

COPY nginx.conf /etc/nginx/conf.d/default.conf
