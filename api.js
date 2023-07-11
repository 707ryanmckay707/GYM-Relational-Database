const koa = require('koa');
const bodyparser = require('koa-bodyparser');
const koajson = require('koa-json');
const koaServer = new koa();
const defaultRouter = require('./routes/default');
const API_PORT = 8116;

koaServer.use(async (ctx, next) => {
    await next();
    rs = ctx.response.get('X-Response-Time');
    console.log(`Type: ${ctx.method} Path: ${ctx.url} Time: ${rs}`);
    console.log(ctx.body);
});

koaServer.use(async (ctx, next) => {
    const date = Date.now();
    await next();
    const ms = Date.now() - date;
    ctx.set('X-Response-Time', `${ms} ms`);
});

koaServer.use(bodyparser());
koaServer.use(koajson());

defaultRouter(koaServer);

koaServer.listen(API_PORT, () => {
    console.log(`Listening on Port #: ${API_PORT}`)});