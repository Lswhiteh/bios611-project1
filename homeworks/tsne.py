from sklearn.manifold import TSNE
import numpy as np
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt

hero_num = pd.read_csv("tsne_input.csv")

hero_num.rename(
    columns={"cleaned_heroes$Alignment": "Alignment", "cleaned_heroes$Name": "Name"},
    inplace=True,
)

t_sne = pd.DataFrame(TSNE(2).fit_transform(hero_num.loc[:, "Intelligence":]))

hero_num["tsne_1"] = t_sne[0]
hero_num["tsne_2"] = t_sne[1]

hero_num.to_csv("t_sne_results.csv", index=None)

plt.close()
snsplot = sns.scatterplot(
    x="tsne_1",
    y="tsne_2",
    hue="Alignment",
    palette=sns.color_palette("hls", 2),
    data=hero_num,
    legend="full",
)

plt.savefig("snsplot.png")
plt.close()
