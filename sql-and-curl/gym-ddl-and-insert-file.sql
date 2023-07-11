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

insert into GYM_Member values (1, 'Bryan Stevens', 'stevensb@gmail.com');
insert into GYM_Member values (2, 'Steven George', 'strongman45@yahoo.com');
insert into GYM_Member values (3, 'Mike Molasses', 'cooldude64@yahoo.com');
insert into GYM_Member values (4, 'Roger Sideways', 'thesidewaylife@gmail.com');
insert into GYM_Member values (5, 'Michelle Moore', 'mmoore@gmail.com');

insert into GYM_Trainer values (1, 'Buff Johnson', 'supportyourself@gmail.com', 40);
insert into GYM_Trainer values (2, 'Stacy Leeland', 'stacylee@gmail.com', 60);
insert into GYM_Trainer values (3, 'Tracy Davis', 'tracydavis@yahoo.com', 30);
insert into GYM_Trainer values (4, 'Miles Travis', 'mtravis@yahoo.com', 35);
insert into GYM_Trainer values (5, 'Tyler Conway', 'tconway@gmail.com', 55);

insert into GYM_Workout_Routine values (1, 'Monday Workout');
insert into GYM_Workout_Routine values (1, 'Wednesday Workout');
insert into GYM_Workout_Routine values (2, 'Arm Workout');
insert into GYM_Workout_Routine values (2, 'Leg Workout');
insert into GYM_Workout_Routine values (3, 'Midweek Workout');

insert into GYM_Excercise values (1, 'Monday Workout', 'Pushups', 20);
insert into GYM_Excercise values (1, 'Monday Workout', 'Situps', 15);
insert into GYM_Excercise values (1, 'Wednesday Workout', 'Jumping Jacks', 50);
insert into GYM_Excercise values (1, 'Wednesday Workout', 'Tricep Curls', 30);
insert into GYM_Excercise values (1, 'Wednesday Workout', 'Bicep Curls', 25);
insert into GYM_Excercise values (2, 'Arm Workout', 'Tricep Curls', 50);
insert into GYM_Excercise values (2, 'Arm Workout', 'Bicep Curls', 50);

insert into GYM_Charge values (2, 1, '2021-03-01 10:10:05', 60);
insert into GYM_Charge values (2, 2, '2021-03-01 11:10:15', 45);
insert into GYM_Charge values (3, 3, '2021-03-03 13:25:07', 30);
insert into GYM_Charge values (5, 1, '2021-03-03 13:30:00', 55);
insert into GYM_Charge values (1, 4, '2021-03-04 08:15:45', 80);

insert into GYM_Stats values (1, '2021-03-07 12:10:35', 160, 122, 79);
insert into GYM_Stats values (2, '2021-03-07 12:15:30', 158, 115, 75);
insert into GYM_Stats values (3, '2021-03-08 07:05:29', 180, 116, 78);
insert into GYM_Stats values (1, '2021-03-08 12:12:06', 159, 120, 77);
insert into GYM_Stats values (2, '2021-03-08 12:14:00', 160, 116, 75);

insert into GYM_Trains values(2, 1);
insert into GYM_Trains values(2, 2);
insert into GYM_Trains values(3, 3);
insert into GYM_Trains values(5, 1);
insert into GYM_Trains values(1, 4);


drop view if exists member_1_full_workout_routines;
create view member_1_full_workout_routines as
    select name, type, reps from GYM_Workout_Routine natural join GYM_Excercise where member_id = 1;
    
drop function if exists weight_loss;
delimiter //
create function weight_loss(in_member_id INT)
    returns INT
    begin
        declare first_weight INT;
        declare last_weight INT;
        declare weight_loss INT;
            select weight into first_weight from GYM_Stats where member_id = in_member_id ORDER BY time_stamp LIMIT 1;
            select weight into last_weight from GYM_Stats where member_id = in_member_id ORDER BY time_stamp DESC LIMIT 1;
            set weight_loss = first_weight - last_weight;
        return weight_loss;
    end; //
delimiter ;

drop procedure if exists give_first_workout;
delimiter //
create procedure give_first_workout(IN in_member_id INT)
    begin
        declare num_of_workouts INT;
        select count(member_id) into num_of_workouts from GYM_Workout_Routine where member_id = in_member_id;
        if num_of_workouts < 1 then
            begin
                insert into GYM_Workout_Routine values (in_member_id, 'First Workout');
                insert into GYM_Excercise values (in_member_id, 'First Workout', 'Pushups', 20);
                insert into GYM_Excercise values (in_member_id, 'First Workout', 'Situps', 20);
                insert into GYM_Excercise values (in_member_id, 'First Workout', 'Jumping Jacks', 50);
            end;
        end if;
    end; //
delimiter ;