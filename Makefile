.PHONY: clean

clean:
	rm -f derived_data/*.csv
	rm -f derived_data/*.bin
	rm -f figures/*.png

all: assets/class_props.png assets/category_options.png

figures/category_options.png figures/class_props.png derived_data/shrooms_ohe.csv:
	Rscript plot_edible_v_inedible_chars.R

assets/class_props.png: figures/class_props.png
	cp figures/class_props.png assets/class_props.png

assets/category_options.png: figures/category_options.png
	cp figures/category_options.png assets/category_options.png
