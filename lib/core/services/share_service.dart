import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:csv/csv.dart';
import '../../features/payments/models/payment_session_model.dart';

/// ShareService - Handles all sharing and export functionality
class ShareService {
  /// Share text content (simple share)
  static Future<void> shareText(String text, {String? subject}) async {
    try {
      await Share.share(text, subject: subject);
    } catch (e) {
      debugPrint('Error sharing text: $e');
      rethrow;
    }
  }

  /// Share session URL
  static Future<void> shareSessionUrl(String url, String sessionId) async {
    final text = 'Pay me via Vector:\n$url\n\nSession ID: $sessionId';
    await shareText(text, subject: 'Vector Payment Session');
  }

  /// Export payment session to CSV
  static Future<void> exportSessionToCSV(PaymentSession session) async {
    try {
      // Prepare CSV data
      List<List<dynamic>> rows = [
        ['Payment Session Report'],
        ['Session ID', session.id],
        ['Started', session.startedAt.toString()],
        ['Status', session.status == SessionStatus.active ? 'Active' : 'Ended'],
        [],
        ['Payment Details'],
        ['#', 'Time', 'Payer Name', 'Amount', 'Transaction Ref'],
      ];

      // Add payment rows
      for (int i = 0; i < session.payments.length; i++) {
        final payment = session.payments[i];
        rows.add([i + 1, payment.timeOnly, payment.payerName, payment.formattedAmount, payment.transactionReference]);
      }

      // Add summary rows
      rows.addAll([
        [],
        ['Summary'],
        ['Total Payments', session.paymentsCount],
        ['Total Amount', session.formattedTotalAmount],
        ['Processing Fee (1.3%)', session.formattedTotalFees],
        ['Net Amount', session.formattedNetAmount],
      ]);

      // Convert to CSV string
      String csv = const ListToCsvConverter().convert(rows);

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/vector_session_${session.id}.csv';
      final file = File(path);
      await file.writeAsString(csv);

      // Share the CSV file
      await Share.shareXFiles(
        [XFile(path, mimeType: 'text/csv')],
        subject: 'Vector Session ${session.id} - Export',
        text: 'Payment session data exported from Vector',
      );
    } catch (e) {
      debugPrint('Error exporting to CSV: $e');
      rethrow;
    }
  }

  /// Export payment session to PDF
  static Future<void> exportSessionToPDF(PaymentSession session) async {
    try {
      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (context) => [
            // Header
            pw.Header(
              level: 0,
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Vector Payment Session', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 8),
                  pw.Text('Session ID: ${session.id}', style: const pw.TextStyle(fontSize: 12, color: PdfColors.grey700)),
                  pw.Text('Generated: ${DateTime.now().toString().split('.')[0]}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Session Info
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(color: PdfColors.grey300),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Session Details', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                  pw.SizedBox(height: 12),
                  _buildPdfRow('Started:', session.startedAt.toString().split('.')[0]),
                  _buildPdfRow('Duration:', session.formattedDuration),
                  _buildPdfRow('Status:', session.status == SessionStatus.active ? 'Active' : 'Ended'),
                  if (session.note != null) _buildPdfRow('Note:', session.note!),
                ],
              ),
            ),
            pw.SizedBox(height: 24),

            // Payments Table
            pw.Text('Payments Received', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Table.fromTextArray(
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
              cellStyle: const pw.TextStyle(fontSize: 9),
              headerDecoration: const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 30,
              cellAlignments: {0: pw.Alignment.centerLeft, 1: pw.Alignment.centerLeft, 2: pw.Alignment.centerRight, 3: pw.Alignment.centerLeft},
              headers: ['Time', 'Payer Name', 'Amount', 'Transaction Ref'],
              data: session.payments.map((payment) => [payment.timeOnly, payment.payerName, payment.formattedAmount, payment.transactionReference]).toList(),
            ),
            pw.SizedBox(height: 24),

            // Summary
            pw.Container(
              padding: const pw.EdgeInsets.all(16),
              decoration: pw.BoxDecoration(color: PdfColors.grey100, borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8))),
              child: pw.Column(
                children: [
                  _buildSummaryRow('Total Payments:', '${session.paymentsCount}'),
                  pw.Divider(),
                  _buildSummaryRow('Total Amount:', session.formattedTotalAmount),
                  _buildSummaryRow('Processing Fee (1.3%):', session.formattedTotalFees),
                  pw.Divider(thickness: 2),
                  _buildSummaryRow('Net Amount:', session.formattedNetAmount, isBold: true),
                ],
              ),
            ),
          ],
        ),
      );

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/vector_session_${session.id}.pdf';
      final file = File(path);
      await file.writeAsBytes(await pdf.save());

      // Share the PDF file
      await Share.shareXFiles(
        [XFile(path, mimeType: 'application/pdf')],
        subject: 'Vector Session ${session.id} - Report',
        text: 'Payment session report from Vector',
      );
    } catch (e) {
      debugPrint('Error exporting to PDF: $e');
      rethrow;
    }
  }

  /// Helper to build PDF row
  static pw.Widget _buildPdfRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 100,
            child: pw.Text(label, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
          ),
          pw.Expanded(child: pw.Text(value, style: const pw.TextStyle(fontSize: 10))),
        ],
      ),
    );
  }

  /// Helper to build PDF summary row
  static pw.Widget _buildSummaryRow(String label, String value, {bool isBold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: isBold ? 12 : 11, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(fontSize: isBold ? 12 : 11, fontWeight: isBold ? pw.FontWeight.bold : pw.FontWeight.normal),
          ),
        ],
      ),
    );
  }

  /// Capture widget as PNG and share
  static Future<void> shareWidgetAsPNG(GlobalKey key, {String? filename, String? text}) async {
    try {
      // Find the render object
      RenderRepaintBoundary? boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;

      if (boundary == null) {
        throw Exception('Could not find render boundary');
      }

      // Capture the image
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) {
        throw Exception('Could not convert image to bytes');
      }

      Uint8List pngBytes = byteData.buffer.asUint8List();

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${filename ?? 'vector_qr_${DateTime.now().millisecondsSinceEpoch}'}.png';
      final file = File(path);
      await file.writeAsBytes(pngBytes);

      // Share the PNG file
      await Share.shareXFiles([XFile(path, mimeType: 'image/png')], text: text ?? 'Shared from Vector');
    } catch (e) {
      debugPrint('Error sharing PNG: $e');
      rethrow;
    }
  }

  /// Share session summary as text
  static Future<void> shareSessionSummary(PaymentSession session) async {
    final summary =
        '''
Vector Payment Session Summary

Session ID: ${session.id}
Duration: ${session.formattedDuration}
Status: ${session.status == SessionStatus.active ? 'Active' : 'Ended'}

Payments Received: ${session.paymentsCount}
Total Amount: ${session.formattedTotalAmount}
Processing Fee (1.3%): ${session.formattedTotalFees}
Net Amount: ${session.formattedNetAmount}

${session.note != null ? 'Note: ${session.note}\n' : ''}
Payment Details:
${session.payments.map((p) => '• ${p.timeOnly} - ${p.payerName}: ${p.formattedAmount}').join('\n')}

Powered by Vector
''';

    await shareText(summary, subject: 'Vector Session ${session.id} Summary');
  }
}
