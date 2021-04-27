FROM rocker/verse
MAINTAINER Matt Johnson <Johnson.Matt1818@gmail.com>
RUN R -e "install.packages('Lahman')"
RUN R -e "install.packages('gridExtra')"
RUN R -e "install.packages('cluster')"
RUN R -e "install.packages('factoextra')"