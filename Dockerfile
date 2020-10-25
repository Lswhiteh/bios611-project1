FROM rocker/verse
LABEL Logan Whitehouse <lswhiteh@unc.edu>
RUN R -e "install.packages(c('janitor', \
    'mltools', \
    'reshape', \
    'rpart', \
    'rpart.plot', \
    'arules', \
    'klaR', \
    'FactoMineR', \
    'factoextra', \
    'gbm', \
    'caret', \
    'ROCR'))"
RUN apt-get update
RUN apt update -y && apt install -y python3-pip
RUN pip3 install jupyter jupyterlab
RUN pip3 install numpy pandas sklearn plotnine seaborn matplotlib pandasql bokeh