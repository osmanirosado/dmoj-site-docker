FROM bash:5.3 as temporal

ARG STORAGE_GOOGLE_APIS=nexus.uclv.edu.cu/repository/storage.googleapis.com
ARG CHROME_RELEASE=138.0.7204.168

WORKDIR /home

# chrome
RUN wget https://"$STORAGE_GOOGLE_APIS"/chrome-for-testing-public/"$CHROME_RELEASE"/linux64/chrome-linux64.zip
RUN unzip chrome-linux64.zip && mv chrome-linux64 chrome

# chrome headlees shell
RUN wget https://"$STORAGE_GOOGLE_APIS"/chrome-for-testing-public/"$CHROME_RELEASE"/linux64/chrome-headless-shell-linux64.zip
RUN unzip chrome-headless-shell-linux64.zip && mv chrome-headless-shell-linux64 chrome-headless-shell

# chrome driver
RUN wget https://"$STORAGE_GOOGLE_APIS"/chrome-for-testing-public/"$CHROME_RELEASE"/linux64/chromedriver-linux64.zip
RUN unzip chromedriver-linux64.zip && mv chromedriver-linux64 chromedriver

FROM python:3.11

WORKDIR /home

RUN git clone https://github.com/DMOJ/pdfoid.git

WORKDIR /home/pdfoid

RUN pip3 install -e .

# exiftool
RUN bash <<'EOF'

apt-get update
apt-get install -y --no-install-recommends libimage-exiftool-perl

rm -rf /var/lib/apt/lists/*

EOF

# chrome
COPY --from=temporal /home/chrome-headless-shell/ /opt/chrome-headless-shell/
COPY --from=temporal /home/chromedriver/ /opt/chromedriver/

RUN bash <<'EOF'

apt-get update

while read pkg; do
  apt-get satisfy -y --no-install-recommends "${pkg}";
done < /opt/chrome-headless-shell/deb.deps;

rm -rf /var/lib/apt/lists/*

EOF

ENV CHROME_PATH=/opt/chrome/chrome
ENV CHROMEDRIVER_PATH=/opt/chromedriver/chromedriver
ENV EXIFTOOL_PATH=/usr/bin/exiftool

RUN useradd pdfoid

USER pdfoid

EXPOSE 8888

CMD python pdfoid --address=pdfoid --port=8888
