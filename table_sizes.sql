:setvar prefix ""

CREATE TABLE #tables (TableName VARCHAR(255), rows INT, reserved VARCHAR(255), data VARCHAR(255), index_size VARCHAR(255), unused VARCHAR(255))

EXEC sp_msforeachtable @command1 = 'INSERT INTO #tables exec sp_spaceused [?]', @whereand = 'AND object_name(object_id) LIKE ''$(prefix)%'''

SELECT SUM( CAST( SUBSTRING( reserved, 1, LEN(reserved) - 3 ) AS INT ) ) AS reserved_total, SUM( CAST( SUBSTRING( data, 1, LEN(data) - 3 ) AS INT ) ) AS data_total, SUM( CAST( SUBSTRING( index_size, 1, LEN(index_size) - 3 ) AS INT ) ) AS index_size_total, SUM( CAST( SUBSTRING( unused, 1, LEN(unused) - 3 ) AS INT ) ) AS unused_total
FROM #tables

SELECT *
FROM #tables

DROP TABLE #tables
