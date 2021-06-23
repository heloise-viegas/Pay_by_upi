import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttercontactpicker/fluttercontactpicker.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:zpay_by_upi/modals/Contact.dart' as contact;
import 'package:zpay_by_upi/services/NetworkClass.dart';
import 'package:zpay_by_upi/shared/constants.dart';

class HomeScreen extends StatefulWidget {
  static String id = 'Home';
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Barcode? result;
  QRViewController? controller;
  PhoneNumber? _phoneNumber;
  final GlobalKey gblKey = GlobalKey(debugLabel: 'QR');
  TextEditingController? txtController;
  TextEditingController? contactController;
  NetworkClass? networkClass;
  contact.Contact? _contact;
  String imgUrl = '';
  String number = '';
  String name = '';
  @override
  void initState() {
    txtController = TextEditingController();
    contactController = TextEditingController();
    networkClass = NetworkClass();
    _contact = contact.Contact();
    super.initState();
  }

  //for hot reload
  @override
  void reassemble() {
    print('reassemble');
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // bottomOpacity: 0.0,
        elevation: 0.0,
        centerTitle: true,
        title: Text(
          Constants.kAppBarText,
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
                Constants.kHeadText,
                style: Constants.kLabelTextStyle,
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
                  hintText: Constants.kInput1Text,
                  hintStyle: Constants.kHintTextStyle,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.kIconColour),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Constants.kIconColour),
                  ),
                ),
                controller: txtController,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: _blurArea(context),
          ),
          Center(
            child: BottomSheet(
              builder: (BuildContext context) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0),
                      child: Expanded(
                        child: Text(
                          Constants.kSearchText,
                          style: Constants.kLabelTextStyle,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 40.0,
                        top: 20.0,
                        right: 40.0,
                        bottom: 20.0,
                      ),
                      child: Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: Constants.kInput2Text,
                            hintStyle: Constants.kHintTextStyle,
                            enabledBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Constants.kIconColour),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide:
                                  BorderSide(color: Constants.kIconColour),
                            ),
                            suffixIcon: Icon(
                              Icons.contact_page_outlined,
                              color: Constants.kIconColour,
                            ),
                          ),
                          onTap: () async {
                            final granted =
                                await FlutterContactPicker.requestPermission();
                            final PhoneContact contact =
                                await FlutterContactPicker.pickPhoneContact();
                            //api call//
                            _contact = await networkClass!.getContact();

                            setState(() {
                              _phoneNumber = contact.phoneNumber;
                              contactController!.text = _phoneNumber!.number!;
                              imgUrl = _contact!.imageUrl!;
                              number = _phoneNumber!.number!;
                              name = contact!.fullName!;
                            });
                          },
                          controller: contactController,
                          readOnly: true,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 40.0,
                        // top: 5.0,
                        right: 40.0,
                        //  bottom: 25.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundImage: NetworkImage(imgUrl),
                            backgroundColor: Colors.transparent,
                            radius: 30,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: Constants.kInput1TextStyle,
                              ),
                              Text(
                                number,
                                style: Constants.kInput2TextStyle,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                );
              },
              onClosing: () {},
            ),
          )
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
        txtController!.text =
            result == null ? Constants.kScanText : result!.code;
        //'Barcode Type: ${describeEnum(result!.format)}   Data:  ${result!.code}';
      });
    });
  }

  @override
  void dispose() {
    print('dispose');
    controller?.dispose();
    super.dispose();
  }
}
