// preamble
clear all 
set more off

// directories and file names
local root 		"/Users/slhudson/Dropbox (MIT)/Research/Software/renameencode"
local input 	"`root'/example/input"
local output 	"`root'/example/output"
local variables "`input'/variables.csv"
local codes 	"`input'/codes.xlsx"

// file locations
local pop80s	http://www.nber.org/data/census-intercensal-population/pop80s.dta
local pop11		http://www.nber.org/data/census-intercensal-population/2011/pepsyasex2011.dta
local files		pop80s pop11

// format of state variables
local state_pop80s 	abbreviation
local state_pop11	name

***************************************************

// set ado directory
sysdir set PERSONAL `"`root'"'

foreach file of local files {

	// load raw data from internet
	use ``file'', clear
	
	// clean individual files
		
		// only keep age 10 population estimates
		if "`file'" == "pop80s" {
			keep if age==10
		}
		// flag 2011 as the year in pop11 dataset
		else {
			gen year = 2011
		}
		
	// rename variables
	renamefrom using `"`variables'"', filetype(delimited) 				/// SH: Can we add a sheet name to this one as well to mirror the other syntax?
		name_new(variable) name_old(`file') label(label) dropx caseignore  
		
	
	// encode state with FIPS code	
	// SH: Do we currently have an option that lets users control the name of the variable *label*? Right now I think it defaults to the name of 
	// the variable itself.  Can we add that feature?
	encodefrom state using `"`codes'"', filetype(excel) sheet(state) 	/// SH: Perhaps we should make the syntax "raw" and "clean" for both commands...
		raw(`state_`file'') clean(FIPS_code) label(name) allow_missing
		
	// save clean file
	tempfile temp_`file'
	save `temp_`file''

}

// append files
clear
foreach file of local files {
	append using `temp_`file''
}

// organize data by state and year
order state year
sort state year

// save combined file
save `"`output'/population_age10"', replace

***************************************************
