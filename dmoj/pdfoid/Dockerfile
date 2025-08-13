FROM bash:5.3 AS temporal

ARG STORAGE_GOOGLE_APIS=storage.googleapis.com
ARG CHROME_RELEASE=123.0.6309.0

WORKDIR /home

# chrome
RUN wget "https://$STORAGE_GOOGLE_APIS/chrome-for-testing-public/$CHROME_RELEASE/linux64/chrome-linux64.zip"
RUN unzip chrome-linux64.zip && mv chrome-linux64 chrome

# chrome headlees shell
#RUN wget "https://$STORAGE_GOOGLE_APIS/chrome-for-testing-public/$CHROME_RELEASE/linux64/chrome-headless-shell-linux64.zip"
#RUN unzip chrome-headless-shell-linux64.zip && mv chrome-headless-shell-linux64 chrome-headless-shell

# chrome driver
RUN wget "https://$STORAGE_GOOGLE_APIS/chrome-for-testing-public/$CHROME_RELEASE/linux64/chromedriver-linux64.zip"
RUN unzip chromedriver-linux64.zip && mv chromedriver-linux64 chromedriver

# pdfoid
RUN wget 'https://github.com/DMOJ/pdfoid/archive/refs/heads/master.zip'
RUN unzip master.zip && mv pdfoid-master pdfoid

FROM python:3.11-slim

# chrome
COPY --from=temporal /home/chrome/ /opt/chrome/
COPY --from=temporal /home/chromedriver/ /opt/chromedriver/

# chrome dependencies
COPY chrome-deps-install.sh /home/
COPY deb.deps /home/
RUN bash /home/chrome-deps-install.sh /home/deb.deps

# chrome test
RUN /opt/chrome/chrome --version
RUN /opt/chromedriver/chromedriver --version

# exiftool dependency
RUN apt-get update && apt-get install -y --no-install-recommends libimage-exiftool-perl && apt-get clean

# fonts
RUN apt-get update && apt-get install -y --no-install-recommends fonts-liberation fonts-noto && apt-get clean

# add contrib and non-free components to debian sources
RUN sed -i 's/^Components: main$/& contrib non-free non-free-firmware/' /etc/apt/sources.list.d/debian.sources

# microsoft fonts
RUN apt-get update && apt-get install -y --no-install-recommends ttf-mscorefonts-installer && apt-get clean

WORKDIR /home

COPY --from=temporal /home/pdfoid/ /home/pdfoid/

WORKDIR /home/pdfoid

RUN pip3 install selenium==4.9.1
RUN pip3 install -e .

RUN useradd pdfoid

USER pdfoid

ENV CHROME_PATH=/opt/chrome/chrome
ENV CHROMEDRIVER_PATH=/opt/chromedriver/chromedriver
ENV EXIFTOOL_PATH=/usr/bin/exiftool

EXPOSE 8887
CMD python3 pdfoid --address=pdfoid --port=8887
