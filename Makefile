.PHONY: clean

clean:
	rm -f derived_data/*
	rm -f figures/*.png
	rm *Rplots*

nuke:
	rm -f derived_data/*
	rm -f figures/*.png
	rm -f assets/*
	rm *Rplots*

all: assets/category_options.png\
		assets/conf_mat_odor.png\
		assets/conf_mat_no_odor.png\
		assets/all_samps_mca_class.png\
		assets/all_samps_kmeans.png\
		assets/poisonous_mca_scree.png\
		assets/poisonous_mca_inds.png\
		assets/poisonous_kmeans_3clust.png\
		assets/edible_mca_scree.png\
		assets/edible_mca_inds.png\
		Mushroom_analysis.pdf

# Category analysis and decision tree 
figures/category_options.png:
	Rscript plot_edible_v_inedible_chars.R

assets/category_options.png: figures/category_options.png
	#convert -resize 512x512 figures/category_options.png figures/category_options.png
	cp figures/category_options.png assets/category_options.png
	

#Decision tree plots
figures/odor_importance_tree.png \
	figures/no_odor_importance_tree.png \
	figures/conf_mat_odor.png \
	figures/conf_mat_no_odor.png:
		Rscript basic_associations.r
		
#Something wrong with these in the R Script, cannot for the life of me figure it out
#assets/odor_importance_tree.png: figures/odor_importance_tree.png
	#convert -resize 512x512 figures/odor_importance_tree.png figures/odor_importance_tree.png
	#cp figures/odor_importance_tree.png assets/odor_importance_tree.png

#assets/no_odor_importance_tree.png: figures/no_odor_importance_tree.png 
	#convert -resize 512x512 figures/no_odor_importance_tree.png figures/no_odor_importance_tree.png
	#cp figures/no_odor_importance_tree.png assets/no_odor_importance_tree.png
	
assets/conf_mat_odor.png: figures/conf_mat_odor.png 
	#convert -resize 256x256 figures/conf_mat_odor.png figures/conf_mat_odor.png
	cp figures/conf_mat_odor.png assets/conf_mat_odor.png 

assets/conf_mat_no_odor.png: figures/conf_mat_no_odor.png
	#convert -resize 256x256 figures/conf_mat_no_odor.png figures/conf_mat_no_odor.png
	cp figures/conf_mat_no_odor.png assets/conf_mat_no_odor.png

# MCA and Kmeans analysis
#Is there a better way to define this large of a target?
figures/all_samps_mca_class.png \
	figures/all_samps_kmeans.png \
	figures/poisonous_mca_scree.png \
	figures/all_samps_mca_cos2.png \
	figures/poisonous_mca_inds.png \
	figures/poisonous_kmeans_3clust.png \
	figures/edible_kmeans.png \
	figures/edible_mca_scree.png \
	figures/edible_mca_inds.png:
		Rscript mca_kmeans.r

assets/all_samps_mca_scree.png: figures/all_samps_mca_scree.png
	cp figures/all_samps_mca_scree.png assets/all_samps_mca_scree.png

assets/all_samps_mca_class.png: figures/all_samps_mca_class.png
	cp figures/all_samps_mca_class.png assets/all_samps_mca_class.png

assets/all_samps_mca_cos2.png: figures/all_samps_mca_cos2.png
	cp figures/all_samps_mca_cos2.png assets/all_samps_mca_cos2.png

assets/all_samps_kmeans.png: figures/all_samps_kmeans.png
	cp figures/all_samps_kmeans.png assets/all_samps_kmeans.png

assets/poisonous_mca_scree.png: figures/poisonous_mca_scree.png
	cp figures/poisonous_mca_scree.png assets/poisonous_mca_scree.png
	
assets/poisonous_mca_inds.png: figures/poisonous_mca_inds.png
	cp figures/poisonous_mca_inds.png assets/poisonous_mca_inds.png	

assets/poisonous_kmeans_3clust.png: figures/poisonous_kmeans_3clust.png
	cp figures/poisonous_kmeans_3clust.png assets/poisonous_kmeans_3clust.png	

assets/edible_mca_scree.png: figures/edible_mca_scree.png
	cp figures/edible_mca_scree.png assets/edible_mca_scree.png	

assets/edible_mca_inds.png: figures/edible_mca_inds.png
	cp figures/edible_mca_inds.png assets/edible_mca_inds.png	

assets/edible_kmeans.png: figures/edible_kmeans.png
	cp figures/edible_kmeans.png assets/edible_kmeans.png	

Mushroom_analysis.pdf: assets/class_props.png \
						assets/category_options.png \
						assets/conf_mat_odor.png \
						assets/conf_mat_no_odor.png \
						assets/all_samps_mca_scree.png \
						assets/all_samps_kmeans.png \
						assets/all_samps_mca_cos2.png \
						assets/poisonous_mca_scree.png \
						assets/poisonous_mca_scree.png \
						assets/poisonous_mca_inds.png \
						assets/poisonous_kmeans_3clust.png \
						assets/edible_mca_scree.png \
						assets/edible_mca_inds.png \
						assets/edible_kmeans.png 
	Rscript rend_pdf.r