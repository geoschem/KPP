################
Adding Reactions
################

-------------------
Gas-phase reactions
-------------------

List gas-phase reactions first in the ``#EQUATIONS`` section of
``custom.eqn``.

.. code-block:: console

  #EQUATIONS
  //
  // Gas-phase reactions
  //
  ...skipping over the comment header...
  //
  O3 + NO = NO2 + O2 :                         GCARR(3.00E-12, 0.0, -1500.0);
  O3 + OH = HO2 + O2 :                         GCARR(1.70E-12, 0.0, -940.0);
  O3 + HO2 = OH + O2 + O2 :                    GCARR(1.00E-14, 0.0, -490.0);
  O3 + NO2 = O2 + NO3 :                        GCARR(1.20E-13, 0.0, -2450.0);
  ... etc ...

^^^^^^^^^^^^
General form
^^^^^^^^^^^^

No matter what reaction is being added, the general procedure is the
same. A new line must be added to ``custom.eqn`` of the following
form:

.. code-block:: console

  A + B = C + 2.000D : RATE_LAW_FUNCTION(ARG_A, ARG_B ...);

The denotes the reactants (A and B) as well as the products (C and D) of
the reaction. If exactly one molecule is consumed or produced, then the
factor can be omitted; otherwise the number of molecules consumed or
produced should be specified with at least 1 decimal place of accuracy.
The final section, between the colon and semi-colon, specifies the
function ``RATE_LAW_FUNCTION`` and its arguments which will be
used to calculate the reaction rate constant k. Rate-law functions are
specified in the gckpp.kpp file.

For an equation such as the one above, the overall rate at which the
reaction will proceed is determined by ``k[A][B]``. However, if the
reaction rate does not depend on the concentration of A or B, you may
write it with a constant value, such as:

.. code-block:: console

  A + B = C + 2.000D : 8.95d-17

This will save the overhead of a function call.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Rates for two-body reactions according to the Arrhenius law
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For many reactions, the calculation of k follows the Arrhenius law:

.. code-block:: console

  k = a0 + ( 300 / TEMP )**b0 + EXP( c0 / TEMP )

For example, the JPL chemical data evaluation (Feb 2017) specifies that
the reaction O3 + NO produces NO2 and O2, and its Arrhenius parameters
are A = 3.0x10^-12 and E/R = c0 = 1500.

To specify a two-body reaction whose rate follows the Arrhenius law, you
can use the ``GCARR`` rate-law function, which is defined in
``gckpp.kpp``. For example, the entry for the ``O3 + NO = NO2 +
O2`` reaction can be written as in ``custom.eqn`` as:

.. code-block:: console

  O3 + NO = NO2 + O2 : GCARR(3.00E12, 0.0, -1500.0);

^^^^^^^^^^^^^^^^^^^^^^^^
Other rate-law functions
^^^^^^^^^^^^^^^^^^^^^^^^

The ``gckpp.kpp`` file contains other rate law functions, such as
those required for three-body, pressure-dependent reactions. Any rate
function which is to be referenced in the ``custom.eqn``
file must be available in ``gckpp.kpp`` prior to building the
reaction mechanism.

-----------------------
Heterogeneous reactions
-----------------------

List heterogeneous reactions after all of the gas-phase reactions in
``custom.eqn``, according to the format below:

.. code-block:: console

  //
  // Heterogeneous reactions
  //
  HO2 = O2 :                                   HET(ind_HO2,1);                      {2013/03/22; Paulot2009; FP,EAM,JMAO,MJE}
  NO2 = 0.500HNO3 + 0.500HNO2 :                HET(ind_NO2,1);
  NO3 = HNO3 :                                 HET(ind_NO3,1);
  NO3 = NIT :                                  HET(ind_NO3,2);                      {2018/03/16; XW}
  ... etc ...

Implementing new heterogeneous chemistry requires an additional step.
For the reaction in question, a reaction should be added as usual, but
this time the rate function should be given as an entry in the
``HET`` array. A simple example is uptake of HO2, specified as

.. code-block:: console

  HO2 = O2 : HET(ind_HO2,1);

Note that the product in this case, O2, is actually a fixed species, so
no O2 will actually be produced. O2 is used in this case only as a dummy
product to satisfy the KPP requirement that all reactions have at least
one product. Here, ``HET`` is simply an array of pre-calculated
rate constants. The rate constants in ``HET`` are actually
calculated in ``gckpp_HetRates.F90``.

To implement an additional heterogeneous reaction, the rate calculation
must be added to this file. The following example illustrates a
(fictional) heterogeneous mechanism which converts the species XYZ into
CH2O. This reaction is assumed to take place on the surface of all
aerosols, but not cloud droplets (this requires additional steps not
shown here). Three steps would be required:

#. Add a new line to the ``custom.eqn`` file, such as ``XYZ = CH2O : HET(ind_XYZ,1);``
#. Add a new function to ``gckpp_HetRates.F90`` designed to
   calculate the heterogeneous reaction rate. As a simple example, we
   can copy the function ``HETNO3`` and rename it ``HETXYZ``.
   This function accepts two arguments: molecular mass of the impinging
   gas-phase species, in this case XYZ, and the reaction's "sticking
   coefficient" - the probability that an incoming molecule will stick
   to the surface and undergo the reaction in question. In the case of
   ``HETNO3``, it is assumed that all aerosols will have the same
   sticking coefficient, and the function returns a first-order rate
   constant based on the total available aerosol surface area and the
   frequency of collisions
