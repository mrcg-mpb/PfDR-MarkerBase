# PfDR-MarkerBase

PfDR-MarkerBase is a curated database of *Plasmodium falciparum* drug resistance markers extracted from published molecular surveillance studies. It brings together results from many individual studies into a consistent, transparent format that makes it easier to compare findings across locations and time periods. Rather than focusing on raw sequencing data, the repository captures the kinds of aggregated results typically reported in the literature, while preserving enough detail to support robust downstream analyses. The aim is to provide a simple and reproducible way to organise, inspect, and reuse molecular surveillance data, forming a reliable foundation for studying patterns of antimalarial drug resistance.

---

## Repository structure

Data are organised as a collection of individual study folders:

```
studies/
  public/
    <study_id>/
      study.yaml
      surveys.csv
      counts.csv
      coded_markers.csv
      coverage_notes.csv
      README.md
      changelog.md
  private/
    <study_id>/
      ...
```

Each folder represents a single curated study. The public/ directory contains data that can be shared, while private/ can be used locally for restricted datasets that should not be distributed.

Within each study folder:

- study.yaml contains study-level metadata, including identifiers and references to the original data source
- surveys.csv describes where and when samples were collected
- counts.csv contains the aggregated genetic data, linking variant strings to the number of samples in which they were observed
- coded_markers.csv records which genetic markers have been extracted for that study
- coverage_notes.csv provides notes on sequencing coverage to support future data extension
- README.md gives a human-readable summary of how the data were extracted and any important interpretation decisions
- changelog.md tracks updates and corrections made to the study over time

---

## Building the dataset

The `R/` directory contains a simple helper script for combining all study folders into a single dataset. This script reads each study, performs validation via the STAVE framework, and returns a unified STAVE object that can be used for analysis.

For example:

```
source("R/build_stave_object.R")

s_public <- build_stave_object(include_private = FALSE)
```

This allows the full dataset to be rebuilt at any time directly from the underlying study folders, ensuring transparency and reproducibility.

---

## Licensing

### Code

All code in this repository is licensed under the MIT License.
See LICENSE_code.md for details.

### Data

The curated dataset is made available under the Creative Commons Attribution 4.0 International (CC BY 4.0). See LICENSE_data.md for details.

---

## Disclaimer

The data are provided “as is”, without warranty of any kind. See the license files for details.
