{smcl}
{* *! version 1.2.0  02jun2011}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "encodefrom##syn"}{...}
{viewerjumpto "Description" "encodefrom##des"}{...}
{viewerjumpto "Options" "encodefrom##opt"}{...}
{viewerjumpto "Remarks" "encodefrom##rem"}{...}
{viewerjumpto "Examples" "encodefrom##exa"}{...}
{title:Title}

{phang}
{bf:encodefrom} {hline 2} Encode variable with values and value labels
specified in an external spreadsheet

{title:Table of contents}

	{help encodefrom##syn:Syntax}
	{help encodefrom##des:Description}
	{help encodefrom##opt:Options}
	{help encodefrom##rem:Remarks}
	{help encodefrom##exa:Examples}

{marker syn}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:encodefrom} {varname} {cmd:using} {it:filename}
{cmd:,} {opt filetype(string)} {opt raw(string)} {opt clean(string)} {opt label(string)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}

{synopt:{opt filetype(excel|delimited|stata)}}file type of external file with 
 new variable values and value labels{p_end}
{synopt:{opt raw(string)}}specifies columns with values to be encoded {p_end}
{synopt:{opt clean(string)}}specifies columns with clean values (e.g. 1, 2, 3, ...) {p_end}
{synopt:{opt label(string)}}specifies column with value labels{p_end}
{synopt:{opt delimiters(chars)}}use {it:chars} as delimiters; by default, tabs or commas{p_end}
{synopt:{opt sheet(string)}}specifies sheet within excel document using{p_end}
{synopt:{opt allow_missing}}allows "clean" to include missing values {p_end}
{synopt:{opt caseignore}}ignores capitalization when matching variables with 
variable names in the name_old column{p_end}
{synoptline}



{marker des}{...}
{title:Description}

{pstd}
{cmd:encodefrom} encodes the variable specified by {it:varname} with the labels 
and values specified in {it:using}.



{marker opt}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt filetype(excel|delimited|stata)} specifies the file type
of the external spreadsheet that lists the old and new variable names. 
The {it:excel} option is for Excel workbooks with file extensions {bf:.xls}
and {bf:.xlsx}. The {it:delimited} option is for text files with one observation
per line and values separated by some delimiter. For instance, {bf:.csv} files
have comma-separated values, and {bf:.txt} files are tab-separated. The {it:stata}
option is for Stata-format datasets with the {bf:.dta} extension. 

{phang}
{opt raw(string)} specifies the column in the external file {it:using} that contains the old 
values of the variable specified by {it:varname}

{phang}
{opt clean(string)} specifies the column in {it:using} that will be used as the 
underlying levels after encoding is complete.  This will often be populated with 
sequential ascending integers (e.g. 1, 2, 3, 4...). By default, this column can
include missing values. To refuse {it:using} files with missing "clean" values 
associated with non-missing "raw" values, the option "noallow_missing" must be specified.

{phang}
{opt label(string)} specifies the column in {it:using} that contains the value labels.

{phang}
{opt delimiters(chars)} chooses the delimiter used to separate the values of an
external delimited file. Can only be used with the delimited filetype option. For
example, to specify commas, tabs, and whitespace as delimiters, type {opt delimiters(,)},
{opt delimiters(\t)}, and {opt delimiters{whitespace)}, respectively. If no
delimiter is chosen, Stata will by default check if the file is delimited by tabs or
commas. 

{phang}
{opt sheet(string)} specifies sheet within {it:using} excel document.
This option cannot be used for other file types and must be specified if {it:using} is
an excel document.

{phang}
{opt noallow_missing} does not allow a "clean" value that is associated with
a non-missing "raw" value to be missing. 

{phang}
{opt caseignore} ignores capitalization when matching original {varname} values 
with "raw" {it:varname} values in the raw column.

{marker rem}{...}
{title:Remarks}

{pstd}
This code is still in beta stage.  If you encounter any bugs or have suggestions for 
improvement, please feel free to contact the developers.  If you want to take a stab at 
implementing an improvement, let us know -- the code is hosted on github, and we're happy to share!


BREAK. EVERYTHING AFTER THIS IS FROM TEMPLATE


{marker exa}{...}
{title:Examples}

{phang}{cmd:. whatever mpg weight}{p_end}

{phang}{cmd:. whatever mpg weight, meanonly}{p_end}
