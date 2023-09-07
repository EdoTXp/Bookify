import 'package:bookify/src/features/qr_code_scanner/widgets/isbn_manually_textformfield_widget.dart';
import 'package:bookify/src/features/qr_code_scanner/widgets/qr_code_scanner_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QrCodeScannerPage extends StatefulWidget {
  const QrCodeScannerPage({super.key});

  @override
  State<QrCodeScannerPage> createState() => _QrCodeScannerPageState();
}

class _QrCodeScannerPageState extends State<QrCodeScannerPage> {
  bool qrCodeScannerIsVisible = true;

  @override
  void initState() {
    super.initState();
    
    // Lock the screen only portrait
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // Unlock the screen
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.dispose();
  }

  void _searchIsbn(BuildContext context, String value) {
    value = value.replaceAll('-', '');
    if (value.isNotEmpty && value.length == 13) {
      int isbn = int.parse(value);
      Navigator.pop(context, isbn);
    }
  }

  @override
  Widget build(BuildContext context) {
    String titleText;
    String changeModeText;
    IconData changeIconMode;

    // start QrCodeScannerWidget
    if (qrCodeScannerIsVisible) {
      titleText = 'Aponte a câmera para o código de barras do livro';
      changeModeText = 'Digitar o código manualmente';
      changeIconMode = Icons.keyboard;
    }
    // start IsbnManuallyTextFormFieldWidget
    else {
      titleText = 'Digite os números do código de barra';
      changeModeText = 'Scanear código';
      changeIconMode = Icons.qr_code;
    }

    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          SizedBox(
            width: MediaQuery.sizeOf(context).width / 2,
            child: Text(
              titleText,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Expanded(
            child: (qrCodeScannerIsVisible)
                ? QrCodeScannerWidget(
                    onDetect: (qrCodeValue) =>
                        _searchIsbn(context, qrCodeValue),
                  )
                : IsbnManuallyTextFormFieldWidget(
                    onTap: (textFormFieldValue) => _searchIsbn(context, textFormFieldValue),
                  ),
          ),
          SizedBox(
            height: 64,
            width: double.infinity,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: TextButton.icon(
                label: Text(changeModeText),
                icon: Icon(changeIconMode),
                onPressed: () {
                  setState(() {
                    qrCodeScannerIsVisible = !qrCodeScannerIsVisible;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
