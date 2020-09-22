FROM rocker/verse
LABEL Logan Whitehouse <lswhiteh@unc.edu>
RUN R -e "install.packages(c('janitor', 'mltools', 'reshape', 'rpart', 'rpart.plot', 'arules', 'klaR', 'FactoMineR', 'factoextra'))"
RUN apt-get update
RUN apt-get -y install imagemagick