FROM bash:5.3 AS temporal

WORKDIR /home

# texoid
RUN wget https://github.com/DMOJ/texoid/archive/refs/heads/master.zip
RUN unzip master.zip && mv texoid-master texoid

FROM python:3.11-slim

RUN <<EOF
apt-get update
apt-get install -y --no-install-recommends \
        texlive-binaries texlive-latex-base texlive-latex-extra texlive-latex-recommended \
        texlive-pictures texlive-pstricks librsvg2-bin xxd imagemagick dvisvgm
apt-get clean
EOF

COPY --from=temporal /home/texoid/ /opt/texoid/

WORKDIR /opt/texoid

RUN pip3 install -e .

RUN useradd texoid

USER texoid

EXPOSE 8886

CMD python3 texoid --address=texoid --port=8886
