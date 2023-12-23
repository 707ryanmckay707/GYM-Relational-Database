-- view the gym trainers and their corresponding gym members where the gym member has no workout routine
-- outer join, query joining 3 or more tables
SELECT GYM_Trainer.id AS trainer_id, GYM_Trainer.name AS trainer_name, GYM_Member.id AS member_id, GYM_Member.name AS member_name 
    FROM GYM_Trainer JOIN GYM_Trains ON GYM_Trainer.id = GYM_Trains.trainer_id 
    JOIN GYM_Member ON GYM_Trains.member_id = GYM_Member.id
    LEFT OUTER JOIN GYM_Workout_Routine ON GYM_Member.id = GYM_Workout_Routine.member_id WHERE GYM_Workout_Routine.member_id IS NULL;

-- view all gym members who have elevated blood pressure (along with the corresponding stat entries that have elevated blood pressure)
-- where clause with multiple conditions
SELECT * FROM GYM_Member JOIN GYM_Stats ON GYM_Member.id = GYM_Stats.member_id WHERE systolic_pressure > 120 OR diastolic_pressure > 80;

-- view all gym trainers' id who are training more than 1 gym member
-- group by and having
SELECT trainer_id FROM GYM_Trains GROUP BY trainer_id HAVING COUNT(member_id) > 1;

-- All the gym trainers that aren't training anyone
-- where not in
SELECT id, name FROM GYM_Trainer WHERE id NOT IN (SELECT trainer_id FROM GYM_Trains);

-- Another way to view all the gym trainers that aren't training anyone
-- set operation
(SELECT id FROM GYM_Trainer) EXCEPT (SELECT trainer_id FROM GYM_Trains);

-- SELECT all the unique types of excercises
-- distinct
SELECT DISTINCT type FROM GYM_Excercise;


-- Double the number of reps in each excercise of gym member 1's Monday Workout
UPDATE GYM_Excercise SET reps = reps * 2 WHERE name = 'Monday Workout' AND member_id = 1;

-- A gym member viewing his workout for Wednesday
SELECT * FROM member_1_full_workout_routines WHERE name = 'Wednesday Workout';
SELECT MIN(weight) FROM GYM_Stats WHERE member_id = 1;

-- Viewing weight loss for gym member 1
SELECT weight_loss(1);

-- Viewing weight loss for gym member 2 (negative for a weight increase)
SELECT weight_loss(2);

-- (For your ease of use of the procedure)
SELECT * FROM GYM_Workout_Routine;

-- member 1 already has atleast 1 workout, so a first workout isn't added
CALL give_first_workout(1);

-- adds member 4s first workout routine
CALL give_first_workout(4);