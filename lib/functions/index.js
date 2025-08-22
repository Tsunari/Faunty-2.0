/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

const {setGlobalOptions} = require("firebase-functions");
const logger = require("firebase-functions/logger");
const util = require('util'); // This is handy for debugging complex objects!

// Set global options for your functions, like max instances and region.
// This applies to functions using the v2 API. For v1, use .runWith() per function.
setGlobalOptions({maxInstances: 10, region: "europe-west1"});

// Import the necessary Firebase modules
const functions = require("firebase-functions");
const admin = require("firebase-admin");

// Initialize the Firebase Admin SDK once for your project.
// This allows your function to interact with other Firebase services like Firestore and FCM.
try {
  // Explicitly set projectId where possible to avoid endpoint resolution issues,
  // falling back to environment variables or a hardcoded value if necessary.
  const proj = process.env.GCLOUD_PROJECT || process.env.GCP_PROJECT || (process.env.FIREBASE_CONFIG ? JSON.parse(process.env.FIREBASE_CONFIG).projectId : undefined) || 'faunty-2-0';
  admin.initializeApp({ projectId: proj });
} catch (e) {
  // If the Admin SDK is already initialized (e.g., in some testing environments),
  // we'll just log a warning instead of throwing an error.
  logger.warn("Firebase Admin SDK already initialized or projectId not found.");
}

// A simple utility function to safely stringify objects for logging.
// This helps prevent crashes when logging complex or circular objects.
function safeStringify(obj) {
  try {
    return JSON.stringify(obj);
  } catch (e) {
    try {
      return util.inspect(obj, {depth: 3});
    } catch (e2) {
      return String(obj);
    }
  }
}

/**
 * Callable function to send a test notification to a specific FCM token.
 *
 * This function is invoked from your client-side application (e.g., Flutter web)
 * via Firebase's callable function mechanism.
 *
 * It expects a data payload with:
 * - 'token': The FCM registration token of the target device.
 * - 'title' (optional): The title of the notification.
 * - 'body' (optional): The body text of the notification.
 *
 * If the FCM token is found to be invalid or unregistered, the function
 * attempts to remove it from your 'fcm_tokens' Firestore collection.
 *
 * @param {object} data The data payload sent from the client. For callable functions,
 *                      the client's payload is automatically wrapped under a 'data' key.
 * @param {object} context The context object containing authentication info, etc.
 * @returns {Promise<object>} A promise that resolves with a success status and message ID,
 *                            or rejects with an HttpsError.
 */
exports.testNotification = functions.https.onCall(async (data, context) => {
  // --- Debug logs to inspect the incoming payload ---
  // These logs are extremely useful during development to see exactly what your function receives.
  logger.info('Received callable call with raw data:', safeStringify(data));
  logger.info('Attempting to access data.data.token (which is your actual payload.token):', safeStringify(data?.data?.token));
  // --- End Debug logs ---

  try {
    // *** CRITICAL CORRECTION: Accessing the nested 'data' object ***
    // Firebase Callable Functions automatically wrap the client-sent data
    // under a 'data' key in the function's 'data' argument.
    // So, if your client sends { token: 'abc' }, the function receives { data: { token: 'abc' }, ... }.
    const token = data?.data?.token ? String(data.data.token) : null;
    const title = data?.data?.title ? String(data.data.title) : 'Test Notification from Firebase';
    const body = data?.data?.body ? String(data.data.body) : 'This is a simple test message.';

    logger.info('Value of "token" after extraction:', safeStringify(token));

    // Input validation: Ensure a token was provided.
    if (!token) {
      logger.warn('Callable function testNotification called without a token. Missing FCM token in payload.');
      throw new functions.https.HttpsError(
        'invalid-argument',
        'Missing FCM token. Please provide a "token" in the request data.'
      );
    }

    // Construct the FCM message payload.
    const message = {
      token: token,
      notification: { title, body },
      data: {
        // Include some metadata about who sent the notification and when.
        sentBy: context?.auth?.uid || 'anonymous',
        sentAt: new Date().toISOString(),
      },
    };

    try {
      // Send the message using the Firebase Admin SDK's messaging service.
      const response = await admin.messaging().send(message);
      logger.info(`Successfully sent test notification to token: ${token}`, { messageId: response });
      return { success: true, messageId: response }; // Return success to the client
    } catch (sendError) {
      // Log details of any error encountered during FCM send.
      logger.error('Error sending FCM message:', safeStringify({
        message: sendError.message,
        code: sendError.code,
        errorInfo: sendError.errorInfo
      }));

      // Important error handling: Clean up invalid/unregistered FCM tokens from Firestore.
      // This prevents continually trying to send to inactive devices.
      if (sendError.code === 'messaging/invalid-registration-token' ||
          sendError.code === 'messaging/registration-token-not-registered') {
        logger.warn(`Invalid or unregistered FCM token detected: ${token}. Attempting to delete from 'fcm_tokens' collection.`);
        try {
          await admin.firestore().collection('fcm_tokens').doc(token).delete();
          logger.info(`Invalid token ${token} successfully deleted from Firestore.`);
        } catch (cleanupErr) {
          logger.error('Failed to remove invalid token from Firestore:', safeStringify(cleanupErr));
        }
      }
      
      // Re-throw the error as an HttpsError so the client-side Firebase SDK
      // can properly handle it and expose the error details.
      throw new functions.https.HttpsError('internal', `Failed to send notification: ${sendError.message}`);
    }

  } catch (err) {
    // Catch any unexpected errors that occurred outside the FCM send block.
    logger.error('testNotification encountered an unexpected error:', safeStringify(err));
    
    // Ensure that any error returned to the client is an instance of HttpsError.
    if (err instanceof functions.https.HttpsError) {
      throw err; // If it's already an HttpsError, just re-throw it.
    } else {
      // For any other generic error, wrap it in an HttpsError to provide
      // a consistent error structure to the client.
      throw new functions.https.HttpsError(
        'unknown',
        'An unexpected error occurred during notification processing.',
        safeStringify(err) // Include the original error details for debugging.
      );
    }
  }
});
