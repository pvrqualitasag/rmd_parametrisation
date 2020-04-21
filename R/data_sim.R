#' ---
#' title: "Create Random Data"
#' date:  "2020-04-21"
#' #' ---
#' 
#' # Disclaimer
#' The generated data is read by a parametrized Rmd-document. 
#' 
#' 
#' # Generate Data
#' The data contains an sequential id, a fixed effect of yearseason and a 
#' random normal deviate.
#+ generate-data
set.seed(3663)
n_nr_yr_levels <- 4
n_nr_obs_per_level <- 5
n_nr_records <- n_nr_yr_levels * n_nr_obs_per_level
tbl_yr_data <- tibble::tibble(rec_id = c(1:n_nr_records),
                              year_season = c(rep(1:n_nr_yr_levels, n_nr_obs_per_level)),
                              trait_value = rnorm(n = n_nr_records))

# check whether output file is defined by calling script
if (!exists("s_data_path")) stop(" * ERROR: variable s_data_path must be defined.")
# check whether output directory exists
s_data_dir <- dirname(s_data_path)
if (!dir.exists(s_data_dir)) dir.create(path = s_data_dir)

# write output
readr::write_csv(tbl_yr_data, path = s_data_path)
