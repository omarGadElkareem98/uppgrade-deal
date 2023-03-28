import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:url_launcher/url_launcher.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({Key? key}) : super(key: key);

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  bool qr = false;
  bool active = false;
  MobileScannerController mobileScannerController = MobileScannerController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('qr_scanner').tr()),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: mobileScannerController,
                allowDuplicates: false,
                onDetect: (barcode, args) async {
                  if (barcode.rawValue == null) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("")));
                  } else {
                    final String url = barcode.rawValue!;
                    await _launchUrl(url);
                  }
                }
              ),
          ),
          Row(
            children: [
              SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  child: Text('toggle_flash'.tr()),
                  onPressed: ()async{
                    await mobileScannerController.toggleTorch();
                  },
                ),
              ),
              SizedBox(width: 10,),
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  child: Text('switch_camera').tr(),
                  onPressed: ()async{
                    await mobileScannerController.switchCamera();
                  },
                ),
              ),
              SizedBox(width: 10,),
            ],
          )
        ],
      ),
    );
  }

  Future<void> _launchUrl(url) async {
    final Uri _url = Uri.parse(url);

    if (!await launchUrl(_url)) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('invalid QrCode Url')));
    }
  }
}
