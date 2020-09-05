FROM rocker/verse
LABEL Logan Whitehouse <lswhiteh@unc.edu>
RUN R -e "install.packages(c('janitor', 'mltools'))"
