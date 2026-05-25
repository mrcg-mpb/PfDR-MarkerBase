# PfDR-MarkerBase

PfDR-MarkerBase is a curated database of *Plasmodium falciparum* drug resistance markers. It brings together results from many individual studies into a consistent, transparent format that makes it easier to compare findings across locations and time periods. Rather than focusing on raw sequencing data, the repository captures the kinds of aggregated results typically reported in the literature, while preserving enough detail to support downstream analyses like mapping. The aim is to provide a simple and reproducible way to organise, inspect, and reuse molecular surveillance data, forming a reliable foundation for studying patterns of antimalarial drug resistance.

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
      README.md
      changelog.md
  private/
    <study_id>/
      ...
```

Each folder represents a single curated study. The `public/` directory contains data that can be shared, while `private/` can be used locally for restricted datasets that should not be distributed. Anything inside the `private/` folder is ignored automatically by the `.gitignore`. Once a study is ready to be released, simply move it from the `private/` to `public/` folder and do a `git push`.

Within each study folder:

- `study.yaml` contains study-level metadata, including identifiers and references to the original data source
- `surveys.csv` describes where and when samples were collected
- `counts.csv` contains the genetic data in the form of aggregate counts
- `README.md` provides a human-readable account of how data for this study were extracted
- `changelog.md` tracks updates and corrections made to the data over time

---

## Exmple study-level README

The `README.md` file associated with each study provides a convenient space for describing the data extraction process for this specific study only. This should include some relevant background on the sequencing approach, key interpretation decisions in the data extraction, which loci were extracted and which have not yet been extracted.

You can have a look at an example README file [here](studies/public/PMID_40666313/README.md).

---

## Building the combined data object

The `R/` directory contains a simple helper script for combining all study folders into a single dataset. This script reads in each study, performs validation via the [STAVE](https://mrc-ide.github.io/STAVE/) framework, and returns a unified STAVE object that can be used for analysis. This process can either include or exclude the `private/` folder as you wish.

For example:

```
# import the helper functions
source("R/build_stave_object.R")

# build the STAVE object, excluding data in private folder
s_public <- build_stave_object(include_private = FALSE)
```

---

## Automated validation via GitHub Actions

The repository includes a GitHub Actions workflow that automatically validates all contributed studies whenever a pull request is opened or updated.

This workflow:

- reads all study folders inside `studies/public/`
- builds the combined STAVE object
- performs schema and consistency checks
- reports any validation errors directly within the pull request

Contributors therefore do not need to install R or run validation locally before submitting a pull request, although local validation remains possible for advanced users.

---

## How to contribute to this resource

We welcome contributions to help build this shared resource. The preferred way to contribute is through git and GitHub pull requests:

1. Clone the repository from the `main` branch.
2. Create a new local branch for your contribution.
3. Create one folder per study inside `studies/public/`. If you are working with data that is not yet ready for public release, you may instead use your local `studies/private/` folder. The `private/` directory is ignored by git and is intended for temporary local work only.
4. Populate your study folder with the 5 required files:
   - `study.yaml`
   - `surveys.csv`
   - `counts.csv`
   - `README.md`
   - `changelog.md`
   
   We recommend copying these files from an existing study folder to ensure the correct structure and formatting.
5. Push your branch to GitHub and open a pull request into `main`.
   All pull requests are automatically validated using the repository GitHub Actions workflow. This workflow builds the combined STAVE object and performs consistency checks across all contributed studies. If validation fails, the pull request page will display informative error messages describing what needs to be corrected.
6. Once the automated checks pass, the contribution will be reviewed by a member of the maintenance team before being merged.

---

## Licensing

All code in this repository is licensed under the MIT License.
See `LICENSE_code.md` for details.

The curated dataset is made available under the Creative Commons Attribution 4.0 International (CC BY 4.0). See `LICENSE_data.md` for details.

---

## Disclaimer

The data are provided “as is”, without warranty of any kind. See the license files for details.
