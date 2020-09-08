.PHONY: clean

clean:
	rm -f derived_data/*.bin
	rm -f figures/*.png

all: assets/class_props.png assets/category_options.png\
	assets/odor_importance_tree.png assets/no_odor_importance_tree.png\
	assets/conf_mat_odor.png assets/conf_mat_no_odor.png


figures/category_options.png figures/class_props.png derived_data/shrooms_ohe.csv:
	Rscript plot_edible_v_inedible_chars.R

figures/odor_importance_tree.png figures/no_odor_importance_tree.png figures/conf_mat_odor.png figures/conf_mat_no_odor.png:
	Rscript basic_associations.r

assets/class_props.png: figures/class_props.png
	cp figures/class_props.png assets/class_props.png

assets/category_options.png: figures/category_options.png
	cp figures/category_options.png assets/category_options.png
	
#assets/odor_importance_tree.png: figures/odor_importance_tree.png
#	cp figures/odor_importance_tree.png assets/odor_importance_tree.png

#assets/no_odor_importance_tree.png: figures/no_odor_importance_tree.png 
#	cp figures/no_odor_importance_tree.png assets/no_odor_importance_tree.png
	
assets/conf_mat_odor.png: figures/conf_mat_odor.png 
	cp figures/conf_mat_odor.png assets/conf_mat_odor.png 

assets/conf_mat_no_odor.png: figures/conf_mat_no_odor.png
	cp figures/conf_mat_no_odor.png assets/conf_mat_no_odor.png
