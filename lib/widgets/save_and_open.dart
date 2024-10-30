import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;


class SaveAndOpenDocument {
  static Future<File> savePdf({required String name, required pw.Document pdf}) async {
    final root = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    final File file = File('${root!.path}/$name.pdf');
    await file.writeAsBytes(await pdf.save());
    return File(file.path);

  }

  static Future<void> openPdf(File file) async {
    final path = file.path;
    await OpenFile.open(path);
  }

}


