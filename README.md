# Eboard application for web

https://liveboards.web.app/

This is a school application for teachers and learners. It is a schol management application designed to cater the functionalities of both teachers and learner through communication.

1. Teachers get to send letters digitally to learners instead of printing out paper formates.
2. Messages can be sent by the teacher privately to a class or it can be public for everyone to see.
3. This application also enables pdf files to be share within the application.
4. In order to share the pdf externally you can do so using a link and the other end(the other person) can view the link shared
on web browsers.
5. The main function of this application is to provide marks on a digital platform where they can be 
accessed anywhere by learners.
6. Authentication, Notifications, Images, pdfs, Texts, sharing, downloading, and viewing capabilities are included in the webapp.


<!--  Remind myself -->

[//]: # (gsutil cors set cors.json gs://ebase-3f858.appspot.com/)

Deploy steps
npm install -g firebase-tools
firebase login
firebase init
yes
(public) build/web
(Single page) yes
(GitHub host) no
no
flutter build web
firebase deploy --only hosting

17 June 2023
changes...
Removed initializing since there where two.

changed the 
<!--  <base href="$FLUTTER_BASE_HREF">-->
changed TO
  <base href="/"> works okay apparently


Open app
Flutter Tutorial - How To Use URL Launcher | Open URL In Web Browser / In App WebView


This is where I made the change on the 13th of october 2023
check displays, home, ads


// web folder manifest
"src": "icons/Icon-192.png",
"src": "icons/Icon-512.png",
"src": "icons/Icon-maskable-192.png",
"src": "icons/Icon-maskable-512.png",

index.html
<link rel="apple-touch-icon" href="icons/Icon-192.png">
