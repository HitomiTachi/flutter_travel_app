import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/material.dart';

class ShareService {
  // Chia sẻ text
  Future<void> shareText(String text, {String? subject}) async {
    await Share.share(text, subject: subject);
  }

  // Chia sẻ điểm đến
  Future<void> shareLocation({
    required String name,
    required String description,
    String? imageUrl,
    double? rating,
    String? address,
  }) async {
    final text =
        '''
📍 $name

$description
${rating != null ? '⭐ Rating: $rating/5.0' : ''}
${address != null ? '📍 Địa chỉ: $address' : ''}

Được chia sẻ từ Travel App
    ''';

    await Share.share(text);
  }

  // Chia sẻ lịch trình
  Future<void> shareTripPlan({
    required String title,
    required String destination,
    required String startDate,
    required String endDate,
    required int travelers,
    List<String>? activities,
  }) async {
    final activitiesText = activities != null && activities.isNotEmpty
        ? '\n📋 Hoạt động:\n${activities.map((a) => '  • $a').join('\n')}'
        : '';

    final text =
        '''
✈️ Lịch trình du lịch

📌 Tiêu đề: $title
📍 Điểm đến: $destination
📅 Ngày đi: $startDate
📅 Ngày về: $endDate
👥 Số người: $travelers$activitiesText

Được chia sẻ từ Travel App
    ''';

    await Share.share(text);
  }

  // Export lịch trình thành PDF
  Future<void> exportTripPlanToPDF({
    required String title,
    required String destination,
    required String startDate,
    required String endDate,
    required int travelers,
    List<Map<String, dynamic>>? dailyPlans,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text(
                'Lịch trình du lịch',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Tiêu đề: $title', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            pw.Text(
              'Điểm đến: $destination',
              style: pw.TextStyle(fontSize: 16),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Ngày đi: $startDate', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            pw.Text('Ngày về: $endDate', style: pw.TextStyle(fontSize: 16)),
            pw.SizedBox(height: 10),
            pw.Text('Số người: $travelers', style: pw.TextStyle(fontSize: 16)),
            if (dailyPlans != null && dailyPlans.isNotEmpty) ...[
              pw.SizedBox(height: 20),
              pw.Header(
                level: 1,
                child: pw.Text(
                  'Lịch trình chi tiết',
                  style: pw.TextStyle(
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
              ),
              ...dailyPlans.map(
                (plan) => pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.SizedBox(height: 10),
                    pw.Text(
                      'Ngày ${plan['day']}: ${plan['date']}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (plan['activities'] != null)
                      ...(plan['activities'] as List).map(
                        (activity) => pw.Text(
                          '  • $activity',
                          style: pw.TextStyle(fontSize: 12),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ];
        },
      ),
    );

    // Share PDF
    final bytes = await pdf.save();
    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/trip_plan_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
    await file.writeAsBytes(bytes);

    await Share.shareXFiles([XFile(file.path)], text: 'Lịch trình du lịch');
  }

  // Export lịch trình thành hình ảnh (screenshot)
  Future<void> exportTripPlanToImage(GlobalKey screenshotKey) async {
    try {
      // Sử dụng screenshot package hoặc export widget thành image
      // Implementation depends on screenshot package
    } catch (e) {
      // Fallback
    }
  }

  // Chia sẻ qua social media
  Future<void> shareToSocial({required String text, String? imagePath}) async {
    if (imagePath != null && File(imagePath).existsSync()) {
      await Share.shareXFiles([XFile(imagePath)], text: text);
    } else {
      await Share.share(text);
    }
  }
}
