const trainerController = require('../controllers/trainerController');

const trainerRouter = require('koa-router')({
    prefix: '/trainer'
});

//Default Route
trainerRouter.get('/', trainerController.all);

//Call this route to update the attributes of a single trainer
//(Does not update the id)
trainerRouter.put('/:id', trainerController.updateByID);

//Call this route to add a new trainer
trainerRouter.post('/', trainerController.add);

//Call this route to get all the members a trainer is training
trainerRouter.get('/:id/training', trainerController.trainingByID);

module.exports = trainerRouter;