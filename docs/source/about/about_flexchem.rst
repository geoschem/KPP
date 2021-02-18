.. about_flexchem::

About FlexChem
~~~~~~~~~~~~~~
   
FlexChem is '''`a clean implementation of
the Kinetic Pre Processor (KPP)''' <https://github.com/geoschem/kpp/tree/GC_updates>`__ that has
been customized for GEOS-Chem v11-01 and later versions. You can use
FlexChem to modify existing GEOS-Chem mechanisms or create new
GEOS-Chem chemistry mechanisms.

Within
FlexChem, there is a single supported chemical mechanism (named
`fullchem <https://github.com/geoschem/geos-chem/blob/main/KPP/fullchem/fullchem.eqn>`__),
but users may also define their own custom mechanisms.

The GEOS-Chem routine ``flexchem_mod.F90`` serves as the connection
between the chemical mechanism solver files generated KPP and
the species concentration array in GEOS-Chem.  In
``flexchem_mod.F90``, species concentrtations, photoylsis rates,
meteorology fields, and other relevant information are passed to the
KPP-generated solver routines.  The KPP-generated solver routines
compute reaction rates, perform the forward integration, and pass the
updated species concentration back to GEOS-Chem.

The main benefits of FlexChem are:

#. FlexChem allows for better documentation of chemical mechanisms;
#. FlexChem makes it easier to switch chemical mechanisms;
#. Flexchem uses optimized chemistry computations; and
#. FlexChem allowed us to remove the old SMVGEAR solver (used prior to GEOS-Chem v11-01).
