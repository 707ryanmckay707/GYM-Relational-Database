const db = require('../database/connection');

class workoutRoutineController {
    static async all(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const query = 'SELECT * FROM GYM_Workout_Routine;';
                db.query(query, (err,res) => {
                    if(err) {
                        reject(err);
                    }
                    ctx.body = res;
                    ctx.status = 200;
                    resolve();
                });
            });
        } catch (e) {
            console.log('Error in Workout Routine Controller:');
            console.log(e);
        }
    }

    static async rename(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const workoutRoutine = ctx.request.body;
                const query = 'UPDATE GYM_Workout_Routine SET name = ? WHERE member_id = ? and name = ?;';
                db.query({
                    sql: query,
                    values: [workoutRoutine.new_name, ctx.params.member_id, workoutRoutine.old_name]
                }, (err,res) => {
                    if(err) {
                        reject(err);
                    }
                    ctx.body = res;
                    ctx.status = 200;
                    resolve();
                });
            });
        } catch (e) {
            console.log('Error in Workout Routine Controller:');
            console.log(e);
        }
    }
    
    static async deleteByID(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const workoutRoutine = ctx.request.body;
                const query = 'DELETE FROM GYM_Workout_Routine WHERE member_id = ? and name = ?;';
                db.query({
                    sql: query,
                    values: [ctx.params.member_id, workoutRoutine.name]
                }, (err,res) => {
                    if(err) {
                        reject(err);
                    }
                    ctx.body = res;
                    ctx.status = 200;
                    resolve();
                });
            });
        } catch (e) {
            console.log('Error in Workout Routine Controller:');
            console.log(e);
        }
    }

    static async deleteAllByID(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const query = 'DELETE FROM GYM_Workout_Routine WHERE member_id = ?;';
                db.query({
                    sql: query,
                    values: [ctx.params.member_id]
                }, (err,res) => {
                    if(err) {
                        reject(err);
                    }
                    ctx.body = res;
                    ctx.status = 200;
                    resolve();
                });
            });
        } catch (e) {
            console.log('Error in Workout Routine Controller:');
            console.log(e);
        }
    }
}

module.exports = workoutRoutineController;