#. Add a new line to the function ``SET_HET`` in
   ``gckpp_HetRates.F90`` which calls the new function with the
   appropriate arguments and passes the calculated constant to
   ``HET``. Example: assuming a molar mass of 93 g/mol, and a
   sticking coefficient of 0.2, we would write
   ``HET(ind_XYZ, 1) = HETXYZ(93.0_fp, 0.2_fp)``

The function ``HETXYZ`` can then be specialized to distinguish
between aerosol types, or extended to provide a second-order reaction
rate, or whatever the user desires.

--------------------
Photolysis reactions
--------------------

List photolysis reactions after the heterogeneous reactions, as shown
below.

.. code-block:: console

  //
  // Photolysis reactions
  //
  O3 + hv = O + O2 :                           PHOTOL(2);      {2014/02/03; Eastham2014; SDE}
  O3 + hv = O1D + O2 :                         PHOTOL(3);      {2014/02/03; Eastham2014; SDE}
  O2 + hv = 2.000O :                           PHOTOL(1);      {2014/02/03; Eastham2014; SDE}
  ... etc ...
  NO3 + hv = NO2 + O :                         PHOTOL(12);     {2014/02/03; Eastham2014; SDE}
  ... etc ...

A photolysis reaction can be specified by giving the correct index of
the ``PHOTOL`` array. This index can be determined by inspecting the file
```FJX_j2j.dat``.

.. note:: See the 
          `PHOTOLYSIS MENU section of input.geos
	  <http://wiki.seas.harvard.edu/geos-chem/index.php/The_input.geos_file#Photolysis>`__
          to determine the folder in which ``FJX_j2j.dat`` is located.

For example, one branch of the NO3 photolysis reaction is specified in
the ``custom.eqn`` file as

.. code-block:: console

  NO3 + hv = NO2 + O : PHOTOL(12)

Referring back to ``FJX_j2j.dat`` shows that reaction 12, as
specified by the left-most index, is indeed NO3 = NO2 + O:

.. code-block:: console

  12 NO3       PHOTON    NO2       O                       0.886 /NO3   /

If your reaction is not already in ``FJX_j2j.dat``, you may add it
there. You may also need to modify ``FJX_spec.dat`` (in the same
folder ast ``FJX_j2j.dat``) to include cross-sections for your
species. Note that if you add new reactions to ``FJX_j2j.dat`` you
will also need to set the parameter ``JVN_`` in GEOS-Chem module
``Headers/CMN_FJX_MOD.F90`` to match the total number of entries.

If your reaction involves new cross section data, you will need to
follow an additional set of steps. Specifically, you will need to:

#. Estimate the cross section of each wavelength bin (using the
   correlated-k method), and
#. Add this data to the ``FJX_spec.dat`` file.

For the first step, you can use tools already available on the Prather
research group website. To generate the cross-sections used by Fast-JX,
download the file `UCI_fastJ_addX_73cx.zip
<ftp://128.200.14.8/public/prather/Fast-J_&_Cloud-J/UCI_fastJ_addX_73cx.zip>`__. 
You can then simply add your data to ``FJX_spec.dat`` and refer to it in
``FJX_j2j.dat`` as specified above. The following then describes
how to generate a new set of cross-section data for the example of some
new species MEKR:

To generate the photolysis cross sections of a new species, come up with
some unique name which you will use to refer to it in the
``FJX_j2j.dat`` and ``FJX_spec.dat`` files - e.g. MEKR. You
will need to copy one of the addX_*.f routines and make your own (say,
addX_MEKR.f). Your edited version will need to read in whatever cross
section data you have available, and you'll need to decide how to handle
out-of-range information - this is particularly crucial if your cross
section data is not defined in the visible wavelengths, as there have
been some nasty problems in the past caused by implicitly assuming that
the XS can be extrapolated (I would recommend buffering your data with
zero values at the exact limits of your data as a conservative first
guess). Then you need to compile that as a standalone code and run it;
this will spit out a file fragment containing the aggregated 18-bin
cross sections, based on a combination of your measured/calculated XS
data and the non-contiguous bin subranges used by Fast-JX. Once that
data has been generated, just add it to ``FJX_spec.dat`` and refer
to it as above. There are examples in the addX files of how to deal with
variations of cross section with temperature or pressure, but the main
takeaway is that you will generate multiple cross section entries to be
added to ``FJX_spec.dat`` with the same name.

.. important:: If your cross section data varies as a function of
	       temperature AND pressure, you need to do something a
	       little different. The acetone XS documentation shows
	       one possible way to handle this; Fast-JX currently
	       interpolates over either T or P, but not both, so if
	       your data varies over both simultaneously then this
	       will take some thought. The general idea seems to be
	       that one determines which dependence is more important
	       and uses that to generate a set of 3 cross sections
	       (for interpolation), assuming values for the unused
	       variable based on the standard atmosphere.
