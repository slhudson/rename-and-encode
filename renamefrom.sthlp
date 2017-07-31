{smcl}
{* *! version 1.2.0  12jun2017}{...}
{findalias asfradohelp}{...}
{vieweralsosee "" "--"}{...}
{vieweralsosee "[R] help" "help help"}{...}
{viewerjumpto "Syntax" "renamefrom##syn"}{...}
{viewerjumpto "Description" "renamefrom##des"}{...}
{viewerjumpto "Options" "renamefrom##opt"}{...}
{viewerjumpto "Remarks" "renamefrom##rem"}{...}
{viewerjumpto "Examples" "renamefrom##exa"}{...}
{title:Title}

{phang}
{bf:renamefrom} {hline 2} Names and labels variables using values stored in an external crosswalk.

{title:Table of contents}

	{help renamefrom##syn:Syntax}
	{help renamefrom##des:Description}
	{help renamefrom##opt:Options}
	{help renamefrom##rem:Remarks}
	{help renamefrom##exa:Examples}
	
{marker syn}{...}
{title:Syntax}

{p 8 17 2}
{cmdab:renamefrom}
{cmd:using} {it: filename}
{cmd:,} {opt filetype(string)} {opt raw(string)} {opt clean(string)}
[{it:options}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}

{syntab:Main}
{synopt:{opt raw(string)}}column in external crosswalk that specifies existing variable names in memory{p_end}
{synopt:{opt clean(string)}}column in external crosswalk that specifies clean variable names{p_end}
{synopt:{opt label(string)}}column in external crosswalk that specifies clean variable labels{p_end}

{syntab:Crosswalk}
{synopt:{opt filetype(excel|delimited|stata)}}file type of external crosswalk{p_end}
{synopt:{opt sheet(string)}}sheet name if the external crosswalk is an Excel workbook{p_end}
{synopt:{opt delimiters("chars")}}{it:chars} used as delimiters in the external crosswalk; by default, "\t" or "," {p_end}

{syntab:Missing Values}
{synopt:{opt keepx}}keeps variables in the master data if no match in the external crosswalk is found{p_end}
{synopt:{opt dropx}}drops variables in the master data if no match in the external crosswalk is found{p_end}
{synopt:{opt keeplabel}}keeps variable label in the master data if no label is specified in the external crosswalk{p_end}
{synopt:{opt keeplabel}}labels variables with variable names if no label is specified in the external crosswalk{p_end}

{syntab:Other}
{synopt:{opt if(`"exp"')}}restricts renaming to a subset of values in the external crosswalk{p_end}
{synopt:{opt caseignore}}ignores capitalization when matching variables with raw names{p_end}

{synoptline}



{marker des}{...}
{title:Description}

{pstd}
{cmd:renamefrom} names and labels the variables in memory using values stored in an external crosswalk.  Storing the mapping from raw names to clean names in a crosswalk helps users align names across data sets and spot discrepancies between files.


{marker opt}{...}
{title:Options}
// SH: Can you reorganize these to match the columns I had above?

{dlgtab:Main}

{phang}
{opt filetype(excel|delimited|stata)} specifies the file type
of the external crosswalk that contains the raw and clean variable names. 
The {it:excel} option is for Excel workbooks with file extensions {bf:.xls}
and {bf:.xlsx}. The {it:delimited} option supports .csv and other character-delimited text files. The {it:stata}
option is for Stata-format datasets with the {bf:.dta} extension. 

{phang}
{opt raw(string)} specifies the column that contains the names of variables in memory. 
If there are variables in memory that are not included in the external crosswalk, the user must 
specify either the {opt dropx} or {opt keepx} option.

{phang}
{opt clean(string)} specifies the column that contains clean variable names.

{phang}
{opt delimiters("chars")} chooses the delimiter used to separate the values of an
external delimited file. Can only be used with the delimited filetype option. For
example, to specify commas, tabs, and whitespace as delimiters, type {opt delimiters(",")},
{opt delimiters("\t")}, and {opt delimiters{"whitespace")}, respectively. If no
delimiter is chosen, Stata will by default check if the file is delimited by tabs or
commas. 

{phang}
{opt sheet(string)} specifies which sheet within excel document to use,
and can only be used with {opt filetype(excel)}.  
The default behavior is to use the first sheet within the excel spreadsheet, 
following the default behavior of {import excel}

{phang}
{opt if(`"exp"')} restricts renaming of variables based on the expression {it:exp}. 
The expression can involve values within the external spreadsheet, in which case 
it needs to enclosed by the compound double quotes `" "'. 

{phang}
{opt label(string)} specifies column with new labels. If no label is specified for a
 variable, the default behavior is to not have a label for the variable. This behavior
 is modified by the options namelabel and keeplabel. 

{phang}
{opt keepx} requests that any variables not specified by the raw
 column are left unchanged.

{phang}
{opt dropx} drops variables not specified in the raw column.

{phang}
{opt keeplabel} preserves the old variable label if a new label is not specified
for the variable. 

{phang}
{opt namelabel} makes the old variable name the new variable label, if a new
label is not specified for the variable. If {opt keeplabel} is also specified,
then namelabel will only label a variable with its old name if no new label was
specified {it:and} the variable did not have an old label.
 
{phang}
{opt caseignore} ignores capitalization when matching variables with variable 
names in the raw column.

{marker exa}{...}
{title:Examples}

{phang}{cmd:. renamefrom using variables.xlsx, filetype(excel) raw(old_name) clean(new_name) label(label)}{p_end}
{phang}{cmd:. renamefrom using variables.csv, filetype(delimited) delimiters(",") raw(old_name) clean(new_name) label(label)}{p_end}

{title:Author}

{phang}Sally Hudson{p_end}
{phang}E-mail: sally.hudson@virginia.edu{p_end}
{phang}GitHub: https://github.com/slhudson{p_end}

{title:Remarks}

{pstd}
SH: Can you figure out what I'm doing wrong with this paragraph?  It's not quite formatting right...
{phang}This program was developed through work at the School Effectiveness and Inequality Initative at MIT. Thanks are due to the many SEII research assistants who used and refined it over the years, especially Tyler Hoppenfeld, Sookyo Jeong, and Alicia Weng. If you encounter any bugs or have suggestions for additional features, please feel free to submit a pull request on GitHub.{p_end}


