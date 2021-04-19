
library(tidyverse)
library(readr)
library(readxl)

# Make an object to help navigate the subdirectories.
my_wd_path <- "/Users/cjcampbell/Pd_DetectionMigratoryBats"
mwd <- list()
mwd$R          <- file.path( my_wd_path, "R"    )
mwd$data       <- file.path( my_wd_path, "data" )
mwd$figs       <- file.path( my_wd_path, "figs" )