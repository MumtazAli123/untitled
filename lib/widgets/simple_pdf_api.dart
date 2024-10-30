import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_core/firebase_core.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:http/http.dart' as http;

class PdfApi  {
  // static Future<File> generateSimpleTextPdf(String seller, String buyer ) async {
  //   final pdf = pw.Document();
  //   pdf.addPage(
  //     pw.Page(
  //       pageFormat: PdfPageFormat.a4,
  //       build: (context) => pw.Center(
  //         child: pw.Text('Seller: $seller\nBuyer: $buyer'),
  //       ),
  //     ),
  //   );
  //   return SaveAndOpenDocument.savePdf(name: 'simple', pdf: pdf);
  // }
  static Future<File> loadNetworkPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    final pdf = pw.Document();
    pdf.addPage(pw.Page(
      build: (pw.Context context) {
        return pw.Center(
          child: pw.Text(response.body),
        );
      },
    ));
    return _storeFile(url, bytes, pdf);
  }

  static Future<File> _storeFile(String url, List<int> bytes, pw.Document pdf) async {
    var fileName = await Firebase.initializeApp().then((value) async {
      final name = url.split('/').last;
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      await file.writeAsBytes(Uint8List.fromList(bytes));
      return file.path;
    });
    final file = File(fileName);
    await file.writeAsBytes(Uint8List.fromList(await pdf.save()));
    return file;
  }

  // static void openFile(Future<File> simplePdfFile) {
  //   simplePdfFile.then((file) {
  //     SaveAndOpenDocument.openPdf(file);
  //   });
  // }
}