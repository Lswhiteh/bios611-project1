Project 1 Bios 611
==================
Mushroom Classification and Generation Dataset
------------------------

Proposal
--------

### Introduction

Mushrooms are a fungi that are commonly used in food and sometimes for medicinal purposes, but the wide variety of characteristics across mushroom types can make distinction of species or sub-species difficult. This becomes even more challenging due to the fact that many mushroom types have evolved to have similar colors, patterns, and/or shapes, either through evolved mimicry or convergent evolution. When looking for edible mushrooms, knowing the difference between subtypes could easily be a matter of life and death, so training a lightweight network that can classify mushrooms through a few questions about its characteristics from a phone (and potentially predict the type on a phone!) could be very useful for hikers and mycologists alike. 

While we're at it, maybe we'll make some new tasty varieties using a generative model and our favorite aspects of mushrooms?

[What if we used these aspects to label an image dataset, and then did the same thing with that?](https://www.kaggle.com/maysee/mushrooms-classification-common-genuss-images) 

### Datasets

The dataset we're using is found [on Kaggle and is publicly available.](https://www.kaggle.com/uciml/mushroom-classification) It consists of quite a few aspects of mushrooms and associated pictures

```Attribute Information: (classes: edible=e, poisonous=p)

cap-shape: bell=b,conical=c,convex=x,flat=f, knobbed=k,sunken=s

cap-surface: fibrous=f,grooves=g,scaly=y,smooth=s

cap-color: brown=n,buff=b,cinnamon=c,gray=g,green=r,pink=p,purple=u,red=e,white=w,yellow=y

bruises: bruises=t,no=f

odor: almond=a,anise=l,creosote=c,fishy=y,foul=f,musty=m,none=n,pungent=p,spicy=s

gill-attachment: attached=a,descending=d,free=f,notched=n

gill-spacing: close=c,crowded=w,distant=d

gill-size: broad=b,narrow=n

gill-color: black=k,brown=n,buff=b,chocolate=h,gray=g, green=r,orange=o,pink=p,purple=u,red=e,white=w,yellow=y

stalk-shape: enlarging=e,tapering=t

stalk-root: bulbous=b,club=c,cup=u,equal=e,rhizomorphs=z,rooted=r,missing=?

stalk-surface-above-ring: fibrous=f,scaly=y,silky=k,smooth=s

stalk-surface-below-ring: fibrous=f,scaly=y,silky=k,smooth=s

stalk-color-above-ring: brown=n,buff=b,cinnamon=c,gray=g,orange=o,pink=p,red=e,white=w,yellow=y

stalk-color-below-ring: brown=n,buff=b,cinnamon=c,gray=g,orange=o,pink=p,red=e,white=w,yellow=y

veil-type: partial=p,universal=u

veil-color: brown=n,orange=o,white=w,yellow=y

ring-number: none=n,one=o,two=t

ring-type: cobwebby=c,evanescent=e,flaring=f,large=l,none=n,pendant=p,sheathing=s,zone=z

spore-print-color: black=k,brown=n,buff=b,chocolate=h,green=r,orange=o,purple=u,white=w,yellow=y

population: abundant=a,clustered=c,numerous=n,scattered=s,several=v,solitary=y

habitat: grasses=g,leaves=l,meadows=m,paths=p,urban=u,waste=w,woods=d
```

### Preliminary Figures


Usage
-----

You'll need Docker and the ability to run Docker as your current user.

You'll need to build the container:

    > docker build . -t project1-env

This Docker container is based on rocker/verse. To run rstudio server:

    > docker run -v `pwd`:/home/rstudio -p 8787:8787\
      -e PASSWORD=mypassword -t project1-env
      
Then connect to the machine on port 8787.

If you are cool and you want to run this on the command line:

    > docker run -v `pwd`:/home/rstudio -e PASSWORD=some_pw -it l6 sudo -H -u rstudio /bin/bash -c "cd ~/; R"
    
Or to run Bash:

    > docker run -v `pwd`:/home/rstudio -e PASSWORD=some_pw -it l6 sudo -H -u rstudio /bin/bash -c "cd ~/; /bin/bash"

Makefile
========

The Makefile is an excellent place to look to get a feel for the project.

To build figures relating to the distribution of super powers over
gender, for example, enter Bash either via the above incantation or
with Rstudio and say:

    > make figures/gender_power_comparison.png 
    
