===============================
KPP-for-GEOS-Chem Documentation
===============================

.. raw:: html

 <p>
   <a href="https://github.com/geoschem/KPP/blob/GC_updates/LICENSE.txt"><img
   src="https://img.shields.io/badge/License-MIT-blue.svg"></a>
   <a href="https://doi.org/10.5281/zenodo.4537861"><img src="https://zenodo.org/badge/DOI/10.5281/zenodo.4537861.svg"></a>
   <a href="https://kpp.readthedocs.io/en/latest/"><img src="https://img.shields.io/readthedocs/kpp?label=ReadTheDocs"></a>
   </p>
	 

**KPP-for-GEOS-Chem** is `a clean implementation of
the Kinetic Pre Processor (KPP) <https://github.com/geoschem/kpp/tree/GC_updates>`__ that has
been customized for GEOS-Chem v11-01 and later versions. You can use
KPP-for-GEOS-Chem to create custom GEOS-Chem Chemistry Mechanisms.

.. toctree::
   :maxdepth: 4
   :caption: Basic Information

   basic-info/about.rst
   basic-info/requirements.rst
   
.. toctree::
   :maxdepth: 4
   :caption: Usage Details

   usage-details/installation.rst
   usage-details/generating_f90_code.rst
   usage-details/use_custom_mech.rst

.. toctree::
   :maxdepth: 4
   :caption: Creating & Modifying Mechanisms

   creating-mechanisms/configuration_files.rst 
   creating-mechanisms/species.rst
   creating-mechanisms/reactions.rst
   creating-mechanisms/chemical_families.rst
  
  
  
.. toctree::
   :maxdepth: 1
   :caption: Help & Reference

   reference/known-bugs.rst 
   reference/SUPPORT.md
   reference/CONTRIBUTING.md
   geos-chem-shared-docs/editing_these_docs.rst
   reference/git-submodules.rst
   reference/glossary.rst
   reference/versioning.rst
