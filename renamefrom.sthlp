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
{bf:renamefrom} {hline 2} rename and label variables using an external file

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
{cmd:,} {opt name_old(string)} {opt name_new(string)} {opt filetype(excel|delimited|stata)} 
[{it:options}]


{synoptset 20 tabbed}{...}
{synopthdr}
{synoptline}
{syntab:Main}


{synopt:{opt filetype(excel|delimited|stata)}}file type of external file with new variable names{p_end}
{synopt:{opt name_old(string)}}specifies column of old variables to be renamed{p_end}
{synopt:{opt name_new(string)}}specifies column of new variable names to be used{p_end}
{synopt:{opt delimiters(chars)}}use {it:chars} as delimiters; by default, tabs or commas{p_end}
{synopt:{opt sheet(string)}}specifies sheet within excel document using{p_end}
{synopt:{opt if(exp)}}restrict renaming of variables based on {it:exp}{p_end}
{synopt:{opt label(string)}}specifies column with new labels{p_end}
{synopt:{opt keepx}}keeps variables not specified in external file; overrided by dropx{p_end}
{synopt:{opt dropx}}drops variables not specified in external file{p_end}
{synopt:{opt keeplabel}}keeps old variable label if no label is specified in external file{p_end}
{synopt:{opt namelabel}}makes old variable name the label if no label is specified in external file{p_end}
{synopt:{opt caseignore}}ignores capitalization when matching variables with variable names in the name_old column{p_end}
{synoptline}



{marker des}{...}
{title:Description}

{pstd}
{cmd:renamefrom} renames and relabels variables in memory according to the external spreadsheet specified by {it:using}.


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
{opt name_old(string)} specifies the column containing the old variables to be renamed. 
If there are variables in source data that are not specified in external spreadsheet, you must 
use either option {opt dropx} or {opt keepx}.

{phang}
{opt name_new(string)} specifies column of new variable names to be used.

{phang}
{opt delimiters(chars)} chooses the delimiter used to separate the values of an
external delimited file. Can only be used with the delimited filetype option. For
example, to specify commas, tabs, and whitespace as delimiters, type {opt delimiters(,)},
{opt delimiters(\t)}, and {opt delimiters{whitespace)}, respectively. If no
delimiter is chosen, Stata will by default check if the file is delimited by tabs or
commas. 

{phang}
{opt sheet(string)} specifies which sheet within excel document to use,
and can only be used with {opt filetype(excel)}.  
The default behavior is to use the first sheet within the excel spreadsheet, 
following the default behavior of {import excel}

{phang}
{opt if(exp)} restricts renaming of variables based on the expression {it:exp}. 
This expression can involve values within the external spreadsheet. 

{phang}
{opt label(string)} specifies column with new labels. If no label is specified for a
 variable, the default behavior is to not have a label for the variable. This behavior
 is modified by the options namelabel and keeplabel. 

{phang}
{opt keepx} requests that any variables not specified by the name_old
 column are left unchanged.

{phang}
{opt dropx} drops variables not specified in the name_old column.

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
names in the name_old column.


{marker rem}{...}
{title:Remarks}

{pstd}
This code is still in beta stage.  If you encounter any bugs or have suggestions for 
improvement, please feel free to contact the developers.  If you want to take a stab at 
implementing an improvement, let us know -- the code is hosted on github, and we're happy to share!

BREAK----EVERYTHING AFTER THIS IS PART OF EXAMPLE FILE, NOT REAL HELP FILE


{marker exa}{...}
{title:Examples}

{phang}{cmd:. whatever mpg weight}{p_end}

{phang}{cmd:. whatever mpg weight, meanonly}{p_end}
