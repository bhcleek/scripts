1,/^INSERT INTO/-1 d
1 s/^INSERT INTO \([^(]*\)(\([^)]*\)) VALUES\s*\(.*$\)/SET IDENTITY_INSERT \1ON\r\rMERGE INTO \1AS Target\rUSING ( VALUES\r	\3,\r) AS Source (\2)\rON Target.ID = Source.ID\rWHEN MATCHED\r	THEN UPDATE SET\r\2\rWHEN NOT MATCHED BY TARGET\r	THEN INSERT (\2) VALUES (\r\2)\rWHEN NOT MATCHED BY SOURCE\r	THEN DELETE\r\rSET IDENTITY_INSERT \1OFF\rCOMMIT TRANSACTION\r/
g/WHEN MATCHED/+2 s/\(\[[^\]]*]\)/Target.\1 = Source.\1/g
g/WHEN MATCHED/+1 j
g/WHEN NOT MATCHED BY TARGET/+2 s/\(\[[^\]]*]\)/Source.\1/g
g/WHEN NOT MATCHED BY TARGET/+1 j!
g/^INSERT INTO/ s/.\{-1,}VALUES\s*//
g/^(/ s/$/,/
g/^(/. m/^) AS Source/-1
g/^(/ s/.*/	&/
g/^) AS Source/-1 s/,$//
$d
