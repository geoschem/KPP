.. _installation:

Installation
~~~~~~~~~~~~

Download the KPP source code to your home directory with this command:

| ``git clone -b GC_updates https://github.com/geoschem/KPP.git``

This command will download the source code from the ``GC_updates``
branch of the KPP Github repository. These source code files have been
modified specifically for GEOS-Chem.

.. important:: Do not download the KPP source code into your GEOS-Chem
   source code directory! This will avoid confusion with the KPP folder
   that is already within GEOS-Chem, which contains Fortran files
   created by KPP that define the chemical mechanism.

The ``main`` branch of the KPP Github repository contains the
unmodified KPP version 2.2.3 source code files.  If you wish to use
KPP to generate chemical mechanisms for in a box model context , then
you will find it easier to use the code in the ``main`` branch than in
the ``GC_updates`` branch.
