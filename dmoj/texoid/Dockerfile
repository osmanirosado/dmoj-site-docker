FROM bash:5.3 AS temporal

WORKDIR /home

# texoid
RUN wget https://github.com/DMOJ/texoid/archive/refs/heads/master.zip
RUN unzip master.zip && mv texoid-master texoid

FROM python:3.11-slim

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        texlive-binaries texlive-latex-base texlive-latex-extra texlive-latex-recommended \
        texlive-pictures texlive-pstricks librsvg2-bin xxd imagemagick dvisvgm && \
    apt-get clean

COPY --from=temporal /home/texoid/ /opt/texoid/

WORKDIR /opt/texoid

RUN pip3 install -e .

EXPOSE 8886
CMD python3 texoid --address=texoid --port=8886
