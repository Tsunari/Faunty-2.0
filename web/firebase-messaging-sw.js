// firebase-messaging-sw.js

// Import the Firebase app and messaging compat libraries using importScripts.
// Replace '10.13.2' with the version of the Firebase JS SDK you're using in your app,
// or a recent stable version. Using the same version across your app is good practice.
importScripts('https://www.gstatic.com/firebasejs/12.1.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/12.1.0/firebase-messaging-compat.js');

// Initialize the Firebase app in the service worker by passing in
// your app's Firebase config object.
firebase.initializeApp({
  apiKey: "AIzaSyB9_qk6gEh0o6qQzBlvaIoIhcUCWkNQ-mQ",
  authDomain: "faunty-2-0.firebaseapp.com",
  projectId: "faunty-2-0",
  storageBucket: "faunty-2-0.firebasestorage.app",
  messagingSenderId: "261069155360",
  appId: "1:261069155360:web:1db8a58ca41febc0a5e045",
  measurementId: "G-ZF2W5PFE3F"
});

// Retrieve an instance of Firebase Messaging so that it can handle
// background messages.
const messaging = firebase.messaging();

// Optional: Handle background messages
// This function will be called when the app is in the background.
// You can customize the notification display here.
messaging.onBackgroundMessage((payload) => {
  console.log('[firebase-messaging-sw.js] Received background message ', payload);
  // If the payload already contains a `notification` field, the browser
  // / Firebase may already display a notification for you. Showing another
  // notification here can cause duplicate notifications. To avoid that,
  // only show a notification from the service worker when there is no
  // `notification` object in the payload and we have custom data to show.
  if (payload && payload.notification) {
    console.log('[firebase-messaging-sw.js] Payload contains notification; skipping manual showNotification to avoid duplicates.');
    return;
  }

  // Fallback: try to construct a notification from data fields
  const notificationTitle = (payload && payload.data && payload.data.title) || 'Background Message Title';
  const notificationOptions = {
    body: (payload && payload.data && payload.data.body) || 'Background Message Body',
    icon: 'icons/icon-512-maskable.png',
    data: payload && payload.data
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});
