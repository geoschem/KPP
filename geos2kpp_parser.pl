#!/usr/bin/perl
 
 #=================================================================#
 #                                                                 #
 #           G L O B C H E M . D A T    P A R S E R                #
 #                                                                 #
 # Author: Paul Eller, 04/21/2008                                  #
 # Desc  : Designed to parse GEOS-Chem chemistry file and generate # 
 #         KPP input files                                         #
 #                                                                 #
 # Input : globchem.dat                                            #
 #                                                                 #
 # Output: *.def, *.eqn, *.spc                                     #
 #                                                                 #
 # Code developed by Initial Developer are Copyright (C) 2008      #
 #                                                                 #
 #=================================================================#
 
 
 #===================================================
 # Variable Declarations
 #===================================================
 my @active; # Holds active species
 my @inactive; # Holds inactive species
 my @dead; # Holds dead species
 my @reaction; # Holds main reaction data
 my @reaction2; # Holds second line of reaction data
 my @reaction3; # Holds third line of reaction data
 my $GEOSCHEM; # File handler for the Geos-Chem .dat file
 my $KPP_SPC; # File handler for the KPP .spc file
 my $KPP_EQN; # File handler for the KPP .eqn file
 my $KPP_DEF; # File handler for the KPP .def file
 
 my $kppfile; # Holds name to use for KPP files
 my $input; # Holds input line to evaluate
 my $check; # Holds check input line
 
 my $equation; # Holds equation line to be written to KPP .eqn file
 my $eqnNum; # Holds number of the current equation
 my $eqnLen; # Holds length of the current equation
 
 #===================================================
 # Initialize Parser
 #===================================================
 sub init
 {
     # Get name of Geos-Chem input file
     $inputfile = "";
     $inputfile = $ARGV[0];
     if($inputfile eq "")
     {
 	printf "Include name of file to parse as first argument\n";
 	exit(0);
     }
 
     chomp($inputfile);
     printf "Parsing $inputfile\n";
 
     # Open the Geos-Chem input file
     open(GEOSCHEM, "<$inputfile") || die "Unable to open $inputfile\n";
 
     # Open the KPP input files
     @inputname = split(/\./, $inputfile);
     $kppfile = $inputname[0];
     open(KPP_SPC, ">$kppfile.spc");
     open(KPP_EQN, ">$kppfile.eqn");
     open(KPP_DEF, ">$kppfile.def");
     printf KPP_EQN "#Equations\n\n";
 }
 
 #=============================================================
 # Return a string of spaces for output
 #
 # @params $_[0]] - Holds number of spaces to put in string
 # @return - string with the requested number of spaces
 #=============================================================
 sub spaceString
 {
     $spaces = "";
     for($cspace = 0; $cspace < $_[0]; $cspace++)
     {
 	$spaces = $spaces . " ";
     }
     $spaces;
 }
 
 #==================================================
 # Evaluate Species List
 #
 # Read in each species, stop when reaching the
 # start of the Kinetic reactions section
 # Push each species and default background 
 # concentration onto the correct array
 #==================================================
 sub evaluateSpeciesList
 {
     while(!($input =~ m/END/) && !eof(GEOSCHEM))
     {
 	@species1 = split(/ +/, $input); # Holds first line of species data
 	$input = <GEOSCHEM>;
 	chomp($input);
 	if($species1[0] eq "A")
 	{
 	    if($species1[1] !~ m/^M$/)
 	    {
 		push(@active, $species1[1], $species1[6]);
 	    }
 	    else
 	    {
 		push(@active, "hv", $species1[6]);
 	    }
 	} 
 	elsif($species1[0] eq "I")
 	{
 	    if($species1[1] !~ m/^M$/)
 	    {
 		push(@inactive, $species1[1], $species1[6]);
 	    }
 	    else
 	    {
 		push(@inactive, "hv", $species1[6]);
 	    }
 	}
 	elsif($species1[0] eq "D")
 	{
 	    push(@dead, $species1[1]);
 	}
 	$input = <GEOSCHEM>;
 	chomp($input);
     }
 }
 
 #=============================================
 # Evaluate Reaction Rate Lines
 #=============================================
 sub evaluateRateLines()
 {
     # Read in all reaction lines of data
     @reaction = split(/ +/, $input); # Holds reaction data
     $input = $check;
     chomp($input);
     $reactLines = $reaction[5];
     
     for ($i = 0; $i < $reactLines; $i++)
     {
 	if($i == 0) 
 	{
 	    @reaction2 = split(/ +/, $input);
 	    shift(@reaction2);
 	}
 	elsif($i == 1)
 	{
 	    @reaction3 = split(/ +/, $input);
 	    shift(@reaction3);
 	}
 
 	$input = <GEOSCHEM>;
 	chomp($input);
     }
 }
 
 #=============================================
 # Evaluate Reactant Line
 #=============================================
 sub evaluateReactantLine
 {
     # Read in reactant line
     chomp($input);
     @reactants = split(/ +/, $input); # Holds reactant data
     $input = <GEOSCHEM>;
     chomp($input);
     $equation = $equation . "{$eqnNum} ";
     $eqnLen += 3 + length($eqnNum);
     $eqnNum++;
 
     # Write each reactant to the equations file
     for($i = 1; $i < @reactants; $i=$i+2)
     {
 	if($reactants[$i] ne "M")
 	{
 	    $equation = $equation . "$reactants[$i] ";
 	    $eqnLen += 1 + length($reactants[$i]);
 	}
 	else
 	{
 	    $equation = $equation . "hv ";
 	    $eqnLen += 3;
 	}
 
 	# Check to see if + or hv needs to be added to the equation
 	if($i+1 < @reactants)
 	{
 	    # Add a + to the equation if there are more reactants
 	    # left to write to the file
 	    if($reactants[$i+1] =~ m/\+/ && $i + 2 < @reactants 
 	       && $reactants[$i+1] ne "M")
 	    {
 		$equation = $equation . "+ ";
 		$eqnLen += 2;
 	    }
 
 	    # Change M to hv
 	    elsif($reactants[$i+1] eq "M")
 	    {
 		$equation = $equation . "+ hv ";
 		$eqnLen += 5;
 		last;
 	    }
 	}
     }
 }
 
 #==============================================
 # Evaluate Product Lines
 #==============================================
 sub evaluateProductLines
 {
     # Read in each product line of data
     $done = 0;
     for ($j = 0; $j < 4; $j++)
     {
 	# Parse each product line
 	@products = split(/ +/, $input); # Holds product data
 	$input = <GEOSCHEM>;
 	chomp($input);
 
 	# Only evaluate products if there are still products to evaluate
 	if($done == 0)
 	{
 	    # Evaluate each product in an equation
 	    for ($i = 0; $i < @products; $i++)
 	    {
 		# Get product
 		$product = $products[$i];
 
 		# Remove the = from the front of the first product
 		if ($product =~ m/^=/)
 		{
 		    $equation = $equation . "= ";
 		    $eqnLen += 2;
 		    $product = substr($product, 1);
 		}
 
 		# Remove the + from the front of any products
 		if ($product =~ m/^\+/)
 		{
 		    if (length($product) > 1)
 		    {
 			$equation = $equation . "+ ";
 			$eqnLen += 2;
 			$product = substr($product, 1);
 		    }
 		    else
 		    {
 			$done = 1;
 			last;
 		    }
 		}
 
                 # Remove 1.000 from the front of any products
 		if ($product =~ m/^1\.000/)
 		{
 		    $product = substr($product, 5);
 		}
 
 		# Change M to hv
 		if($product =~ m/^M$/)
 		{
 		    $product = "hv";
 		}
 		
 		# Check to see if next product needs to be written on a
 		# new line
 		if(12 + length($product) + $eqnLen > 55)
 		{
 		    $equation = $equation . "\n       $product ";
 		    $eqnLen = 8 + length($product);
 		}
 		else
 		{
 		    $equation = $equation . "$product ";
 		    $eqnLen += 1 + length($product);
 		}
 	    }
         }
 	$done = 0;
     }
 }
 
 #======================================================
 # Checks and corrects the format of the reaction rate
 #
 # @return formatted reaction rate
 #======================================================
 sub formatReaction
 {
     $rrate =  "";
     for($i=1; $i<=$_[0]; $i++)
     {
 	$rrate = $rrate . "$_[$i]";
 	if($_[$i] !~ m/\./ && $_[$i] !~ m/E/ && $_[$i] !~ m/e/)
 	{
 	    $rrate = $rrate . ".0";
 	}
 	if($i < $_[0])
 	{
 	    $rrate = $rrate . ", ";
 	}
     }
     $rrate;
 }
 
 #==================================================
 # Returns the Kinetic reaction rate
 #
 # @return string with kinetic reaction function
 #==================================================
 sub getKineticRate
 {
     $krate = "";
     # Evaluates reactions with a value in the P Column
     # Kinetic Reaction rates
     $krate = "EXTARR(" . formatReaction(3, $reaction[2], $reaction[3], 
 					    $reaction[4]);
     $krate;
 }
 
 #==========================================================
 # Returns the Photolysis Reaction Rate
 #
 # @return string with photolysis reaction rate function
 #==========================================================
 sub getPhotolysisRate
 {
     $prate = "";
     # Phtolysis Reactions
     $prate = "EXTARR(" . formatReaction(3, $reaction[2], $reaction[3], 
 					    $reaction[4]);
     $prate;
 }
 
 #========================================================
 # Evaluates a reaction by evaluating the rate lines,
 # reactant line, and product lines
 #
 # @params $_[0] = "K" for kinetic reactions,
 #                 "P" for photolysis reactions
 #========================================================
 sub evaluateReaction
 {
     evaluateRateLines();
     evaluateReactantLine();
     evaluateProductLines();
     
     # Add spaces to the end of the equation
     $spaces = spaceString(52 - $eqnLen);
 
     # Only write equation to the file if they are active
     if($reaction[0] eq "A")
     {
 	if($_[0] eq "K")
 	{
 	    $rate = getKineticRate();
 	}
 	elsif($_[0] eq "P")
 	{
 	    $rate = getPhotolysisRate();
 	}
         printf KPP_EQN "$equation: $spaces $rate);\n";
     }
 
     $check = <GEOSCHEM>;
     chomp($input);
     $eqnLen = 0;
     $equation = "";
 }
 
 #==================================================
 # Builds the Kpp .def file
 #==================================================
 sub buildKppDef
 {
     printf KPP_DEF "#include $kppfile.spc\n" .
 	           "#include $kppfile.eqn\n\n" .
                    "#LANGUAGE Fortran90\n" .
                    "#INTEGRATOR rosenbrock\n" .
                    "#DRIVER general\n\n" .
                    "#LOOKATALL\n\n" .
                    "#INITVALUES\n\n";
 
     for($i = 0; $i < @active; $i=$i+2)
     {
 	printf KPP_DEF "$active[$i] = $active[$i+1];\n";
     }
 
     for($i = 0; $i < @inactive; $i=$i+2)
     {
 	printf KPP_DEF "$inactive[$i] = $inactive[$i+1];\n";
     }
 }
 
 #=====================================================
 # Builds the Kpp .spc file
 #=====================================================
 sub buildKppSpc
 {
     printf KPP_SPC "#include atoms\n\n" .
                    "#DEFVAR\n\n";
     
     for($i = 0; $i < @active; $i=$i+2)
     {
 	if($active[$i] ne "hv")
 	{
 	    $spaces = spaceString(14 - length($active[$i]));
 	    printf KPP_SPC "     $active[$i] $spaces =          IGNORE;\n";
 	}
     }
 
     for($i = 0; $i < @dead; $i++)
     {
 	if($dead[$i] ne "hv")
 	{
 	    $spaces = spaceString(14 - length($dead[$i]));
 	    printf KPP_SPC "     $dead[$i] $spaces =          IGNORE;\n";
 	}
     }
 
     printf KPP_SPC "\n#DEFFIX\n\n";
     for($i = 0; $i < @inactive; $i=$i+2)
     {
 	if($inactive[$i] ne "hv")
 	{
 	    $spaces = spaceString(14 - length($inactive[$i]));
 	    printf KPP_SPC "     $inactive[$i] $spaces =          IGNORE;\n";
 	}
     }
 }
 
 #======================================================
 # Main Parser
 #======================================================
 
 # Holds the line termination character
 init();
 
 # Move to the beginning of the species list
 $input = "";
 $input = <GEOSCHEM>;
 
 while($input !~ m/BEGIN/ && !eof(GEOSCHEM))
 {
     $input = <GEOSCHEM>;
 }
 
 # Move to the first species
 for ($i=0; $i < 3; $i++)
 {
     $input = <GEOSCHEM>;
 }
 chomp($input);
 
 # Evaluate Species List section
 evaluateSpeciesList();
 
 # Move to the first Kinetic reaction
 while($input !~ m/BEGIN/ && !eof(GEOSCHEM))
 {
     $input = <GEOSCHEM>;
 }
 $input = <GEOSCHEM>;
 chomp($input);
 $check = <GEOSCHEM>;
 chomp($check);
 
 $eqnNum = 1;
 $eqnLen = 0;
 $equation = "";
 
 # Evaluate Kinetic reactions until reaching the END KINETIC line or 
 # end of the file
 while($check !~ m/END KINETIC/ && !eof(GEOSCHEM))
 {
     evaluateReaction("K");
 }
 
 # Move to the first Kinetic reaction
 while($input !~ m/BEGIN/ && !eof(GEOSCHEM))
 {
     $input = <GEOSCHEM>;
 }
 $input = <GEOSCHEM>;
 chomp($input);
 $check = <GEOSCHEM>;
 chomp($check);
 
 $eqnLen = 0;
 $equation = "";
 
 # Evaluate Photolysis reactions until reaching the END PHOTOLYSIS
 # line or end of the file
 while($check !~ m/END PHOTOLYSIS/ && !eof(GEOSCHEM))
 {
     evaluateReaction("P");
 }
 
 # Build .def and .spc files
 buildKppDef();
 buildKppSpc();
 
 printf "Creating $kppfile.def, $kppfile.eqn, and $kppfile.spc\n";
 
 # Close the input and output files
 close(GEOSCHEM);
 close(KPP_SPC);
 close(KPP_EQN);
 close(KPP_DEF);

#  LocalWords:  usr
