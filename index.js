
const oxenmq = require('./build/Release/oxenmq.node');

// console.log('oxenmq', oxenmq);

let a = new oxenmq.Address(
        'tcp+curve://public.loki.foundation:22027/3c157ed3c675f56280dc5d8b2f00b327b5865c127bf2c6c42becc3ca73d9132b');


async function init() {
    console.log('starting');
    let omq = new oxenmq.OxenMQ();
    omq.start()

    console.log('connecting to', a.fullAddress);
    // Non-async (we get the id right away, and will queue the request to be sent once fully
    // requested):
    let c = omq.connectRemote(a);

    // Or we could do an await for the connection to be fully established before we proceed:
    /*
    try {
        c = await omq.connectRemoteAsync(a);
    } catch (error) {
        console.log('connection failed: ', error);
        return;
    }
    */

    let r;
    try {
        r = await omq.request(c, 'rpc.get_info', [], {"timeout": 3000});
    } catch (err) {
        console.log('fail: got back', err.length, 'parts');
        return;
    }

    console.log('success: got back', r.length, 'parts');
    console.log(r[0].toString('utf8'));
    console.log(r[1].toString('utf8'));

    omq.disconnect(c);

    console.log('done');
}
init()
