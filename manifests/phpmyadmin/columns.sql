
-- This searches the specified table for the given search value in compatible text columns

SET @search_value = 't3.markitectos.com';
SET @table_name = 'aprendeapintarconoleo_composts';

Constructing the dynamic SQL, filtering by compatible data types
SET @sql = (
    SELECT GROUP_CONCAT(CONCAT('`', COLUMN_NAME, '` LIKE ''%', @search_value, '%''') SEPARATOR ' OR ')
    FROM INFORMATION_SCHEMA.COLUMNS 
    WHERE TABLE_NAME = @table_name AND DATA_TYPE IN ('varchar', 'text', 'mediumtext', 'longtext')
);

SET @final_sql = CONCAT('SELECT * FROM ', @table_name, ' WHERE ', @sql);

-- Debug: Print the final SQL query
-- SELECT @final_sql;

-- Preparing and executing the statement
PREPARE stmt FROM @final_sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;





-----

-- This replace all the values from old_domain to new_domain in a specific table and column

SET @old_domain = 't3.markitectos.com';
SET @new_domain = 'aprendeapintarconoleo.com';
SET @table_name = 'aprendeapintarconoleo_composts';
SET @table_column = 'pinged';

SET @sql = CONCAT('UPDATE ', @table_name, ' SET ', @table_column, ' = REPLACE(', @table_column, ', ?, ?) WHERE ', @table_column, ' LIKE ?');

PREPARE stmt FROM @sql;
SET @old_domain_like = CONCAT('%', @old_domain, '%');

EXECUTE stmt USING @old_domain, @new_domain, @old_domain_like;
DEALLOCATE PREPARE stmt;




