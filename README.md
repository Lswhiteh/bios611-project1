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

As it turns out, this dataset is completely categorical, which means we have some interesting problems to deal with. First, however, let's see if our classes are balanced.

![](assets/class_props.png)

Turns out, they're pretty evenly balanced, which is good because it allows us to have confidence in a machine learning model without having to weight classification outcomes drastically. Oftentimes a dataset will perform better at categories with more samples because it has more examples to learn from, and often we try to avoid this pitfall by either having as even of a sample distribution as possible or by weighting our loss function by the proportion of samples for each class.

Now let's look at the categorical features, since understanding how many options there are in total will give us a sense of how expressive a neural network would have to be to accurately classify/generate from this data.

![](assets/category_options.png)

That's a decent amount, and there are multiple ways we could approach this. The first will be a basic association test and decision tree based on whichever features are most-closely associated. This will give us a really good idea of how easy it is to predict edible/poisonous based on the features we have. Building a model that's overly complex is a waste of resources and time, so we'll try to get the simplest method for getting to an accurate prediction possible.

#### Basic Association Testing

First thing we'll do is determine how closely-associated all our features are. If there are some easily-distinguished relationships, that will give us an idea of how the decision tree is being pruned later on, and how much feature variance we have. Then, we'll fit a decision tree model onto our data that will let us condense those relationships into an easily-parseable tree for a figure.

![](odor_importance_tree.png)

Looks like the odor feature is extremely predictive, to the point where it can predict with almost perfectly high accuracy using a decision tree model:

![](assets/conf_mat_odor.png)


But there's a pretty big problem with this, we can't assume everyone can smell the same. While it's safe to assume that the stronger smelling ones are pretty easy to differentiate, visual inspection is both easier to do by humans and by machines, so let's see if we can get good predictive power without the odor feature. 

![]no_odor_importance_tree.png)

![](assets/conf_mat_no_odor.png)

Turns out, we can! And, in a stroke of luck, it actually goes the opposite direction the odor-included tree did and overestimates how many are poisonous, without predicting any in our test set as falsely edible. In the context of health, this is an extremely important difference and we should choose this model even if it is slightly less accurate. 

#### Image Preliminary Analysis

Next, we'll look at the distribution of samples in our image dataset, that way we can get a feel for how weighted our classes will be. 
