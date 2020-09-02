# RUSTInA

This is a companion repository made available to replay x86 experiments of the ICSE 2O21 submission.

# Installation

### From this repository

Just download this repository and *unpack* it in your working directory. Alternatively:
```sh
git clone https://github.com/rustina-devs/eval.git
```

This AppImage requires a `x86_64` **Linux** environment with **glibc** >= 2.27 (tested on **Ubuntu** 18.04).
It is practically self-contained and does not require additional installation.

Surrounding scripts require:
- **make**;
- **python2** with **pandas**.

Both **make** and **python2** should be already available in your environment. If not:
```sh
sudo apt-get install make python
```
To install **pandas** *data-processing* librairy, use:
```sh
sudo apt-get install python-pandas
```

### Using the virtual box

Users running **Windows** or which does not meet the primary requirements can download the virtual box in the [release panel](https://github.com/rustina-devs/eval/releases/download/v0.1/rustina-devs.ova).

It runs a preconfigured **Ubuntu** 18.04 server. Starting the virtual machine directly logs in a terminal. Then go to the working directory:
```sh
cd eval
```

# Usage

**make** has 2 predefined targets:
```sh
make example
```
- replay the `AO_compare_double_and_swap_double_full` motivating example;
```sh
make overview
```
- replay and summarize x86 debian experiments.

###### **make** can work faster on multi-core machine by processing files in parallel: add the `-j` flag to the command (do not use it in a virtual box).
First run takes longer since it process all the sample files to produce data logs. Later calls will directly output the summary. Use `clean` to restart from scratch.
```sh
make clean
```

# Note about samples

Assembly chunks are extracted from the source of **debian** 8.11 packages.
Throughout an automatic installation of all packages, each call to a C compiler was intercepted and the resulted preprocessed file was saved.
To keep the dataset small, functions and variables not related to an assembly chunks have been filtered out.
The resulting functions, types and variables have then been packed together by projects.

We have totally rewritten and made simpler the python script in order to directly output the digest figures and correct a few misclassification errors. While some figures are now sligthly different, it does not change the main conclusions of the experiments.

# Limitations

This version is self-contained. However, it misses some of the optional **frama-c** and **binsec** dependencies.
In particular:
- it is not able to automatically preprocess the C files -- it only accepts preprocessed ones `*.i`;
- the external (not released) `ARM` **binsec** decoder is not included.

License
----

*"All the material within this repository is intended for the need of ICSE 2021 evaluation. All other usages are prohibited."*
