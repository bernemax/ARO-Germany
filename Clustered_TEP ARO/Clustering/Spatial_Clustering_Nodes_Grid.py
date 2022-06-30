
"""
Created on Mon Jun 13 16:01:28 2022

@author: Max Bernecker
"""


import pandas as pd, numpy as np, matplotlib.pyplot as plt
from sklearn.cluster import DBSCAN

from geopy.distance import great_circle
from shapely.geometry import MultiPoint

#%%

v_id = ()
lon = ()
lat = ()
weight = ()
km_per_radian = 6371.0088
epsilon = 32/ km_per_radian
coords = ()

colum_names = ['v_id', 'lon','lat','weight']
nodedf = pd.read_excel('Z:/MitarbeiterOrdner/Bernecker/GitHub Desktop Project Foulder/nodes.xlsx', names=colum_names, index_col=0, header=0)
#nodedf = pd.DataFrame

#%%

weight = nodedf['weight'] * 100
lon = nodedf['lon']
lat = nodedf['lat']

coords = nodedf[['lon','lat']].to_numpy()
print(nodedf, weight,lon,lat,coords)

#%%
Geo_kmeans = DBSCAN(eps=epsilon, min_samples=1, algorithm ='ball_tree' ,metric='haversine').fit(np.radians(coords))
cluster_labels = Geo_kmeans.labels_

num_clusters = len(set(cluster_labels))
clusters = pd.Series([coords[cluster_labels == n] for n in range(num_clusters)])

print('Number of clusters: {}'.format(num_clusters),cluster_labels)

#%%
def get_centermost_point(cluster):
    centroid = (MultiPoint(cluster).centroid.x, MultiPoint(cluster).centroid.y)
    centermost_point = min(cluster, key=lambda point: great_circle(point, centroid).m)
    return tuple(centermost_point)
centermost_points = clusters.apply(get_centermost_point)


#%%
lats, lons = zip(*centermost_points)
rep_points = pd.DataFrame({'lon':lons, 'lat':lats})

#%%

fig, ax = plt.subplots(figsize=[10, 6])

#rs_scatter = ax.scatter(rs['lon'], rs['lat'], c='#99cc99', edgecolor='None', alpha=0.7, s=120)

df_scatter = ax.scatter(rep_points['lat'], rep_points['lon'], c='k', alpha=0.9, s=30)
ax.set_title('geo-coded centroids')
ax.set_xlabel('Longitude')
ax.set_ylabel('Latitude')

ax.legend([df_scatter], ['Reduced set'], loc='upper right')
plt.show()

#SSE = DBSCAN.inertia_
#center_node = DBSCAN.cluster_centers_
#rounds = DBSCAN.n_iter_

#print(SSE,center_node,rounds)
#plt.scatter(center_node[:,0],center_node[:,1], s=50 )

#%%