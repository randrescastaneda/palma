/*====================================================================
project:       Palma inequality index
Author:        Andres Castaneda and Paul Corral
Dependencies:  The World Bank
----------------------------------------------------------------------
Creation Date:      18 Aug 2017 
Modified Date:      21 Aug 2017 
Do-file version:    0.2
References:    
           - Palma, J.G., 2006, "Globalizing inequality: ‘Centrifugal’ an ‘centripetal’ forces atwork" DESA Working Paper 35, New York: UN Department of Economic and Social Affairs.
           - Palma, J.G., 2011, ‘Homogeneous middles vs. heterogeneous tails, and the end of the ‘Inverted-U’: The share of the rich is what it’s all about’, Cambridge Working Papers in Economics 1111, Cambridge: University of Cambridge Department of Economics (later published in Development and Change, 42, 1, 87-153).

====================================================================*/

program define palma, rclass sortpreserve 
version 13
syntax varname [if] [in] [aweight fweight],    [ ///
SEGments(numlist min=2 max=2) Method(string)   ///
]

preserve 
marksample touse

qui {
keep if `touse'
	*** check for quantiles
	cap which quantiles
	if (_rc) ssc install quantiles
	
	**  consistency 
	
	if ("`method'" == "") local method "quantiles"
	if !inlist("`method'", "quantiles", "xtile") {
		noi disp as err "method must be either quantiles or xtile"
		error
	}
	
	*** Weights
	local weight "[`weight'`exp']"				
	
	** Semgments of the population
	if ("`segments'" == "") local segments "10 40"
	local top   : word 1 of `segments'
	local bottom: word 2 of `segments'
	
	tempvar q
	
	**  method to create deciles
	if ("`method'" == "quantiles") {
		quantiles `varlist' `weight' , gen(`q') n(100)
	}
	else xtile `q' = `varlist' `weight' , n(100)
	
	** calculations
	sum `varlist' if `q'>=`=100-`top'' & `q'<. `weight', meanonly
	local tmean=r(mean)
	sum `varlist' if `q'<=`bottom' `weight', meanonly
	local bmean=r(mean)
	
	//Palma
	local palma = (`tmean'/`bmean')*(`top'/`bottom')
	return local palma = `palma'
	
	
	// Display results
	local l = length(" Palma index (`top'/`bottom')")
	noi disp as txt "{hline `l'}" "{c TT}" "{hline `=30-`l''}" _n  ///
	as res " Palma index (`top'/`bottom')"                         ///
	as txt "{c |}  " as res %5.3f `palma'    _n                    ///
	as txt "{hline `l'}" "{c BT}" "{hline `=30-`l''}" 
}

end
exit

/* End of do-file */
><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><><

Notes:
1.
2.
3.


Version Control:

