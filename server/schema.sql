-- ---
-- Database 'sdc_qna'
-- ---

-- ---
-- Table 'questions'
--
-- ---

DROP TABLE IF EXISTS questions cascade;

CREATE TABLE questions (
  id SERIAL,
  product_id INTEGER NOT NULL,
  question_body TEXT,
  question_date BIGINT,
  asker_name VARCHAR(255),
  asker_email VARCHAR(255),
  reported BOOLEAN DEFAULT FALSE,
  question_helpfulness INTEGER DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE INDEX product_id_idx on questions(product_id);

-- ---
-- Table 'answers'
--
-- ---

DROP TABLE IF EXISTS answers cascade;

CREATE TABLE answers (
  id SERIAL,
  question_id INTEGER NOT NULL,
  answer_body TEXT,
  answer_date BIGINT,
  answerer_name VARCHAR(255),
  answerer_email VARCHAR(255),
  reported BOOLEAN DEFAULT FALSE,
  answer_helpfulness INTEGER DEFAULT 0,
  PRIMARY KEY (id)
);

CREATE INDEX question_id_idx on answers(question_id);

-- ---
-- Table 'photos'
--
-- ---

DROP TABLE IF EXISTS photos cascade;

CREATE TABLE photos (
  id SERIAL,
  answer_id INTEGER NOT NULL,
  url VARCHAR(255),
  PRIMARY KEY (id)
);

CREATE INDEX answer_id_idx on photos(answer_id);

-- ---
-- Foreign Keys
-- ---

ALTER TABLE answers ADD FOREIGN KEY (question_id) REFERENCES questions (id);
ALTER TABLE photos ADD FOREIGN KEY (answer_id) REFERENCES answers (id);

-- ---
-- Populate tables
-- ---

-- COPY questions
-- FROM '/Users/tjspitz/Coding/HackReactor/RFP_2212/rfp2212-sdc-doritos/server/dataImports/questions.csv'
-- DELIMITER ','
-- CSV HEADER;

-- COPY answers
-- FROM '/Users/tjspitz/Coding/HackReactor/RFP_2212/rfp2212-sdc-doritos/server/dataImports/answers.csv'
-- DELIMITER ','
-- CSV HEADER;

-- COPY photos
-- FROM '/Users/tjspitz/Coding/HackReactor/RFP_2212/rfp2212-sdc-doritos/server/dataImports/answers_photos.csv'
-- DELIMITER ','
-- CSV HEADER;

-- ---
-- TRANSFORM DATES
-- ---
-- ALTER TABLE questions
-- ALTER COLUMN question_date TYPE timestamp USING (
--   to_timestamp(question_date/1000)
-- );

-- ALTER TABLE answers
-- ALTER COLUMN answer_date TYPE timestamp USING (
--   to_timestamp(answer_date/1000)
-- );

-- ALTER TABLE questions
-- ALTER COLUMN question_date SET DEFAULT CURRENT_TIMESTAMP;

-- ALTER TABLE answers
-- ALTER COLUMN answer_date SET DEFAULT CURRENT_TIMESTAMP;
-- ---

-- ---
-- BATCH FILE
-- ---
-- psql -U tjspitz -d sdc_qna -a -f server/schema.sql

-- ---
-- NOTES
-- ---
-- 1) altered the 'reported' column in 'questions' and
-- 'answers' to have DEFAULT FALSE via CLI
-- didn't want to recreate tables and repopulate
-- via editing this file & running batch again
-- 2) might alter 'date' column to accept transformed timestamps
-- if performance is an issue
-- ---
