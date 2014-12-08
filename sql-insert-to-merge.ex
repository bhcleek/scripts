" delete all the lines before the first INSERT
1,/^INSERT INTO/-1 d
" change the first INSERT into a MERGE statement template that will be the basis for all commands that follow
1 s/^INSERT INTO \([^(]*\)(\([^)]*\)) VALUES\s*\(.*$\)/SET IDENTITY_INSERT \1ON\r\rMERGE INTO \1AS Target\rUSING ( VALUES\r	\3,\r) AS Source (\2)\rON Target.ID = Source.ID\rWHEN MATCHED\r	THEN UPDATE SET\r\2\rWHEN NOT MATCHED BY TARGET\r	THEN INSERT (\2) VALUES (\r\2)\rWHEN NOT MATCHED BY SOURCE\r	THEN DELETE\r;\r\rSET IDENTITY_INSERT \1OFF\r/
" modify the MERGE statement template's UPDATE portion to set fields correctly
g/WHEN MATCHED/+2 s/\(\[[^\]]*]\)/Target.\1 = Source.\1/g
" join the line following WHEN MATCHED lines with the WHEN MATCHED line
g/WHEN MATCHED/+1 j
" change table value constructors to reference the Source table
g/WHEN NOT MATCHED BY TARGET/+2 s/\(\[[^\]]*]\)/Source.\1/g
" join (without space delimiters) the WHEN NOT MATCHED BY TARGET line and the line that follows it
g/WHEN NOT MATCHED BY TARGET/+1 j!
" prune everything from INSERT statements except for row expressions
g/^INSERT INTO/ s/.\{-1,}VALUES\s*//
" append a comma to the end of all lines that are row expressions
g/^(/ s/$/,/
" move all row expression lines into the table value constructor
g/^(/. m/^) AS Source/-1
" indent all row expressions
g/^(/ s/.*/	&/
" remove the trailing comma from the last row expression in the table value constructor
g/^) AS Source/-1 s/,$//
" delete the last line
$d
