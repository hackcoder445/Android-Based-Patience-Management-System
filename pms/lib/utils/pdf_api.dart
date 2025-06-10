import 'dart:io';

import 'package:open_file/open_file.dart';
import 'package:pdf/widgets.dart';
import 'package:pms/utils/constants.dart';

class PdfApi {
  static Future<File> saveDocument({
    required String name,
    required Document pdf,
  }) async {
    final bytes = await pdf.save();

    // final dir = await getApplicationDocumentsDirectory();
    final dir = await Constants.getPath();
    print("dir: $dir");
    final file = File('$dir/$name');

    await file.writeAsBytes(bytes);

    return file;
  }

  static Future openFile(File file) async {
    final url = file.path;

    await OpenFile.open(url);
  }
}
