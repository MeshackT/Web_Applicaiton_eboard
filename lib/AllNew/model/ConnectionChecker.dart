import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:logger/logger.dart';

class ConnectionChecker{

  static  Connectivity _connectivity = Connectivity();

  static Future<bool> checkInternetConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.other) {
      return true;
    } else {
      return false;
    }
  }

  static checkTimer(){
    Timer.periodic(
        const Duration(seconds: 60), (timer) async {
      bool isConnected = await checkInternetConnectivity();
      if (isConnected) {
        print('Connected');
      } else {
        print('Not connected');
        Fluttertoast.showToast(
            backgroundColor: Colors.purple.shade500,
            msg: "No internet connection.",

          toastLength: Toast.LENGTH_LONG,
        );
      }
    });
  }

}