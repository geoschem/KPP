[![License](https://img.shields.io/badge/License-MIT-blue.svg)](https://github.com/geoschem/KPP/blob/GC_updates/LICENSE.txt) [![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4537861.svg)](https://doi.org/10.5281/zenodo.4537861)

# README for the "GC_updates" branch of KPP

This branch tracks modifications to KPP that are specific to GEOS-Chem.  If you will be using KPP to create custom chemistry mechanisms for GEOS-Chem, then you will need to download the KPP source code from **GC_updates** instead of the **main** branch. 

## Installation

Download KPP to your home directory with this command:
```
git clone -b GC_updates https://github.com/geoschem/KPP.git
```
 * The `-b GC_updates` will check out the **GC_updates** branch instead of the **main** branch.
 * **IMPORTANT!** Do not download the KPP source code into your GEOS-Chem source code directory. This will avoid confusion with the KPP folder that is already within GEOS-Chem, which contains Fortran files created by KPP that define the chemical mechanism.

## Compilation

Make sure that your computer system has a C compiler.  Depending on your setup, you might have to load a module (e.g. with `module load` or `spack load`, etc.).  Ask your sysadmin for more information.

Once you have downloaded KPP and have made sure that a C compiler exists on your system, you may use these commands to build the KPP executable file:
```
cd KPP/kpp-code
make distclean
make all
```
If the build completes successfully, you will see an executable file named `kpp` in the `KPP/kpp-code/bin/` folder.

## Defining environment variables

Once have built KPP, you must add the path to the KPP executable file to your `PATH` environment variable.  

### Settings for bash

If you use the bash Unix shell, add these lines to your `~/.bash_aliases` file. 
```
export PATH=$PATH:/PATH_TO_KPP/KPP/kpp-code/bin/
export KPP_HOME=PATH_TO_KPP/KPP/kpp-code
```
  * If you don't have a `~/.bash_aliases` file, you can add these lines to your `~/.bashrc` file instead. 

### Settings for csh or tcsh

If you use the csh or tcsh Unix shell, add these lines to your `~/.cshrc` file:
```
setenv PATH $PATH:/PATH_TO_KPP/KPP/kpp-code/bin/
setenv KPP_HOME=PATH_TO_KPP/KPP/kpp-code
```
  * In the above examples, the `PATH_TO_KPP` is the path to the main `KPP` folder. 
  * For example, if you installed KPP into your home directory, then `PATH_TO_KPP` would be `~/KPP`, etc.

## Documentation

* [Our FlexGrid page on the GEOS-Chem Wiki](http://wiki.geos-chem/org/FlexChem) contains detailed information about creating custom chemistry mechanisms with KPP.
* [The KPP User Manual](https://github.com/geoschem/KPP/blob/GC_updates/kpp-code/doc/kpp_UserManual.pdf) contains general information about using KPP.

## Support

If you encounter bugs or issues while using KPP for GEOS-Chem, please post a new issue on the [issue tracker attached to this repository](https://github.com/geoschem/KPP/issues/new).
