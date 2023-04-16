module.exports = async function (context, myTimer) {
    var timeStamp = new Date().toISOString();
    if (myTimer.IsPastDue) {
        context.log('JavaScript is running late!');
    }
    context.bindings.outputBlob2 = 'hello func2';
    context.log('written hello to blob func2', timeStamp); context.log('JavaScript timer trigger function ran!', timeStamp);
};
