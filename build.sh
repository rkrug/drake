module load pandoc
Rscript -e "bookdown::render_book('index.Rmd', 'bookdown::gitbook')"
