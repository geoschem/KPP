.. _tell_geos_chem_to_use_your_custom_mechanism:

Tell GEOS-Chem to use your custom mechanism
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

You must explicitly tell GEOS-Chem that it should use the custom
mechanism that you just built rather than the default "out-of-the-box"
fullchem mechanism. To do this, you must pass the
``-DCUSTOMMECH=y`` flag to CMake at configuration time.

For example, to build GEOS-Chem "Classic" with your custom mechanism,
navigate to your run directory, and type:

| ``cd build``
| ``cmake ../CodeDir -DCUSTOMMECH=y``

You should see output such as this written to the screen:

| ``  ... etc before ...``
| ``-- General settings:``
| ``  * CUSTOMMECH:   <span style="color:darkgreen">``\ **``ON``**\ ``</span>  OFF``
| ``  ... etc after ...``

This lets you know that GEOS-Chem will use the custom mechanism instead
of the "out-of-the-box" fullchem mechanism. Once GEOS-Chem has been
configured properly, you may proceed to build the GEOS_Chem executable:

| ``make -j``
| ``make -j install``

and this will build the ``gcclassic`` executable in the run
directory.

The process is the same when building GCHP, make sure to pass
``-DCUSTOMMECH=y`` at configuration time.
