{smcl}
{* *! version 1.2.0  02jun2011}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "encodefrom##syn"}{...}
{viewerjumpto "Description" "encodefrom##des"}{...}
{viewerjumpto "Options" "encodefrom##opt"}{...}
{viewerjumpto "Examples" "encodefrom##exa"}{...}
{viewerjumpto "Author" "encodefrom##auth"}{...}
{viewerjumpto "Remarks" "encodefrom##rem"}{...}
{title:Title}

{phang}
{bf:encodefrom} {hline 2} Encode variable with values and value labels
specified in an external crosswalk.

{title:Table of contents}

	{help encodefrom##syn:Syntax}
	{help encodefrom##des:Description}
	{help encodefrom##opt:Options}
	{help encodefrom##exa:Examples}
	{help encodefrom##auth:Author}
	{help encodefrom##rem:Remarks}

{marker syn}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:encodefrom} {help varname} {cmd:using} {help filename}
{cmd:,} {opt filetype(string)} {opt raw(string)} {opt clean(string)} {opt label(string)}
[{it:options}]

{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}

{syntab:Main}

{synopt:{opt raw(string)}}column in external crosswalk that contains values of {it:varname} to be encoded{p_end}
{synopt:{opt clean(string)}}column in external crosswalk that contains clean values (e.g. 1, 2, 3, ...) of {it:varname} {p_end}
{synopt:{opt label(string)}}column in external crosswalk that contains clean value labels{p_end}

{syntab:Crosswalk}

{synopt:{opt filetype(excel|delimited|stata)}}file type of external crosswalk{p_end}
{synopt:{opt sheet(string)}}sheet name if the external crosswalk is an Excel workbook{p_end}
{synopt:{opt delimiters("chars")}}{it:chars} used as delimiters in the external crosswalk;
by default, "\t" or "," {p_end}

{syntab:Other}

{synopt:{opt label_name(string)}}name of value label; defaults to {it:varname}{p_end}
{synopt:{opt noallow_missing}}prohibits {opt clean} column in external crosswalk to have missing values{p_end}
{synopt:{opt caseignore}}ignores capitalization when matching values of {it:varname} with
{opt raw} values in external crosswalk{p_end}

{synoptline}



{marker des}{...}
{title:Description}

{pstd}
{cmd:encodefrom} encodes {it:varname} using the values and value labels stored in an
external crosswalk. Storing the mapping from raw values to clean values in a crosswalk
helps users align a variable across data sets that use different codes for the
same values. 


{marker opt}{...}
{title:Options}

{dlgtab:Main}

{phang}
{opt raw(string)} specifies the column that contains the current values of {it:varname}. 

{phang}
{opt clean(string)} specifies the column that contains clean values of {it:varname}.
This will often be populated with sequential ascending integers (e.g. 1, 2, 3, 4...).
By default, this column can include missing values. To refuse {it:using} files with missing {opt clean}
values associated with non-missing {opt raw} values, the option {opt noallow_missing} must be specified.

{phang}
{opt label(string)} specifies the column that contains clean value labels.

{dlgtab:Crosswalk}

{phang}
{opt filetype(excel|delimited|stata)} specifies the file type
of the external crosswalk that contains the raw and clean values of {it:varname}. 
The {it:excel} option is for Excel workbooks with file extensions {bf:.xls}
and {bf:.xlsx}. The {it:delimited} option supports {bf:.csv} and other character-delimited
text files. The {it:stata} option is for Stata-format datasets with the {bf:.dta} extension.

{phang}
{opt sheet(string)} specifies a sheet name for the crosswalk in an Excel workbook.
This option can only be used with {opt filetype(excel)}. Following {help import excel},
the program defaults to using the workbook's first sheet if no sheet is specified.

{phang}
{opt delimiters("chars")} specifies the delimiter that separates values in the external
crosswalk. This option can only be used with the delimited filetype option. For {bf:.csv} crosswalks
the syntax is {opt delimiters(",")}. For tab-delimited crosswalks the syntax is {opt delimiters("\t")},
and for whitespace-delimited text it is {opt delimiters("whitespace")}. Following {help import delimited},
if no delimiter is specified, Stata will check if the file is delimited by tabs or commas by default.

{dlgtab:Other}

{phang}
{opt label_name(string)} specifies the value label name of {it:varname}. If no name is 
specified for the value label, the default is to use the variable name as the 
value label name.

{phang}
{opt noallow_missing} prohibits a non-missing {opt clean} value to be associated
with a missing {opt raw} value in the crosswalk. 

{phang}
{opt caseignore} ignores capitalization when matching {it:varname} values 
with {opt raw} values in the crosswalk.


{marker exa}{...}
{title:Examples}

{phang}{cmd:. encodefrom var1 using codes.xlsx, filetype(excel) raw(old_values) clean(new_values) label(label)}{p_end}
{phang}{cmd:. encodefrom var1 using codes.csv, filetype(delimited) delimiters(",") raw(old_values) clean(new_values) label(label)}{p_end}

{marker auth}{...}
{title:Author}

{phang}Sally Hudson{p_end}
{phang}E-mail: sally.hudson@virginia.edu{p_end}
{phang}GitHub: https://github.com/slhudson{p_end}

{marker rem}{...}
{title:Remarks}

{pstd}
This program was developed through work at the School Effectiveness and 
Inequality Initative at MIT. Thanks are due to the many SEII research 
assistants who used and refined it over the years, especially Tyler Hoppenfeld,
Sookyo Jeong, and Alicia Weng. If you encounter any bugs or have suggestions 
for additional features, please feel free to submit a pull request on GitHub.
