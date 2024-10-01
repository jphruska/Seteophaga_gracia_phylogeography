# Effective migration surface (Figure 1B)

1. Use dataset15a VCF file as input (includes Belize individuals, excludes Z chromosome, 10kb thinned). 45 individuals, 49,326 SNPs. 
2. Open jupyter notebook from command line using 'jupyter notebook setophaga_feems.ipynb'.
3. With this script, read in plink .bim and .fam files from the dataset15a VCF file. These were generated using plink.
4. Read in the setophaga.coord and setophaga.outer files. These delineate the outer boundary over which the surface will be calculated (setophaga.outer), and the coordinates of the individuals (the order they appear matches the order in which they appear in the VCF). The outer file was generated using the Google Maps API tool (www.birdtheme.org/useful/v3tool.html).
5. Also, we must specify the grid, and here we used the grid_100.shp file provided by the feems authors (https://github.com/NovembreLab/feems/tree/main/feems/data). The grid_100.shp file has cells with approximate areas of 6,200 sq km and a spacing of 110 km between cells, with the cell spacing denoting the distance between the mid-points of adjacent cells. This shape file was generated with dgconstruct from the ddgridR package (https://github.com/NovembreLab/feems/issues/21). grid_250.shp files are also provided, but we did fit our model with this grid. 
6. Fit the model with a lamba value that minimizes the cross validation error (0.0599484). 
