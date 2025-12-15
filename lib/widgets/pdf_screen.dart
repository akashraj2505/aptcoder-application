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
      setState(() {
        loading = true;
        error = null;
        progress = 0;
      });

      final dir = await getApplicationDocumentsDirectory();
      final fileName = widget.pdfUrl.split('/').last;
      final file = File('${dir.path}/$fileName');

      // ✅ Use cached file if exists
      if (await file.exists()) {
        setState(() {
          localPath = file.path;
          loading = false;
        });
        return;
      }

      // ✅ Stream download (fast + memory safe)
      final request = http.Request('GET', Uri.parse(widget.pdfUrl));
      final response = await request.send();

      if (response.statusCode != 200) {
        throw Exception('Failed to load PDF (Status: ${response.statusCode})');
      }

      final sink = file.openWrite();
      final total = response.contentLength ?? 1;
      int received = 0;

      // Listen to stream and update progress
      await for (var chunk in response.stream) {
        received += chunk.length;
        sink.add(chunk);
        
        if (mounted) {
          setState(() {
            progress = received / total;
          });
        }
      }

      // Close the file
      await sink.flush();
      await sink.close();

      // Verify file was written
      if (await file.exists()) {
        if (mounted) {
          setState(() {
            localPath = file.path;
            loading = false;
            progress = 1.0;
          });
        }
      } else {
        throw Exception('File download completed but file not found');
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          error = e.toString();
          loading = false;
        });
      }
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
    if (localPath == null) {
      return _buildError();
    }

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
            if (mounted) {
              setState(() => totalPages = pages ?? 0);
            }
          },
          onPageChanged: (page, _) {
            if (mounted) {
              setState(() => currentPage = page ?? 0);
            }
          },
          onError: (e) {
            if (mounted) {
              setState(() {
                error = 'Error rendering PDF: $e';
                loading = false;
              });
            }
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
          SizedBox(
            width: 80,
            height: 80,
            child: CircularProgressIndicator(
              value: progress == 0 ? null : progress,
              strokeWidth: 6,
              backgroundColor: Colors.grey.shade800,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            progress == 0
                ? 'Preparing document...'
                : 'Downloading ${(progress * 100).toStringAsFixed(0)}%',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (progress > 0 && progress < 1)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Please wait...',
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 14,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ================= ERROR =================

  Widget _buildError() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              color: Colors.red.shade300,
              size: 64,
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to Load PDF',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              error ?? 'Unknown error',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _loadPdf,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
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
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}