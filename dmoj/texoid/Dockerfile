FROM python:3.11-slim

RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends \
        texlive-binaries texlive-latex-base texlive-latex-extra texlive-latex-recommended \
        texlive-pictures texlive-pstricks librsvg2-bin xxd imagemagick dvisvgm
apt-get clean
EOF

ADD https://github.com/DMOJ/texoid.git /opt/texoid/

WORKDIR /opt/texoid

RUN pip3 install -e .

RUN useradd app

USER app

EXPOSE 8886

CMD python3 texoid --address=texoid --port=8886
