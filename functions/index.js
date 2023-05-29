/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {onRequest} = require("firebase-functions/v2/https");
const logger = require("firebase-functions/logger");
const app = express();

const functions = require('firebase-functions');
const express = require('express');
const cors = requires('cors')

app.use(cors({ origin: "*" }));

exports.myFunction = functions.https.onRequest((req, res) => {
  cors(req, res, () => {
    // Your function logic here
    res.status(200).send('Hello from Firebase!');
  });
});


// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
