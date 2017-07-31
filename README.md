renamefrom and encodefrom: Rename and encode variables using an external crosswalk
--------------------------------

These are particularly useful for resolving discrepancies across data sets before merging or appending the data sets. 

`renamefrom` is a Stata program which renames and labels variables using values stored in an external crosswalk. It can sort out inconsistencies in variable names across data sets. `encodefrom` encodes variables with values and value labels stored in an external crosswalk. It can help align data sets that use different codes for the same values of a given variable. 

They take crosswalks in the form of Excel workbooks (.xlsx), character-delimited files (such as .csv), and Stata-format datasets (.dta). 

### Installation ###
Open Stata and install the programs from the SSC repository by running the commands
```
ssc install renamefrom
ssc install encodefrom
```

After installing the files, you can read the documentation by running `help renamefrom` and `help encodefrom` in Stata. 

