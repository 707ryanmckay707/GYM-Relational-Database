const workoutRoutineController = require('../controllers/workoutRoutineController');

const workoutRoutineRouter = require('koa-router')({
    prefix: '/workoutRoutine'
});

//Default Route
workoutRoutineRouter.get('/', workoutRoutineController.all);

//Call this route to rename a workout
workoutRoutineRouter.put('/:member_id', workoutRoutineController.rename);

//Call this route to delete a single workout routine
workoutRoutineRouter.delete('/:member_id', workoutRoutineController.deleteByID);

//Call this route to delete all workout routines belonging to the specified member
workoutRoutineRouter.delete('/:member_id/all', workoutRoutineController.deleteAllByID);

module.exports = workoutRoutineRouter;


