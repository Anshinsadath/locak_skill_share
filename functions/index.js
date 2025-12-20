const functions = require("firebase-functions");
const admin = require("firebase-admin");

// --------------------------------------------------
// INIT FIREBASE ADMIN
// --------------------------------------------------
admin.initializeApp();

const db = admin.firestore();

// --------------------------------------------------
// AUTO CANCEL UNPAID ACCEPTED REQUESTS
// Runs every 1 hour
// --------------------------------------------------
exports.autoCancelExpiredRequests = functions.pubsub
  .schedule("every 1 hours")
  .onRun(async () => {
    const now = admin.firestore.Timestamp.now();

    const snapshot = await db
      .collection("requests")
      .where("status", "==", "accepted")
      .where("paymentStatus", "==", "unpaid")
      .where("paymentExpiryAt", "<=", now)
      .get();

    if (snapshot.empty) {
      console.log("No expired unpaid requests found");
      return null;
    }

    const batch = db.batch();

    snapshot.docs.forEach(doc => {
      batch.update(doc.ref, {
        status: "cancelled",
        acceptedBy: null,
      });
    });

    await batch.commit();

    console.log(`Cancelled ${snapshot.size} expired requests`);
    return null;
  });
