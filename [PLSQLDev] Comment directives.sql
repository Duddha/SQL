-- PL/SQL Developers's Comment directives
/*
You can use special directives in a comment before each SQL statement to control aspects of the query. For example:
*/
-- Tab=All managers
SELECT * FROM emp WHERE job = 'MANAGER';

-- Tab=Department 10
SELECT * FROM emp WHERE deptno = 10;

/*
  This Tab directive controls the description of the result set tab page. 
  The following paragraph describes all other directives. The other available directives are as follows.
*/

/*
Excel=<Filename>
  Predefines the filename when exporting to Excel. You can use environment variables for the filename. 
  For example: 
*/
-- Excel=C:\Excel\test_%date%.xls

/*
CSV=<Filename> 
  Predefines the filename when exporting in CSV format. 
  You can use environment variables for the filename. 
  For example: 
*/
-- CSV=C:\Excel\test_%date%.csv

/*
Records=[All | Page | <n>]
  Controls the number of initially fetched records. 
  Specify All to fetch all records, Page to fetch one page of records (depends on the window height), or the exact number of records. 
  The following example will initially fetch 1000 records: 
*/
-- Records=1000

/*
Totals=[<Mode>:]<Column>[,<Column>][,<Mode>:<Column>[,<Column>]]
  Displays column totals for the given column(s). 
  By default the mode is Sum, but you can also specify Count, Avg, Min and Max. 
  After specifying a mode you can specify one or more columns to which it will apply. 
  The following example will display the averages of the sal and comm columns and the count of the mgr column: 
*/
-- Totals=avg:sal,comm,count:mgr

/*
AltRowColor=[<RRGGBB> | <Name>]
  Controls the alternate row color. 
  You can specify a name (e.g. Gray) or the hexadecimal RGB value. 
  The following example displays a light purple alternate row color: 
*/
-- AltRowColor=FFEEFF

/*
-- NoFormat Start
  ...
-- NoFormat End  
  Указание Beautifier-у не форматировать участок между Start-ом и End-ом
  Например:
*/

-- NoFormat Start
SELECT fam_u, f_Name_u
      ,s_name_u
  FROM qwerty.sp_rb_fio
-- NoFormat End
