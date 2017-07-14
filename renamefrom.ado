// We'll work on the preamble once we finalize the code.
// Purpose: This program renames and labels variables using an external Excel spreadsheet.

capture program drop renamefrom

program define renamefrom, nclass
	syntax using/, filetype(string) name_old(string) name_new(string) ///
		[delimiters(string)] [sheet(string)]	///
		[if(string)]			///
		[label(string)]  		///
		[keepx] [dropx]  		///
		[keeplabel] [namelabel] ///
		[CASEignore] ///

	// declare error codes
	local syntaxError 198
	local otherError  102
		
	// display process comment
	display ""
	display "renaming variables from workbook `using'"
	display ""
	
	// preserve the existing data
	preserve
		
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
	
	// get variable names
	if "`filetype'" == "excel" {
		import excel `"`using'"', sheet(`sheet') firstrow clear
	}
	else if "`filetype'" == "delimited" {
		import delimited `"`using'"', delimiters("`delimiters'") ///
									varnames(1) case(preserve) clear
	}
	else if "`filetype'" == "stata" {
		use `"`using'"', clear
	}
	else {
		display as error "`filetype' is not a valid filetype"
		exit `syntaxError'
	}
	
	quietly keep if !missing(`name_old') & !missing(`name_new')
	
	// restrict based on "if" option
	if `"`if'"' != "" {  //"
		keep if `if'
	}
	
	// if caseignore option, rename all "old" vars to lowercase
	// keep a copy of "old" variables with original capitalization if needed later for variable labels
	tempvar name_old_preserved
	gen `name_old_preserved' = `name_old'
	if "`caseignore'" == "caseignore" {
		replace `name_old' = lower(`name_old')
	}
	
	// verify that old and new variable names are unique
	foreach name in name_old name_new {
		tempvar N
		bysort ``name'': gen `N' = _N
		cap assert (`N' == 1)
		if _rc {
			display as error `"function call was "renamefrom `varlist' `0'"'  //"
			display as error "The `name' column contains duplicate variable names.  Please specify a 1:1 mapping from old names to new names."
			list ``name'' if (`N' > 1)
			exit _rc
		}
	}
	
	// store the variable names and labels as locals
	local n_vars = _N
	forvalues i = 1/`n_vars' {
		local new_`i' = `name_new'[`i']
		local old_`i' = `name_old'[`i']
		local old_preserved_`i' = `name_old_preserved'[`i']
		
		if "`label'" != "" {
			local label_`i' = `label'[`i']
		}
		
	}
	
	// restore the working data
	restore
	
	//if caseignore option on, convert var to lower
	if "`caseignore'" == "caseignore" {
		
		// keep whole variable list to later keep capitalization of vars that were not renamed
		qui ds
		local old_vars `r(varlist)'
		
		foreach var of varlist _all {	
			local lower = lower("`var'")
			capture quietly rename `var' `lower'
		}
	}
	
	// assert that all old variables in excel column are actually in dataset.
	forvalues i = 1/`n_vars' {
		capture confirm variable `old_`i''
		if _rc {
			local missing_list `missing_list' `old_`i''
		}
	}
		// print missing variables
		if "`missing_list'" != "" & "`dropx'" == ""  {
			display as error `"function call was "`0'"'  //"
			display as error "The name_old column contains the following variables not found in the master dataset."
			display ""
			display "`missing_list'"
			exit `otherError'
		}	

	// order variables so that the ones you want to keep are first
	forvalues i = `n_vars'(-1)1 {
		order `old_`i''
	}
	
	// rename vars, drop if indicated, and collect leftover vars otherwise
	local i = 1
	local n_extra = 0
	foreach v of varlist _all {
		if `i' <= `n_vars' {
			tempvar `new_`i''
			qui rename `v' ``new_`i'''
		}
		else {
			if "`dropx'" == "dropx" {
				drop `v'
			}
			else {
				local extras `extras' `v'
				local ++n_extra
			}
		}
		local ++i	
	} 
	
	// this loop and the one above it have to happen separately because
	// tempvars and variable names have different caps on character length
	local i = 1
	foreach v of varlist _all {
		if `i' <= `n_vars' {
			qui rename  ``new_`i''' `new_`i''
			local ++i
		}
	}

	// revert to non-lowercased names for variables that were not renamed
	if (`n_extra' > 0) & ("`caseignore'" == "caseignore") {
		foreach extra_var of local extras {
			foreach old_var of local old_vars {	

				if lower("`old_var'") == "`extra_var'" {
					local extras_cap `extras_cap' `old_var'
					break
				}
				
			} 
		}
		rename (`extras') (`extras_cap')
	}
	
	// label variables 
	forvalues i = 1/`n_vars' {
	
		if "`label_`i''" != "" {						// use Excel value if provided
			label var `new_`i'' "`label_`i''"
		}
		else if ("`keeplabel'" == "") {					// If no Excel value, and keep label is not specified,
			label var `new_`i'' ""						// overwrite existing label.
		}
		
		local varlab : variable label `new_`i''			// If label is left missing,
		if ("`varlab'" == "") & ("`namelabel'" != "") {	// and name label option is specified,
			label var `new_`i'' "`old_preserved_`i''"				// apply old name as new label.
		}
	}
	
	// list variables you haven't renamed yet
	if ("`keepx'" != "keepx") & (`n_extra' > 0) { 
		display as error "The following variables were not assigned a clean name.  Please provide a name for each in the supporting spreadsheet, or specify option 'keepx'"
		describe `extras_cap'
		exit `otherError'
	}

end	
	
