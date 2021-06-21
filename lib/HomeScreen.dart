import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey gblKey = GlobalKey(debugLabel: 'QR');

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          'Savings',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10.0),
            child: Expanded(
              child: Text(
                'Pay through UPI',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 40.0,
              top: 20.0,
              right: 40.0,
              bottom: 25.0,
            ),
            child: Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Enter UPI Number',
                  hintStyle:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.w300),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.deepPurple),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _blurArea(context),
          ),
          Expanded(
            child: Center(
              child: Container(
                child: TextButton(
                  onPressed: () {
                    // await controller?.flipCamera();
                    // setState(() {});
                  },
                  child: Text(result == null
                      ? 'Scan Here'
                      : 'Barcode Type: ${describeEnum(result!.format)}   Data: ${result!.code}'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _blurArea(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
            MediaQuery.of(context).size.height < 400)
        ? 140.0
        : 180.0;
    return QRView(
      key: gblKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: Colors.white,
          borderRadius: 10,
          borderLength: 80,
          borderWidth: 10,
          cutOutSize: scanArea),
    );
  }

  void _onQRViewCreated(QRViewController qrViewController) {
    setState(() {
      this.controller = qrViewController;
    });
    qrViewController.scannedDataStream.listen((scannedData) {
      setState(() {
        result = scannedData;
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
