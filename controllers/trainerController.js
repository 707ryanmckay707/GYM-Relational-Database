const db = require('../database/connection');

class trainerController {
    static async all(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const query = 'SELECT * FROM GYM_Trainer;';
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
            console.log('Error in Trainer Controller:');
            console.log(e);
        }
    }

    static async updateByID(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const trainer = ctx.request.body;
                const query = `
                    UPDATE GYM_Trainer
                    set name = ?,
                        email = ?,
                        rate = ?
                    where id = ?
                `;
                db.query({
                    sql: query,
                    values: [trainer.name, trainer.email, trainer.rate, ctx.params.id]
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
            console.log('Error in Trainer Controller:');
            console.log(e);
        }
    }

    static async add(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const trainer = ctx.request.body;
                const query = `
                    INSERT INTO GYM_Trainer
                        VALUES (?, ?, ?, ?); 
                `;
                db.query({
                    sql: query,
                    values: [trainer.id, trainer.name, trainer.email, trainer.rate]
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
            console.log('Error in Trainer Controller:');
            console.log(e);
        }
    }

    static async trainingByID(ctx) {
        try {
            return new Promise((resolve, reject) => {
                const trainer = ctx.request.body;
                const query = `
                    select GYM_Member.id as member_id, GYM_Member.name as member_name 
                        from GYM_Trains join GYM_Member on GYM_Trains.member_id = GYM_Member.id
                        where GYM_Trains.trainer_id = ?;
                `;
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
            console.log('Error in Trainer Controller:');
            console.log(e);
        }
    }
}

module.exports = trainerController;