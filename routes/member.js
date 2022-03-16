const memberController = require('../controllers/memberController');

const memberRouter = require('koa-router')({
    prefix: '/member'
});

//Default Route
memberRouter.get('/', memberController.all);

//Call this route to get the weight loss of a member
//(Calculated over all their entire recorded history at the gym)
memberRouter.get('/:id/weightloss', memberController.weightLoss);

//Call this route to add a workout routine to the specified member if they don't have any workout routines
memberRouter.post('/:id/giveFirstWorkoutRoutine', memberController.giveFirstWorkoutRoutine);

//Call this route to get all the tuples from the view member_1_full_workout_routines
memberRouter.get('/member1FullWorkoutRoutines', memberController.member1FullWorkoutRoutines);

module.exports = memberRouter;
