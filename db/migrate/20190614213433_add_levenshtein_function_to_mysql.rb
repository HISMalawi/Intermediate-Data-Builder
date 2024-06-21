# frozen_string_literal: true

class AddLevenshteinFunctionToMysql < ActiveRecord::Migration[5.2]
  def change
<<<<<<< HEAD
    ActiveRecord::Base.connection.execute <<~QUERY
          CREATE DEFINER=`root`@`localhost` FUNCTION `levenshtein`( s1 VARCHAR(255), s2 VARCHAR(255), dam BOOL) RETURNS int(11)
          DETERMINISTIC
          BEGIN
          DECLARE s1_len, s2_len, i, j, c, c_temp, cost INT;
          DECLARE s1_char, s2_char CHAR;
          -- max strlen=255
          DECLARE cv0, cv1, cv2 VARBINARY(256);
          SET s1_len = CHAR_LENGTH(s1), s2_len = CHAR_LENGTH(s2), cv1 = 0x00, j = 1, i = 1, c = 0;
          IF s1 = s2 THEN
              RETURN 0;
          ELSEIF s1_len = 0 THEN
              RETURN s2_len;
          ELSEIF s2_len = 0 THEN
              RETURN s1_len;
          ELSE
              WHILE j <= s2_len DO
                  SET cv1 = CONCAT(cv1, UNHEX(HEX(j))), j = j + 1;
              END WHILE;
              WHILE i <= s1_len DO
                  SET s1_char = SUBSTRING(s1, i, 1), c = i, cv0 = UNHEX(HEX(i)), j = 1;
                  WHILE j <= s2_len DO
                      SET c = c + 1;
                      SET s2_char = SUBSTRING(s2, j, 1);
                      IF s1_char = s2_char THEN
                          SET cost = 0; ELSE SET cost = 1;
                      END IF;
                      SET c_temp = CONV(HEX(SUBSTRING(cv1, j, 1)), 16, 10) + cost;
                      IF c > c_temp THEN SET c = c_temp; END IF;
                      SET c_temp = CONV(HEX(SUBSTRING(cv1, j+1, 1)), 16, 10) + 1;
                      IF c > c_temp THEN SET c = c_temp; END IF;
                      IF dam THEN
                          IF i>1 AND j>1 AND s1_char = SUBSTRING(s2, j-1, 1) AND s2_char = SUBSTRING(s1, i-1, 1) THEN
                              SET c_temp = CONV(HEX(SUBSTRING(cv2, j-1, 1)), 16, 10) + 1;
                              IF c > c_temp THEN SET c = c_temp; END IF;
                          END IF;
                      END IF;
                      SET cv0 = CONCAT(cv0, UNHEX(HEX(c))), j = j + 1;
                  END WHILE;
                  IF dam THEN SET CV2 = CV1; END IF;
                  SET cv1 = cv0, i = i + 1;
              END WHILE;
          END IF;
          RETURN c;
      END
    QUERY
=======
    # ActiveRecord::Base.connection.execute <<~QUERY
    #       CREATE DEFINER=`root`@`localhost` FUNCTION `levenshtein`( s1 VARCHAR(255), s2 VARCHAR(255), dam BOOL) RETURNS int(11)
    #       DETERMINISTIC
    #       BEGIN
    #       DECLARE s1_len, s2_len, i, j, c, c_temp, cost INT;
    #       DECLARE s1_char, s2_char CHAR;
    #       -- max strlen=255
    #       DECLARE cv0, cv1, cv2 VARBINARY(256);
    #       SET s1_len = CHAR_LENGTH(s1), s2_len = CHAR_LENGTH(s2), cv1 = 0x00, j = 1, i = 1, c = 0;
    #       IF s1 = s2 THEN
    #           RETURN 0;
    #       ELSEIF s1_len = 0 THEN
    #           RETURN s2_len;
    #       ELSEIF s2_len = 0 THEN
    #           RETURN s1_len;
    #       ELSE
    #           WHILE j <= s2_len DO
    #               SET cv1 = CONCAT(cv1, UNHEX(HEX(j))), j = j + 1;
    #           END WHILE;
    #           WHILE i <= s1_len DO
    #               SET s1_char = SUBSTRING(s1, i, 1), c = i, cv0 = UNHEX(HEX(i)), j = 1;
    #               WHILE j <= s2_len DO
    #                   SET c = c + 1;
    #                   SET s2_char = SUBSTRING(s2, j, 1);
    #                   IF s1_char = s2_char THEN
    #                       SET cost = 0; ELSE SET cost = 1;
    #                   END IF;
    #                   SET c_temp = CONV(HEX(SUBSTRING(cv1, j, 1)), 16, 10) + cost;
    #                   IF c > c_temp THEN SET c = c_temp; END IF;
    #                   SET c_temp = CONV(HEX(SUBSTRING(cv1, j+1, 1)), 16, 10) + 1;
    #                   IF c > c_temp THEN SET c = c_temp; END IF;
    #                   IF dam THEN
    #                       IF i>1 AND j>1 AND s1_char = SUBSTRING(s2, j-1, 1) AND s2_char = SUBSTRING(s1, i-1, 1) THEN
    #                           SET c_temp = CONV(HEX(SUBSTRING(cv2, j-1, 1)), 16, 10) + 1;
    #                           IF c > c_temp THEN SET c = c_temp; END IF;
    #                       END IF;
    #                   END IF;
    #                   SET cv0 = CONCAT(cv0, UNHEX(HEX(c))), j = j + 1;
    #               END WHILE;
    #               IF dam THEN SET CV2 = CV1; END IF;
    #               SET cv1 = cv0, i = i + 1;
    #           END WHILE;
    #       END IF;
    #       RETURN c;
    #   END
    # QUERY
>>>>>>> a21f366acf67dc3014e7e0d13e087d72277d2e8d
  end
end
