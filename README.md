# levy

Eboard

## Getting Started

"ebasehosting-751ee"

This is a school feed application for teachers and learners.

Teachers get to send letters digitally to learners instead of printing out paper form of letters.

Messages can be sent to provide class taught by the teacher or it can be public.
this application also enables pdf files to be share within the application.

in order to share the pdf externally u do so using a link and the other end can view the link shared
on web browsers.

The main function of this application is to provide marks on a digital platform where they can be 
accessed anywhere by the user.

Authen tication, Notifications, Images, pdfs, Texts, sharing, downloading, and viewing capabilities.

firebase deploy --only hosting:ebase-3f858

<!--  <script>-->
<!--    window.addEventListener('load', function(ev) {-->
<!--      _flutter.loader.loadEntrypoint({-->
<!--        serviceWorker: {-->
<!--          serviceWorkerVersion: serviceWorkerVersion,-->
<!--        },-->
<!--        onEntrypointLoaded: function(engineInitializer) {-->
<!--          engineInitializer.initializeEngine().then(function(appRunner) {-->
<!--            appRunner.runApp();-->
<!--          });-->
<!--        }-->
<!--      });-->
<!--    });-->
<!--  </script>-->

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
