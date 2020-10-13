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

To install:

```{bash}
git clone https://github.com/Lswhiteh/bios611-project1
#Build 
docker build -f Dockerfile . --tag rcon

#Run
docker run -e PASSWORD=a -p 8787:8787 -v ~/bios611-project1:/home/rstudio/ rcon
```

- Open a web browser to `http://localhost:8787`
    - Username: `rstudio`
    - Password: `<your linux user password>`

In the terminal:

```{bash}
make all
```

And that's it! There should be a pdf called "Mushroom_analysis.pdf" in the base project directory with the completed writeup/figures.

---

## Homework 1
Simply `make homework1` and the homework1.pdf will be in the base homeworks directory.