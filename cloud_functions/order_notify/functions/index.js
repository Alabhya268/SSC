const functions = require("firebase-functions");
const admin = require('firebase-admin')

admin.initializeApp(functions.config().firebase);

var msgData;

exports.offerTrigger222 = functions.firestore.document(
    'offers/{offerId}'
).onCreate((snapshot, context) => {
    msgData = snapshot.data();
    admin.firestore().collection('pushtokens').get().then((snapshots) => {
        var tokens = [];
        if (snapshots.empty) {
            console.log('No device');
        } else {
            for(var token of snapshots.docs) {
                tokens.push(token.data().devtoken);
            }
            var payload = {
                'notification': {
                    'title': msgData.name,
                    'body': msgData.offer,
                    'sound': 'default'
                },
                'data': {
                    'sendername': msgData.name,
                    'message': msgData.offer
                }
            }

            return admin.messaging().sendToDevice(tokens, payload).then((response) => {
                console.log('Pushed them all');
            }).catch((err) => {
                console.log(err);
            });
        }
    })
});
