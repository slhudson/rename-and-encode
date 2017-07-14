// preamble
clear all 
set more off

// directories
local root 		"/Users/slhudson/Dropbox (MIT)/Research/Software/renameencode"
local input 	"`root'/example/input"
local output 	"`root'/example/output"
local variables "`input'/variables.xlsx"
local codes 	"`input'/codes.xlsx"

// parameters
local years		1990 2000

***************************************************

// set ado directory
sysdir set PERSONAL `"`root'"'

// loop over years
foreach year of local years {

	// load raw data
	insheet using `"`input'/CENSUS`year'.csv"', comma clear

	// rename variables
	renamefrom using `"`variables'"', filetype(excel) sheet(census) name_new(variable) ///
		name_old(census_`year') label(label) caseignore

	// encode area key
	encodefrom areakey using `"`codes'"', filetype(excel) sheet(tract) raw(areakey) clean(code) label(label)
	
	// flag year
	gen year = `year'
	
	// save clean file
	tempfile census`year'
	save `census`year''
	
} // end of year loop


// append year-specific files
clear
foreach year of local years {
	append using `census`year''
}

// save combined file
save `"`output'/census"', replace
