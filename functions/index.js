const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();
const db = admin.firestore();

/**
 * Accept a request safely
 */
exports.acceptRequest = functions.https.onCall(async (data, context) => {
  if (!context.auth) {
    throw new functions.https.HttpsError(
      "unauthenticated",
      "User must be logged in"
    );
  }

  const { requestId } = data;
  const helperUid = context.auth.uid;

  if (!requestId) {
    throw new functions.https.HttpsError(
      "invalid-argument",
      "requestId required"
    );
  }

  const requestRef = db.collection("requests").doc(requestId);
  const snap = await requestRef.get();

  if (!snap.exists) {
    throw new functions.https.HttpsError("not-found", "Request not found");
  }

  const request = snap.data();

  // ❌ Prevent owner accepting own request
  if (request.userId === helperUid) {
    throw new functions.https.HttpsError(
      "permission-denied",
      "Cannot accept your own request"
    );
  }

  // ❌ Already accepted
  if (request.status !== "pending") {
    throw new functions.https.HttpsError(
      "failed-precondition",
      "Request already accepted"
    );
  }

  // ✅ Update request
  await requestRef.update({
    status: "accepted",
    acceptedBy: helperUid,
    updatedAt: admin.firestore.FieldValue.serverTimestamp(),
  });

  // ✅ Create chat
  const chatId = [request.userId, helperUid, requestId].sort().join("_");

  await db.collection("chats").doc(chatId).set(
    {
      users: [request.userId, helperUid],
      requestId: requestId,
      updatedAt: admin.firestore.FieldValue.serverTimestamp(),
    },
    { merge: true }
  );

  return { chatId };
});
