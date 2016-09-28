#!/bin/bash

codedir="/n/home05/msulprizio/GC/Code.v11-01/KPP/"
chem="Custom"

echo '-----------------------------------------------------------------------'
echo 'Copying gckpp files to' $codedir$chem
echo '-----------------------------------------------------------------------'

cp -v gckpp_Function.F90      $codedir$chem
cp -v gckpp_Global.F90        $codedir$chem
cp -v gckpp_Hessian.F90       $codedir$chem
cp -v gckpp_HessianSP.F90     $codedir$chem
cp -v gckpp_Initialize.F90    $codedir$chem
cp -v gckpp_Integrator.F90    $codedir$chem
cp -v gckpp_Jacobian.F90      $codedir$chem
cp -v gckpp_JacobianSP.F90    $codedir$chem
cp -v gckpp_LinearAlgebra.F90 $codedir$chem
cp -v gckpp_Model.F90         $codedir$chem
cp -v gckpp_Monitor.F90       $codedir$chem
cp -v gckpp_Parameters.F90    $codedir$chem
cp -v gckpp_Precision.F90     $codedir$chem
cp -v gckpp_Rates.F90         $codedir$chem
cp -v gckpp_Util.F90          $codedir$chem
cp -v globchem.eqn            $codedir$chem
cp -v globchem.spc            $codedir$chem
cp -v globchem.def            $codedir$chem
#cp -v Makefile_gckpp          $codedir$chem

exit 0
