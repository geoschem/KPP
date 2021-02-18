.. _use_kpp_to_create_fortran_90_source_code_for_geos_chem:

Use KPP to create Fortran-90 source code for GEOS-Chem
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

At this point you can now use KPP to generate Fortran-90 source code
files that will solve your chemical mechanism in an efficient manner.
Navigate to this folder in your GEOS-Chem source code:

-  GEOS-Chem 12.9.3 and prior versions: ``KPP``
-  GEOS-Chem 13.0.0 and later versions: ``src/GEOS-Chem/KPP``
-  GCHP 13.0.0 and later versions:
   ``src/GCHP_GridComp/GEOSChem_GridComp/geos-chem/KPP``

Here you will find two sub-folders: ``fullchem`` and
``custom``, and a script named ``build_mechanism.sh``.

The ``fullchem`` folder contains chemical mechanism specification
files (``fullchem.eqn`` and ``gckpp.kpp``) and Fortran-90
solver files for the default "out-of-the-box" GEOS-Chem chemical
mechanism. You should leave these files untouched. This will allow you
to revert to "out-of-the-box" "fullchem" mechanism if the need should
arise.

The ``custom`` folder contains sample chemical mechanism
specification files (``custom.eqn`` and ``gckpp.kpp``) which
have been copied from fullchem. You can edit these files to `define your
own custom mechanism (see subsequent sections for detailed
instructions) <#Specifying_a_custom_chemical_mechanism>`__.

Once you are satisfied with your custom mechanism specification you may
now use KPP to build the source code files for GEOS-Chem. Return to the
the KPP folder containing ``build_mechanism.sh`` and then type:

``./build_mechanism.sh custom``

You will see output similar to this:

| ``This is KPP-2.3.0_gc.``
| ``KPP is parsing the equation file.``
| ``KPP is computing Jacobian sparsity structure.``
| ``KPP is starting the code generation.``
| ``KPP is initializing the code generation.``
| ``KPP is generating the monitor data:``
| ``    - gckpp_Monitor``
| ``KPP is generating the utility data:``
| ``    - gckpp_Util``
| ``KPP is generating the global declarations:``
| ``    - gckpp_Main``
| ``KPP is generating the ODE function:``
| ``    - gckpp_Function``
| ``KPP is generating the ODE Jacobian:``
| ``    - gckpp_Jacobian``
| ``    - gckpp_JacobianSP``
| ``KPP is generating the linear algebra routines:``
| ``    - gckpp_LinearAlgebra``
| ``KPP is generating the utility functions:``
| ``    - gckpp_Util``
| ``KPP is generating the rate laws:``
| ``    - gckpp_Rates``
| ``KPP is generating the parameters:``
| ``    - gckpp_Parameters``
| ``KPP is generating the global data:``
| ``    - gckpp_Global``
| ``KPP is generating the driver from none.f90:``
| ``    - gckpp_Main``
| ``KPP is starting the code post-processing.``
| ``KPP has succesfully created the model "gckpp".``
| ``Reactivity consists of 172 reactions``
| ``Written to gckpp_Util.F90``

If this process is successful, the ``custom`` folder should now be
populated with several ``.F90`` source code files:

| ``CMakeLists.txt*      gckpp_Initialize.F90  gckpp_LinearAlgebra.F90  gckpp_Precision.F90``
| ``custom.eqn           gckpp_Integrator.F90  gckpp.map                gckpp_Rates.F90``
| ``gckpp_Function.F90   gckpp_Jacobian.F90    gckpp_Model.F90          gckpp_Util.F90``
| ``gckpp_Global.F90     gckpp_JacobianSP.F90  gckpp_Monitor.F90        Makefile_gckpp``
| ``gckpp_HetRates.F90@  gckpp.kpp             gckpp_Parameters.F90``

These files contain optimized instructions for solving the chemical
mechanism that you just defined.
