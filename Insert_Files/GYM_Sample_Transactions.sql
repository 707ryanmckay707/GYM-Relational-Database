-- view the gym trainers and their corresponding gym members where the gym member has no workout routine
-- outer join, query joining 3 or more tables
select GYM_Trainer.id as trainer_id, GYM_Trainer.name as trainer_name, GYM_Member.id as member_id, GYM_Member.name as member_name 
	from GYM_Trainer join GYM_Trains on GYM_Trainer.id = GYM_Trains.trainer_id 
	join GYM_Member on GYM_Trains.member_id = GYM_Member.id
    left outer join GYM_Workout_Routine on GYM_Member.id = GYM_Workout_Routine.member_id where GYM_Workout_Routine.member_id is null;

-- view all gym members who have elevated blood pressure (along with the corresponding stat entries that have elevated blood pressure)
-- where clause with multiple conditions
select * from GYM_Member join GYM_Stats on GYM_Member.id = GYM_Stats.member_id where systolic_pressure > 120 or diastolic_pressure > 80;

-- view all gym trainers' id who are training more than 1 gym member
-- group by and having
select trainer_id from GYM_Trains group by trainer_id having count(member_id) > 1;

-- All the gym trainers that aren't training anyone
-- where not in
select id, name from GYM_Trainer where id not in (select trainer_id from GYM_Trains);

-- Another way to view all the gym trainers that aren't training anyone
-- set operation
(select id from GYM_Trainer) except (select trainer_id from GYM_Trains);

-- select all the unique types of excercises
-- distinct
select distinct type from GYM_Excercise;


-- Double the number of reps in each excercise of gym member 1's Monday Workout
update GYM_Excercise set reps = reps * 2 where name = 'Monday Workout' and member_id = 1;

-- A gym member viewing his workout for Wednesday
select * from member_1_full_workout_routines where name = 'Wednesday Workout';

select min(weight) from GYM_Stats where member_id = 1;

-- Viewing weight loss for gym member 1
select weight_loss(1);

-- Viewing weight loss for gym member 2 (negative for a weight increase)
select weight_loss(2);

-- (For your ease of use of the procedure)
select * FROM GYM_Workout_Routine;

-- member 1 already has atleast 1 workout, so a first workout isn't added
call give_first_workout(1);

-- adds member 4s first workout routine
call give_first_workout(4);