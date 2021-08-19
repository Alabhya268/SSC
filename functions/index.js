const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp(functions.config().firebase);

var notificationData;

exports.notificationTrigger = functions.firestore
  .document("notifications/{notificationId}")
  .onCreate(async (snapshot, context) => {
    notificationData = snapshot.data();
    console.log(notificationData);
    admin
      .firestore()
      .collection("tokens")
      .get()
      .then((snapshots) => {
        var tokens = [];
        if (snapshots.empty) {
          console.log("No device");
        } else {
          for (var token of snapshots.docs) {
            var data = token.data();
            if (
              data.products.length === 0 ||
              data.products.includes(notificationData.product)
            ) {
              tokens.push(data.token);
            }
          }
          var payload = {
            notification: {
              title: notificationData.title,
              body: notificationData.message,
              sound: "default",
            },
            data: {
              sendername: notificationData.title,
              message: notificationData.message,
            },
          };

          tokens.length === 0
            ? console.log("No tokens provided")
            : admin
                .messaging()
                .sendToDevice(tokens, payload)
                .then((response) => {
                  console.log(response);
                })
                .catch((err) => {
                  console.log(err);
                });
          console.log("Function finished");
        }
      });
  });
