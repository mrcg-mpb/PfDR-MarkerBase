# =============================================================================
# Build a combined STAVE object from all curated study folders
#
# This function:
#   1. Finds all study folders inside studies/public/
#      (and optionally studies/private/)
#   2. Validates that each study contains the required files
#   3. Reads the study metadata and count data
#   4. Converts each study into STAVE-compatible format
#   5. Appends each study into one combined object
#
# The resulting object can then be used for downstream analyses,
# plotting, mapping, or export.
# =============================================================================

build_stave_object <- function(include_private = FALSE) {
  
  # ===========================================================================
  # Check required R packages are installed
  # ===========================================================================
  
  required_packages <- c(
    "STAVE",
    "yaml",
    "readr",
    "dplyr",
    "here"
  )
  
  missing_packages <- required_packages[!vapply(
    required_packages,
    requireNamespace,
    logical(1),
    quietly = TRUE
  )]
  
  if (length(missing_packages) > 0) {
    
    stop(
      "Missing required package(s): ",
      paste(missing_packages, collapse = ", "),
      call. = FALSE
    )
  }
  
  
  # ===========================================================================
  # Ensure the correct STAVE version is installed
  #
  # This protects against future API changes that could alter validation
  # behaviour or silently break compatibility.
  # ===========================================================================
  
  required_stave_version <- "2.0.2"
  
  installed_stave_version <- as.character(
    utils::packageVersion("STAVE")
  )
  
  if (utils::compareVersion(
    installed_stave_version,
    required_stave_version
  ) != 0) {
    
    stop(
      "PfDR-MarkerBase requires STAVE version ",
      required_stave_version,
      ", but version ",
      installed_stave_version,
      " is installed.\n",
      'Install the correct version with:\n',
      'remotes::install_github("mrc-ide/STAVE@v2.0.2")',
      call. = FALSE
    )
  }
  
  
  # ===========================================================================
  # Define which study directories should be searched
  #
  # By default only public studies are included.
  # Private studies can optionally be included for local analyses.
  # ===========================================================================
  
  study_roots <- here::here("studies", "public")
  
  if (isTRUE(include_private)) {
    
    study_roots <- c(
      study_roots,
      here::here("studies", "private")
    )
  }
  
  
  # ===========================================================================
  # Find all immediate subdirectories within the study roots
  #
  # Each subdirectory is assumed to correspond to a single study.
  # ===========================================================================
  
  study_dirs <- unlist(lapply(study_roots, function(x) {
    
    # skip missing directories
    if (!dir.exists(x)) {
      return(character())
    }
    
    list.dirs(
      path = x,
      full.names = TRUE,
      recursive = FALSE
    )
  }))
  
  
  # ===========================================================================
  # Stop early if no studies were found
  # ===========================================================================
  
  if (length(study_dirs) == 0) {
    
    stop(
      "No study folders found.",
      call. = FALSE
    )
  }
  
  
  # ===========================================================================
  # Initialise the combined STAVE object
  #
  # This object will grow as each study is appended.
  # Replace this placeholder with a true STAVE constructor later.
  # ===========================================================================
  
  stave_object <- STAVE::STAVE_object$new()
  
  
  # ===========================================================================
  # Loop over study folders
  # ===========================================================================
  
  for (study_dir in study_dirs) {
    
    # -------------------------------------------------------------------------
    # Identify study ID from folder name
    # -------------------------------------------------------------------------
    
    study_id <- basename(study_dir)
    
    message("Reading study: ", study_id)
    
    
    # -------------------------------------------------------------------------
    # Define required files for every study
    # -------------------------------------------------------------------------
    
    required_files <- file.path(
      study_dir,
      c(
        "study.yaml",
        "surveys.csv",
        "counts.csv",
        "README.md",
        "changelog.md"
      )
    )
    
    
    # -------------------------------------------------------------------------
    # Check all required files exist
    # -------------------------------------------------------------------------
    
    missing_files <- required_files[!file.exists(required_files)]
    
    if (length(missing_files) > 0) {
      
      stop(
        "Study folder '", study_id,
        "' is missing required file(s):\n",
        paste(" -", basename(missing_files), collapse = "\n"),
        call. = FALSE
      )
    }
    
    
    # -------------------------------------------------------------------------
    # Read study-level metadata
    # -------------------------------------------------------------------------
    
    study_metadata <- yaml::read_yaml(
      file.path(study_dir, "study.yaml")
    )
    
    # convert NULL to NA inside data.frame
    study_metadata[vapply(study_metadata, is.null, logical(1))] <- NA
    studies <- as.data.frame(study_metadata)
    
    # -------------------------------------------------------------------------
    # Read survey-level metadata
    # -------------------------------------------------------------------------
    
    surveys <- readr::read_csv(
      file.path(study_dir, "surveys.csv"),
      show_col_types = FALSE
    )
    
    # convert dates
    surveys$collection_start <- as.Date(surveys$collection_start)
    surveys$collection_end <- as.Date(surveys$collection_end)
    surveys$collection_day <- as.Date(surveys$collection_day)
    
    # -------------------------------------------------------------------------
    # Read aggregate marker count data
    # -------------------------------------------------------------------------
    
    counts <- readr::read_csv(
      file.path(study_dir, "counts.csv"),
      show_col_types = FALSE
    )
    
    # -------------------------------------------------------------------------
    # Convert study data into STAVE-compatible format
    
    stave_object$append_data(studies_dataframe = studies,
                             surveys_dataframe = surveys,
                             counts_dataframe = counts)
    
  }
  
  
  # ===========================================================================
  # Return final combined object
  # ===========================================================================
  
  stave_object
}