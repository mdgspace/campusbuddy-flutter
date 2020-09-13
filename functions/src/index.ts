//  Start writing Firebase Functions

import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';


admin.initializeApp(functions.config().firebase);

const db = admin.firestore();
const fcm = admin.messaging();

//Function for Events
//
export const sendEvents = functions.firestore
  .document('Events/{eventid}')
  .onCreate(async snapshot => {

const Event = snapshot.data();
console.log(Event.created_by);
    
    const querySnapshot = await db
    .collectionGroup('tokens').get();

console.log(querySnapshot.size);
const tokens = querySnapshot.docs.map(snap => snap.id);
const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `${Event.created_by} has added a new event!`,
        body: `A ${Event.title} has been scheduled, visit app for more details!`,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

console.log(tokens);

    return fcm.sendToDevice(tokens, payload);
  });

//Function for Posts
//
export const sendPosts = functions.firestore
  .document('Posts/{postid}')
  .onCreate(async snapshot => {

const Post = snapshot.data();
console.log(Post.created_by);
    
    const querySnapshot = await db
    .collectionGroup('tokens').get();

console.log(querySnapshot.size);

const tokens = querySnapshot.docs.map(snap => snap.id);

const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: `${Post.created_by} has added a new post!`,
        body: `About: ${Post.title}!`,
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

console.log(tokens);
    return fcm.sendToDevice(tokens, payload);
  });
