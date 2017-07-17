// preamble
clear all 
set more off

// directories
local root 		"/Users/slhudson/Dropbox (MIT)/Research/Software/renameencode"
local input 	"`root'/example/input"
local output 	"`root'/example/output"
local variables "`input'/variables.xlsx"
local codes 	"`input'/codes.xlsx"


***************************************************

// set ado directory
sysdir set PERSONAL `"`root'"'

// crime data

	// load raw data
	import delimited using `"`input'/crime_rates.csv"', clear

	// rename variables
	renamefrom using `"`variables'"', filetype(excel) sheet(crime) name_new(variable) ///
		name_old(crime_rates) label(label) caseignore
		
	// encode state with FIPS code
	encodefrom state using `"`codes'"', filetype(excel) sheet(state) raw(state_name) clean(code) label(state_name)

	// save clean file
	tempfile crime
	save `crime'
	
// census data

	// load raw data
	sysuse census, clear
	
	// use state abbreviation
	drop state
	rename state2 state
	
	// encode state with FIPS code
	encodefrom state using `"`codes'"', filetype(excel) sheet(state) raw(abbreviation) clean(code) label(state_name)

// merge files
merge 1:1 state using `crime', nogen
order state

// save combined file
save `"`output'/crime"', replace
