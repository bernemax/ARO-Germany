
"""
Created on Mon Jun 13 16:52:29 2022

@author: Max Bernecker
"""

from random import random
import matplotlib.pyplot as plt
import numpy as np
import os
import json
import pandas as pd
from sklearn.cluster import KMeans
from sklearn.metrics import silhouette_score
from sklearn.preprocessing import StandardScaler

#%%

v_id = ()
lon = ()
lat = ()
weight = ()
distance = ()


colum_names = ['v_id', 'lon','lat','weight']
nodedf = pd.read_excel('Z:/MitarbeiterOrdner/Bernecker/GitHub Desktop Project Foulder/nodes.xlsx', names=colum_names, index_col=0, header=0)

print(nodedf)

#%%
lon = nodedf['lon']
lat = nodedf['lat']
weight = nodedf['weight']
v_id = nodedf['v_id']

print(lon, lat, weight, v_id)

X_Data = nodedf.loc[:,['lon','lat','weight','v_id']]

print(X_Data.head(5))


#%%


kmeans = KMeans(n_clusters = 100, max_iter= 1000 ,init= 'k-means++' , n_init=100000)

weighted_kmeans = kmeans.fit(nodedf[['lon','lat']], sample_weight = weight)

#normal_kmeans = kmeans.fit(nodedf[['lon','lat']])


#%%

SSE = kmeans.inertia_
center_node = kmeans.cluster_centers_
lables = kmeans.labels_
rounds = kmeans.n_iter_

#X_Data ['clusters'] = kmeans.fit_predict(X_Data[X_Data.columns[1:3]])
#lables = kmeans.predict(X_Data[X_Data.columns[1:3]])

print(SSE,center_node,lables,rounds)
plt.scatter(center_node[:,0],center_node[:,1], s=50 )

list_v_id = v_id.tolist()
list_lables = lables.tolist()

para_lon = center_node[:,0]
para_lat = center_node[:,1]

#print(list_v_id)
#print(list_lables)

#%%

output_df1 = pd.DataFrame ({'Node': list_v_id, 'Cluster': list_lables})
output_df2 = pd.DataFrame ({'SSE': SSE, 'Iterations' : rounds}, index= [0,1])
output_df3 = pd.DataFrame ({'Coord_lon': para_lon,'Coord_lat': para_lat})


writer = pd.ExcelWriter("Cluster_Result.xlsx", engine='xlsxwriter')


output_df1.to_excel(writer, sheet_name = 'output_1', index = True)
output_df2.to_excel(writer, sheet_name = 'output_2', index = True)
output_df3.to_excel(writer, sheet_name = 'output_3', index = True)

writer.save()

#with pd.ExcelWriter("Cluster_Result.xlsx") as writer:
#     output_df.to_excel(writer)
     



