const db = require('../database/connection');

class memberController {
    static async all(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const query = 'SELECT * FROM GYM_Member;';
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
            console.log('Error in Member Controller:');
            console.log(e);
        }
    }

    static async weightLoss(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const query = 'select weight_loss(?);';
                db.query({
                    sql: query,
                    values: [ctx.params.id]
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
            console.log('Error in Member Controller:');
            console.log(e);
        }
    }

    static async giveFirstWorkoutRoutine(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const query = 'call give_first_workout(?);';
                db.query({
                    sql: query,
                    values: [ctx.params.id]
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
            console.log('Error in Member Controller:');
            console.log(e);
        }
    }

    static async member1FullWorkoutRoutines(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const query = 'select * from member_1_full_workout_routines;';
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
            console.log('Error in Member Controller:');
            console.log(e);
        }
    }
}

module.exports = memberController;