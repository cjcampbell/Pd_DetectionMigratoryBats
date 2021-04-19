
# Load qPCR results.
results_files <- list.files(mwd$data, pattern = "xls$", full.names = TRUE)

writeLines(c("About to load qPCR data:", results_files))

suppressWarnings({ suppressMessages({
  myresults <- lapply(results_files, function(file){
    data_main <- readxl::read_excel(file, range = "A8:AB104", sheet = 2)
    
    data_header <- readxl::read_excel(file, range = "A1:B6", col_names = FALSE, sheet = 2) %>% 
      t() %>% as.data.frame(stringsAsFactors = FALSE)
    colnames(data_header) <- data_header[1,]
    data_header <- data_header[-1,]
    
    data_footer <- readxl::read_excel(file, range = "A106:B109", col_names = FALSE, sheet = 2) %>% 
      t() %>% as.data.frame(stringsAsFactors = FALSE)
    colnames(data_footer) <- data_footer[1,]
    data_footer <- data_footer[-1,]
    
    return( purrr::reduce(list(data_main, data_header, data_footer), cbind) )
  }) %>% 
    plyr::ldply() %>% 
    mutate( sample_type = case_when(
      grepl( "dilution", `Sample Name`) ~ "dilution",
      grepl("Pd_PC",  `Sample Name`)    ~ "control_pos",
      grepl("NC",  `Sample Name`)       ~ "control_neg",
      TRUE ~ "sample"
      ) )
  }) 
})

# Load metadata, combine.
key <- readr::read_csv(file.path(mwd$data,"sample_name_key_complete.csv") )
metadata <- readr::read_csv(file.path(mwd$data,"metadata.csv") )

mdf <- purrr::reduce(list(myresults, key, metadata), left_join) %>% 
  # Some data cleaning.
  dplyr::mutate(
    Spp = toupper(Spp),
    Source_St = toupper(Source_St)
  )
