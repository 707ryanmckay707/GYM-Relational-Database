-- USE <your database name here>;

DROP TABLE IF EXISTS GYM_Trains;
DROP TABLE IF EXISTS GYM_Excercise;
DROP TABLE IF EXISTS GYM_Charge;
DROP TABLE IF EXISTS GYM_Stats;
DROP TABLE IF EXISTS GYM_Workout_Routine;
DROP TABLE IF EXISTS GYM_Trainer;
DROP TABLE IF EXISTS GYM_Member;

CREATE TABLE GYM_Member
(
    id INT,
    name VARCHAR(255),
    email VARCHAR(320),
    PRIMARY KEY(id), 
    UNIQUE(email)
);

CREATE TABLE GYM_Trainer
(
    id INT,
    name VARCHAR(255),
    email VARCHAR(320),
    rate NUMERIC(8,2),
    PRIMARY KEY(id),
    UNIQUE(email)
);

CREATE TABLE GYM_Workout_Routine
(
    member_id INT,
    name VARCHAR(255),
    PRIMARY KEY(member_id, name),
    FOREIGN KEY(member_id) REFERENCES GYM_Member(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GYM_Stats
(
    member_id INT,
    time_stamp TIMESTAMP,
    weight numeric(7,2),
    systolic_pressure numeric(5,2),
    diastolic_pressure numeric(5,2),
    PRIMARY KEY(member_id, time_stamp),
    FOREIGN KEY(member_id) REFERENCES GYM_Member(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GYM_Charge
(
    trainer_id INT,
    member_id INT,
    time_stamp TIMESTAMP,
    amount NUMERIC(9,2),
    PRIMARY KEY(trainer_id, member_id, time_stamp),
    FOREIGN KEY(trainer_id) REFERENCES GYM_Trainer(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(member_id) REFERENCES GYM_Member(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GYM_Excercise
(
    member_id INT,
    name VARCHAR(255),
    type VARCHAR(100),
    reps SMALLINT,
    PRIMARY KEY(member_id, name, type, reps),
    FOREIGN KEY(member_id, name) REFERENCES GYM_Workout_Routine(member_id, name)
        ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE GYM_Trains
(
    trainer_id INT,
    member_id INT,
    PRIMARY KEY (trainer_id, member_id),
    FOREIGN KEY(trainer_id) REFERENCES GYM_Trainer(id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY(member_id) REFERENCES GYM_Member(id)
        ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO GYM_Member VALUES (1, 'Bryan Stevens', 'stevensb@gmail.com');
INSERT INTO GYM_Member VALUES (2, 'Steven George', 'strongman45@yahoo.com');
INSERT INTO GYM_Member VALUES (3, 'Mike Molasses', 'cooldude64@yahoo.com');
INSERT INTO GYM_Member VALUES (4, 'Roger Sideways', 'thesidewaylife@gmail.com');
INSERT INTO GYM_Member VALUES (5, 'Michelle Moore', 'mmoore@gmail.com');

INSERT INTO GYM_Trainer VALUES (1, 'Buff Johnson', 'supportyourself@gmail.com', 40);
INSERT INTO GYM_Trainer VALUES (2, 'Stacy Leeland', 'stacylee@gmail.com', 60);
INSERT INTO GYM_Trainer VALUES (3, 'Tracy Davis', 'tracydavis@yahoo.com', 30);
INSERT INTO GYM_Trainer VALUES (4, 'Miles Travis', 'mtravis@yahoo.com', 35);
INSERT INTO GYM_Trainer VALUES (5, 'Tyler Conway', 'tconway@gmail.com', 55);

INSERT INTO GYM_Workout_Routine VALUES (1, 'Monday Workout');
INSERT INTO GYM_Workout_Routine VALUES (1, 'Wednesday Workout');
INSERT INTO GYM_Workout_Routine VALUES (2, 'Arm Workout');
INSERT INTO GYM_Workout_Routine VALUES (2, 'Leg Workout');
INSERT INTO GYM_Workout_Routine VALUES (3, 'Midweek Workout');

INSERT INTO GYM_Excercise VALUES (1, 'Monday Workout', 'Pushups', 20);
INSERT INTO GYM_Excercise VALUES (1, 'Monday Workout', 'Situps', 15);
INSERT INTO GYM_Excercise VALUES (1, 'Wednesday Workout', 'Jumping Jacks', 50);
INSERT INTO GYM_Excercise VALUES (1, 'Wednesday Workout', 'Tricep Curls', 30);
INSERT INTO GYM_Excercise VALUES (1, 'Wednesday Workout', 'Bicep Curls', 25);
INSERT INTO GYM_Excercise VALUES (2, 'Arm Workout', 'Tricep Curls', 50);
INSERT INTO GYM_Excercise VALUES (2, 'Arm Workout', 'Bicep Curls', 50);

INSERT INTO GYM_Charge VALUES (2, 1, '2021-03-01 10:10:05', 60);
INSERT INTO GYM_Charge VALUES (2, 2, '2021-03-01 11:10:15', 45);
INSERT INTO GYM_Charge VALUES (3, 3, '2021-03-03 13:25:07', 30);
INSERT INTO GYM_Charge VALUES (5, 1, '2021-03-03 13:30:00', 55);
INSERT INTO GYM_Charge VALUES (1, 4, '2021-03-04 08:15:45', 80);

INSERT INTO GYM_Stats VALUES (1, '2021-03-07 12:10:35', 160, 122, 79);
INSERT INTO GYM_Stats VALUES (2, '2021-03-07 12:15:30', 158, 115, 75);
INSERT INTO GYM_Stats VALUES (3, '2021-03-08 07:05:29', 180, 116, 78);
INSERT INTO GYM_Stats VALUES (1, '2021-03-08 12:12:06', 159, 120, 77);
INSERT INTO GYM_Stats VALUES (2, '2021-03-08 12:14:00', 160, 116, 75);

INSERT INTO GYM_Trains VALUES(2, 1);
INSERT INTO GYM_Trains VALUES(2, 2);
INSERT INTO GYM_Trains VALUES(3, 3);
INSERT INTO GYM_Trains VALUES(5, 1);
INSERT INTO GYM_Trains VALUES(1, 4);


DROP VIEW IF EXISTS member_1_full_workout_routines;
CREATE VIEW member_1_full_workout_routines AS
    SELECT name, type, reps FROM GYM_Workout_Routine NATURAL JOIN GYM_Excercise WHERE member_id = 1;
    
DROP FUNCTION IF EXISTS weight_loss;
delimiter //
CREATE FUNCTION weight_loss(in_member_id INT)
    RETURNS INT
    BEGIN
        DECLARE first_weight INT;
        DECLARE last_weight INT;
        DECLARE weight_loss INT;
            SELECT weight INTO first_weight FROM GYM_Stats WHERE member_id = in_member_id ORDER BY time_stamp LIMIT 1;
            SELECT weight INTO last_weight FROM GYM_Stats WHERE member_id = in_member_id ORDER BY time_stamp DESC LIMIT 1;
            set weight_loss = first_weight - last_weight;
        RETURN weight_loss;
    END; //
delimiter ;

DROP PROCEDURE IF EXISTS give_first_workout;
delimiter //
CREATE PROCEDURE give_first_workout(IN in_member_id INT)
    BEGIN
        DECLARE num_of_workouts INT;
        SELECT COUNT(member_id) INTO num_of_workouts FROM GYM_Workout_Routine WHERE member_id = in_member_id;
        IF num_of_workouts < 1 THEN
            BEGIN
                INSERT INTO GYM_Workout_Routine VALUES (in_member_id, 'First Workout');
                INSERT INTO GYM_Excercise VALUES (in_member_id, 'First Workout', 'Pushups', 20);
                INSERT INTO GYM_Excercise VALUES (in_member_id, 'First Workout', 'Situps', 20);
                INSERT INTO GYM_Excercise VALUES (in_member_id, 'First Workout', 'Jumping Jacks', 50);
            END;
        END IF;
    END; //
delimiter ;