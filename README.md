# Project 1 Bios 611

---

## Mushroom Classification and Generation Dataset

---

## Introduction

Mushrooms are a fungi that are commonly used in food and sometimes for medicinal purposes, but the wide variety of characteristics across mushroom types can make distinction of species or sub-species difficult. This becomes even more challenging due to the fact that many mushroom types have evolved to have similar colors, patterns, and shapes due to varying evolutionary forces. When looking for edible mushrooms, knowing the difference between subtypes could easily be a matter of life and death, so finding a lightweight model that can classify mushrooms through a few questions about its characteristics from a phone could be very useful for hikers and mycologists alike.

This project aims to both explore what differentiates mushroom types/subtypes and create the most lightweight model possible for accurately discriminating edible from poisonous mushrooms given a fairly limited dataset containing only categorical data.  

### Datasets

The dataset we're using is found [on Kaggle and is publicly available.](https://www.kaggle.com/uciml/mushroom-classification) It consists of quite a few aspects of mushrooms and associated pictures

### Installation and Running

To get reports (the easy way):
```{bash}
git clone https://github.com/Lswhiteh/bios611-project1
source activate aliases.sh

#Build
$ dbuild

#Run bash terminal through Docker image
$ b

#or

#Run Rstudio through Docker image
$ r
```

If using Rstudio:
- Open a web browser to http://localhost:8787
- Username: rstudio
- Password: \<your linux user password>


To get reports (the hard way):

```{bash}
$ git clone https://github.com/Lswhiteh/bios611-project1

#Build 
$ docker build -f Dockerfile . --tag rcon

#Run
$ docker run -v `pwd`:/home/rstudio -e PASSWORD=not_important -it rcon sudo -H -u rstudio /bin/bash -c "cd ~/; /bin/bash"
```

Regardless how you get there, you can generate the project 1 report by going to a bash terminal and:

```{bash}
$ make Mushroom_analysis.pdf
```

And that's it! There should be a pdf called "Mushroom_analysis.pdf" in the base project directory with the completed writeup/figures.

---

## Shiny app

```{bash}
#After sourcing aliases.sh
$ shiny
```

Go to `http://0.0.0.0:8788` in your web browser.

---

## Homework 4
Simply `$ make homework4` and the homework4.pdf will be in the base homeworks directory.

## Homework 5
Simply `$ make homework5` and the homework5.pdf will be in the base homeworks directory.