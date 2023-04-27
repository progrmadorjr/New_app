import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;

class Contrato extends StatefulWidget {
  const Contrato({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ContratoState createState() => _ContratoState();
}

class _ContratoState extends State<Contrato> {
  final String pdfUrl =
      'https://firebasestorage.googleapis.com/v0/b/onbdados.appspot.com/o/Doc.pdf?alt=media&token=5196e9c4-9e55-40d0-a26a-f57589dbfa10';

  Future<void> sharePdf() async {
    try {
      final directory = await getExternalStorageDirectory();
      if (directory == null) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Não foi possível compartilhar o PDF. Verifique as permissões do aplicativo.'),
        ));
        return;
      }

      final file = File('${directory.path}/meu_pdf.pdf');
      final response = await http.get(Uri.parse(pdfUrl));
      if (response.statusCode == 200) {
        await file.writeAsBytes(response.bodyBytes);
        final filePaths = [file.path];
        await Share.shareFiles(filePaths);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Não foi possível baixar o PDF.'),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Erro ao compartilhar PDF: $e'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF002A3A),
        title: const Text('Contrato'),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          IconButton(
            onPressed: () => sharePdf(),
            icon: const Icon(Icons.share),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SfPdfViewer.network(pdfUrl),
          ),
        ],
      ),
    );
  }
}
