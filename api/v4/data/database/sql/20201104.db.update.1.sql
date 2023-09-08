
-- -----------------------------------------------------------------------------------------
-- To solve "ERROR 1419: You do not have the SUPER privilege and binary logging is enabled"
-- creating a function in Azure MySQL, enable the following server parameter is required: 
-- log_bin_trust_function_creators=1
-- References: 
-- https://docs.microsoft.com/en-us/azure/mysql/howto-troubleshoot-common-errors
-- https://docs.microsoft.com/en-us/azure/mysql/concepts-limits

-- -----------------------------------------------------------------------------------------

DELIMITER //
CREATE FUNCTION uuid_v4()
    RETURNS CHAR(36)
    NO SQL  
BEGIN
    -- 1th and 2nd block are made of 6 random bytes
    SET @h1 = HEX(RANDOM_BYTES(4));
    SET @h2 = HEX(RANDOM_BYTES(2));

    -- 3th block will start with a 4 indicating the version, remaining is random
    SET @h3 = SUBSTR(HEX(RANDOM_BYTES(2)), 2, 3);

    -- 4th block first nibble can only be 8, 9 A or B, remaining is random
    SET @h4 = CONCAT(HEX(FLOOR(ASCII(RANDOM_BYTES(1)) / 64) + 8),
                SUBSTR(HEX(RANDOM_BYTES(2)), 2, 3));

    -- 5th block is made of 6 random bytes
    SET @h5 = HEX(RANDOM_BYTES(6));

    -- Build the complete UUID
    RETURN LOWER(CONCAT(
        @h1, '-', @h2, '-4', @h3, '-', @h4, '-', @h5
    ));
END//
