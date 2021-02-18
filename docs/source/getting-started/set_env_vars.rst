.. _set_environment_variables_for_kpp:

Set environment variables for KPP
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Once have built KPP, you must add the path to the KPP executable to your
Unix ``PATH`` variable.

If you use the bash Unix shell, add these lines to your
``~/.bash_aliases`` file. (If you don't have a
``~/.bash_aliases`` file, you can add these lines to your
``~/.bashrc`` file instead.)

| ``export PATH=$PATH:/PATH_TO_KPP/KPP/kpp-code/bin/``
| ``export KPP_HOME=PATH_TO_KPP/KPP/kpp-code``

If you use the csh or tcsh Unix shell, add these lines to your
``~/.cshrc`` file:

| ``setenv PATH $PATH:/PATH_TO_KPP/KPP/kpp-code/bin/``
| ``setenv KPP_HOME=PATH_TO_KPP/KPP/kpp-code``

NOTES:

-  In the examples above, ``PATH_TO_KPP`` is the path to the
   top-level KPP folder.
-  For example, if you installed KPP into your home directory, then
   ``PATH_TO_KPP`` would be ``~/KPP``, etc.
