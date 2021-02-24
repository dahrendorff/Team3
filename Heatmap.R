#load the library with the aheatmap () function
library (NMF)

# aheatmap needs a matrix of values , e.g., a matrix of DE genes with the transformed read counts for each replicate
# sort the results according to the adjusted p- value
DGE.results.sorted <- DGE.results [order(DGE.results$padj),]

# identify genes with the desired adjusted p- value cut -off
DGEgenes <- rownames (subset(DGE.results.sorted, padj<0.05) )

# extract the normalized read counts for DE genes into a matrix
hm.mat_DGEgenes <- log.norm.counts[DGEgenes, ]

# plot the normalized read counts of DE genes sorted by the adjusted p- value
aheatmap (hm.mat_DGEgenes, Rowv=NA , Colv=NA)

# combine the heatmap with hierarchical clustering
aheatmap(hm.mat_DGEgenes,
               Rowv=TRUE,Colv=TRUE, # add dendrograms to rows and columns
               distfun="euclidean", hclustfun="average")
# scale the read counts per gene to emphasize the sample -type - specific differences
aheatmap (hm.mat_DGEgenes,
               Rowv=TRUE, Colv=TRUE,
               distfun="euclidean", hclustfun="average",
               scale="row") # values are transformed into distances from the center of the row - specific average : ( actual value - mean of the group ) /
  #standard deviation