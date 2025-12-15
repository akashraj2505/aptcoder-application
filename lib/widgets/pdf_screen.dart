import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfScreen extends StatefulWidget {
  final String pdfUrl;
  final String title;

  const PdfScreen({
    super.key,
    required this.pdfUrl,
    this.title = 'Document Viewer',
  });

  @override
  State<PdfScreen> createState() => _PdfScreenState();
}

class _PdfScreenState extends State<PdfScreen> {
  String? localPath;
  bool loading = true;
  String? error;
  int currentPage = 0;
  int totalPages = 0;
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  // ================= LOAD PDF (CACHE + STREAM) =================

  Future<void> _loadPdf() async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final fileName = widget.pdfUrl.split('/').last;
      final file = File('${dir.path}/$fileName');

      // ✅ Use cached file if exists
      if (await file.exists()) {
        localPath = file.path;
        loading = false;
        setState(() {});
        return;
      }

      // ✅ Stream download (fast + memory safe)
      final request = http.Request('GET', Uri.parse(widget.pdfUrl));
      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to load PDF');
      }

      final sink = file.openWrite();
      final total = response.contentLength ?? 1;
      int received = 0;

      await response.stream
          .listen(
            (chunk) {
              received += chunk.length;
              sink.add(chunk);
              setState(() => progress = received / total);
            },
            onDone: () async {
              await sink.close();
              localPath = file.path;
              loading = false;
              setState(() {});
            },
            onError: (e) {
              throw e;
            },
            cancelOnError: true,
          )
          .asFuture();
    } catch (e) {
      error = e.toString();
      loading = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: loading
          ? _buildLoading()
          : error != null
          ? _buildError()
          : _buildPdf(),
    );
  }

  // ================= PDF VIEW =================

  Widget _buildPdf() {
    return Stack(
      children: [
        PDFView(
          filePath: localPath!,
          swipeHorizontal: false, // ✅ vertical scroll
          enableSwipe: true,
          autoSpacing: false, // ✅ important
          pageSnap: false, // ✅ important
          pageFling: true,
          fitPolicy: FitPolicy.WIDTH, // ✅ best for scrolling
          preventLinkNavigation: false,
          onRender: (pages) {
            setState(() => totalPages = pages ?? 0);
          },
          onPageChanged: (page, _) {
            setState(() => currentPage = page ?? 0);
          },
        ),
        _pageIndicator(),
      ],
    );
  }

  // ================= LOADING =================

  Widget _buildLoading() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(value: progress == 0 ? null : progress),
          const SizedBox(height: 16),
          Text(
            progress == 0
                ? 'Preparing document...'
                : 'Downloading ${(progress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ================= ERROR =================

  Widget _buildError() {
    return Center(
      child: Text(
        error!,
        style: const TextStyle(color: Colors.white),
        textAlign: TextAlign.center,
      ),
    );
  }

  // ================= PAGE INDICATOR =================

  Widget _pageIndicator() {
    if (totalPages == 0) return const SizedBox();

    return Positioned(
      bottom: 16,
      left: 0,
      right: 0,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.black87,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '${currentPage + 1} / $totalPages',
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
