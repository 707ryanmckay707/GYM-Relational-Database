const memberRouter = require('./member');
const workoutRoutineRouter = require('./workoutRoutine');
const trainerRouter = require('./trainer');

const defaultRouter = require('koa-router')({
    prefix: '/api/v1'
});

defaultRouter.get('/', (ctx) => {
    ctx.body = 'Default route hit!';
});

defaultRouter.use(
    memberRouter.routes(),
    workoutRoutineRouter.routes(),
    trainerRouter.routes()
);

module.exports = (koaServer) => {
    koaServer.use(defaultRouter.routes());
};