
const oxenmq = require('./build/Release/oxenmq.node');

//console.log('oxenmq', oxenmq);

let a = new oxenmq.Address("tcp+curve://public.loki.foundation:22027/3c157ed3c675f56280dc5d8b2f00b327b5865c127bf2c6c42becc3ca73d9132b");


async function init() {
    console.log("starting");
    let omq = new oxenmq.OxenMQ();
    omq.start()

    console.log("connecting to", a.fullAddress);
    let x = omq.connectRemote(a);
    let c;
    try {
        c = await x.connected;
    } catch (error) {
        console.log("connection failed: ", error);
        return;
    }

    console.log("done");
}
init()
