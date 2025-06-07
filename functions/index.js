/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const {onSchedule} = require("firebase-functions/v2/scheduler");
const {logger} = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// Ejemplo función HTTP
exports.helloWorld = onRequest((request, response) => {
  logger.info("Hello logs!", {structuredData: true});
  response.send("Hello from Firebase!");
});


exports.taskRunner = onSchedule("* * * * *", async (_context) => {
  const now = admin.firestore.Timestamp.now();
  const notificationsRef = admin.firestore().collection("notifications");

  const querySnap = await notificationsRef
      .where("scheduledTime", "<=", now)
      .where("sent", "==", false)
      .where("cancel", "==", false)
      .get();

  const promises = [];

  querySnap.forEach((doc) => {
    const data = doc.data();

    const message = {
      topic: "all",
      notification: {
        title: data.title,
        body: data.description,
      },
      data: {
        notificationId: doc.id,
      },
    };

    const promise = admin.messaging().send(message)
        .then(async () => {
          if (data.repeatEvery && data.endDate) {
            const nextTime = new Date(data.scheduledTime.toDate());
            nextTime.setDate(nextTime.getDate() + data.repeatEvery);

            if (nextTime <= data.endDate.toDate()) {
              await doc.ref.update({
                scheduledTime: admin.firestore.Timestamp.fromDate(nextTime),
              });
            } else {
              await doc.ref.update({sent: true});
            }
          } else {
            await doc.ref.update({sent: true});
          }
        })
        .catch((error) => {
          logger.error(`Error enviando notificación ${doc.id}:`, error);
        });

    promises.push(promise);
  });

  await Promise.all(promises);
});