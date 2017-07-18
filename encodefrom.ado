// We'll work on the preamble at the very end.
// Purpose: This program maps raw values to clean, labeled integers using a crosswalk 
// provided in the using data or an external spreadsheet.

**************************************************************************************
**************************************************************************************
**************************************************************************************

capture program drop encodefrom

program define encodefrom, nclass
	syntax varname using/, 	filetype(string) raw(string) clean(string) label(string) ///
							[delimiters(string)] [sheet(string)]					///
							[noallow_missing] [CASEignore]			///

	
	di "encoding `varlist' from `using'..."
	
	// declare temporary variables
	tempvar merge code labels N
	
	// declare error codes
	local syntaxError 198
	
	// display process comment
	di ""
	di "encoding `varlist' from `using'... "
	di ""
	
	// determine if varlist is string or number
	cap confirm numeric variable `varlist' 
	local type_string_raw = _rc
	
	preserve
	
	**************************************************************************************
	
	*** DEFINE MAPPING FROM RAW TO CLEAN VALUES ***
	
	// sheet can be specified if and only if using excel
	// delimiters can be specified if and only if using delimited file
	if ("`sheet'" != "") & ("`filetype'" != "excel") {
		display as error "Cannot specify sheet unless using excel filetype"
		exit `syntaxError'
	} 
	else if ("`sheet'" == "") & ("`filetype'" == "excel") {
		display as error "Must specify sheet when using excel filetype"
		exit `syntaxError'
	}
	if ("`delimiters'" != "") & ("`filetype'" != "delimited") {
		display as error "Cannot specify delimiters unless using delimited filetype"
		exit `syntaxError'
	}
	
	// get code values matched to raw values 
	if "`filetype'" == "excel" {
		import excel `"`using'"', sheet(`sheet') firstrow clear
	}
	else if "`filetype'" == "delimited" {
		import delimited  `"`using'"', delimiters("`delimiters'") ///
									varnames(1) case(preserve) clear
	}
	else if "`filetype'" == "stata" {
		use `"`using'"', clear
	}
	else {
		display as error "`filetype' is not a valid filetype"
		exit `syntaxError'
	}
	
	keep `clean' `raw' `label'

		// allow for raw and (label or clean) to be same spreadsheet column
		foreach v in label clean { 
			if "``v''" == "`raw'" {
				tempvar `v'
				gen ``v'' = `raw'
			}
		}
		
	//  determine if potential values are string or numeric
	cap confirm numeric variable `raw'
	local type_string_pot = _rc
	
	// make `raw' string or not depending on `varlist' format, and reduce to 
	// unique combinations of raw, clean, and label values 
	if `type_string_raw' | `type_string_pot'  {
		qui tostring `raw', replace usedisplayformat 
		qui drop if `raw' == "."
		if "`caseignore'" == "caseignore" {
			qui replace `raw' = lower(`raw')
		}
	}
	qui drop if missing(`raw')
	qui duplicates drop

	// rename variables to tempvars
	gen `code' = `clean'
	gen `labels' = `label'
	drop `clean' `label'
	
	// save matched codes data set
	rename  `raw' `varlist'
	tempfile codes
	qui save `codes'
	
	**************************************************************************************
	
	*** DEFINE MAPPING FROM CLEAN VALUES TO LABELS ***

	// verify that only one label is supplied for each clean code value	
	bysort `code' `labels': keep if (_n == 1)
	bysort `code': gen `N' = _N	
	cap assert (`N' == 1)
	if _rc { 
		display as error "The following code values are assigned to more than one label"
		list `code' `labels' if (`N' > 1)
		exit _rc
	}

	// define label: this is a PITA (plug in the answer) method to store a local for each value label
	qui levelsof `code', local(codes_clean)
	foreach x of local codes_clean {
		forvalues i = 1/`=_N'{
			if `code'[`i'] == `x' {
				local label_`x' = `labels'[`i']
				break
			}
		}
	}

	**************************************************************************************
		
	*** ENCODE AND LABEL VARIABLES ***
	
	// restore master data
	restore
	
	// make raw values string if potential values are strings
	if `type_string_raw' | `type_string_pot' {
		qui tostring `varlist', replace usedisplayformat
		if "`caseignore'" == "caseignore" {
			qui replace `varlist' = lower(`varlist')
			}
	}

	// merge with clean values
	qui merge m:1 `varlist' using `codes', keep(master match) keepusing(`code') gen(`merge')

	// verify that all raw values could be found in the provided spreadsheet
	cap assert (`merge' != 1 | missing(`varlist'))
	if _rc {
		display as error `"The function call was "encodefrom `0'" "'
		display as error "The following values for `varlist' were not found in the supporting spreadsheet:"
		tab `varlist' if (`merge' == 1)
		exit _rc
	}	
		
	// verify that all raw values have found a non-missing clean value unless allow_missing is specified
	cap assert !missing(`code') if !missing(`varlist')
	if _rc & "`allow_missing'" == "noallow_missing" {
		display as error "The following raw values for `varlist' must be mapped to non-missing clean values:" 
		tab `varlist' if missing(`code')
		exit _rc
	}

	// replace raw values with clean values
	local lbl: var label `varlist'
	drop `varlist'
	generate `varlist' = `code'
	label var `varlist' "`lbl'"

	// label values
	cap label drop `varlist'
	local i = 1
	foreach x of local codes_clean {
		label define `varlist' `x' "`label_`x''", modify	
	}	
	label values `varlist' `varlist'
	drop `merge' `code' 
	
	// tab new codes
	qui compress `varlist'
	tab `varlist', missing
	di ""

end	

**************************************************************************************
**************************************************************************************
**************************************************************************************

