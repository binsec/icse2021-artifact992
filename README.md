# A Replication of Automatic Inline Assembly Interface Compliance Check and Patch

This is a companion repository made available to support experimental claims of the paper [Interface Compliance of Inline Assembly: Automatically Check, Patch and Refine](https://conf.researchr.org/details/icse-2021/icse-2021-papers/82/Interface-Compliance-of-Inline-Assembly-Automatically-Check-Patch-and-Refine) ([preprint](icse2021-paper992.pdf)).

This contains *software*, *data* and *scripts* in order to **Replicate** the experimental evaluation of the prototype ***RUSTInA***.
The given material outputs the figures summed up in **Table I** and **Table IV** (**Appendix C**).

*Make sure to check [installation instructions](INSTALL.md) before starting.*

# Artifact evaluation

Assuming you are at the root directory of this repository, you can run the following to automatically replay the benchmark:
```shell
make all
```
*It could take some times between each output (2-10 minutes depending on hardware capabilities).*

It will sequentially call ***RUSTInA*** on:
1. the example from **II. CONTEXT AND MOTIVATION**;
2. the *3107* `x86_32` inline assembly chunks with precision enhancers enabled;
3. the *3107* `x86_32` inline assembly chunks again but without precision enhancers.

Logs are computed only once and subsequent calls will only show verbose outputs. Use the following to restart from scratch:
```shell
make clean
```

#### 1. Motivating example

The following command will only replay the [motivating example](examples/motivating.i) discussed in **Section II**:
```shell
make motivating
```
It will describe the found issues and applied patches. The expected verbose output is:
```shell
[rustina] File ./examples/motivating.i, Line 19 in function AO_compare_double_and_swap_double_full:
  Original chunk:
```
```c
    __asm__ volatile (
      "xchg %%ebx,%6;"
      "lock;"
      "cmpxchg8b %0;"
      "setz %1;"
      "xchg %%ebx,%6;"
      : "=m" (*addr), "=a" (result)
      : "m" (*addr), "d" (old_val2), "a" (old_val1), "c" (new_val2),
        "D" (new_val1)
      : "memory"
      );
```
```shell
  Patched issues:
    implicit %0 = %2
    flag ZF clobbered
    read-only %3 clobbered
    ebx may_impact %0
  Patched chunk:
```
```c
    AO_t dummy0;
    __asm__ volatile (
      "xchg %%ebx,%7;"
      "lock;"
      "cmpxchg8b %0;"
      "setz %1;"
      "xchg %%ebx,%7;"
      : "=m" (*addr), "=a" (result), "=d" (dummy0)
      : "0" (*addr), "2" (old_val2), "a" (old_val1), "c" (new_val2),
        "D" (new_val1)
      : "ebx", "memory", "cc"
      );
```

#### 2. Table I

The **Table I** sums up general statistics at *package*, *chunk* and *issue* levels.
The following command will only replay the benchmark with the precision enhancers enabled:
```shell
make table1
```
The expected verbose output is:
```shell
Package considered 202
Packages                Initial         Patched
--------------------  ---------  ---  ---------  ---
- fully compliant           117  58%        178  88%
- only benign issues         31  15%          0  0%
- serious issues             54  27%         24  12%

Assembly chunks 3107
Relevant chunks 2656
Chunks                  Initial         Patched
--------------------  ---------  ---  ---------  ---
- fully compliant          1292  49%       2568  97%
- only benign issues       1070  40%          0  0%
- serious issues            294  11%         88  3%

                             Initial          Patched
-------------------------  ---------  ----  ---------  ----
Found issues                    2183  100%        183  100%
> signigicant issues             986  45%         183  100%

frame-write                     1718  79%           0  0%
- flag register clobbered       1197  55%           0  0%
- read-only clobbered             17  1%            0  0%
- register clobbered             436  20%           0  0%
- unbound memory access           68  3%            0  0%

frame-read                       379  17%         183  100%
- non initialized output          19  1%            0  0%
- unbound register read          183  8%          183  100%
- unbound memory access          177  8%            0  0%

unicity                           86  4%            0  0%
```

#### 3. Table IV

The **Table IV** (**Appendix C**) compares the performance of ***RUSTInA*** with and without the precision enhancers.
The following command will replay the benchmark twice, once with the precision enhancers enabled and once without:
```shell
make table4
```
The expected verbose output is:
```shell
Compliance issues      RUSTInA    Basic  rate
-------------------  ---------  -------  ------
Total                     2183     +127  +6%
> significant              986     +127  +13%

frame-read                 379      +87  +23%
> significant              379      +87  +23%

frame-write               1718      +40  +2%
> significant              521      +40  +8%

unicity                     86       +0  +0%
> significant               86       +0  +0%
```
# Origin of the samples

The data-set is exactly the one used in the paper. The snippets of assembly code come from the sources of **Debian** *Jessie* (8.11) packages. We ran a long session of package installations during which each call to a C compiler was intercepted. All C preprocessed sources were scanned for assembly chunks and relevant ones were saved. Files were merged by project and then sliced to keep only functions containing assembly chunks and their syntactic dependencies. Yet, location information allows to link them back to the place they were extracted.
All credits belongs to their original authors.



# Getting Started with RUSTInA

While still being in development, we hope this released snapshot of our prototype is simple, documented and robust enough to have some uses for people dealing with inline assembly.

***RUSTInA*** is supplied as a self-contained command line tool ([AppImage](bin/rustina-x86_64.AppImage)).
It takes in input a list of C preprocessed file `.i` (*i.e.* where **macro**s are resolved).
Depending on the given options, ***RUSTInA*** will:
1. **Print** important information about the compliance of the chunks in a human readable fashion (`-v | --verbose`);
2. **Log** individual issue information in a CSV format (`-b | --batch <filepath>`).

By default, ***RUSTInA*** assumes the assembly chunks are using `x86_32` instruction set.
The options `-a | --armv7` allow to switch to the `ARMv7` instruction set.

Finally, the options `-x | --basic` disable the precision enhancers, possibly leading to more false alarms.

**Note.** Due to an internal behavior of *AppImage*, the file paths fed to ***RUSTInA*** must be absolute paths. An absolute path can easily be derived from the relative one by prepending it `$(pwd)/`.

**Disclaimer.** ***RUSTInA*** does not check that the assembly chunk is well formed. It is, in general, you responsibility to feed only preprocessed file that compile.

We are then able to check that the [**Libyuv** chunk](supplements/libyuv.i) is compliant in its `ARM` version.
You can run the following command to **Print** (`-v`) the information about its compliance. The option `-a` is used to switch to `ARM` instruction set.
```shell
bin/rustina-x86_64.AppImage -a -v $(pwd)/supplements/libyuv.i
```
We can make further experiments by testing the compliance of [**FFMPEG** chunks](supplements/ffmpeg.i) for `ARM`.
There are too many chunks to inspect them manually so we will **Log** them in a file `mylog` with the option `--batch`:
```shell
bin/rustina-x86_64.AppImage -a --batch $(pwd)/mylog $(pwd)/supplements/ffmpeg.i
```
We can use the [python script](scripts/table1.py) to digest the entries in `mylog` and print a more verbose output:
```shell
scripts/table1.py mylog
```

Finaly, if we want to evaluate the impact of precision enhancers, we need a second run without them (`-x`):
```shell
bin/rustina-x86_64.AppImage -ax --batch $(pwd)/mylogx $(pwd)/supplements/ffmpeg.i
```
Then we use the [python script](scripts/table4.py) to compute a summary. The first argument is the log without enhancers followed by the one with enhancer.
```shell
scripts/table4.py mylogx mylog
```
Yet, there is no difference here because `ARM` architecture is substantially simpler than `x86_32` one.

#### To be continued..

[Here](examples/oldlibc.md) is a small tutorial to see how we can manually extract an interesting chunk from a very old version of **libc** sources and find a latent `segmentation fault`.
The extraction of the preprocessed C files is out of the scope of this artifact. If you want to apply ***RUSTInA*** on your own project, you are in the best position to known how to compile your code. Still, you must know that compilers generally output the preprocessed files with the option `-E`.

# Troubleshooting

If you experiment any issue running ***RUSTInA***, do not hesitate to open an issue in this repository or send a email to the authors of the paper.

License
----

This artifact is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License.
It is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the [GNU General Public License](LICENSE) for more details.