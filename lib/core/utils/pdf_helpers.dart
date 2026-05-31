import 'package:pdf/pdf.dart';

PdfColor lighten(PdfColor color, double amount) {
  final i = color.toInt();
  final r = ((i >> 16) & 0xff) + ((255 - ((i >> 16) & 0xff)) * amount).round().clamp(0, 255);
  final g = ((i >> 8) & 0xff) + ((255 - ((i >> 8) & 0xff)) * amount).round().clamp(0, 255);
  final b = (i & 0xff) + ((255 - (i & 0xff)) * amount).round().clamp(0, 255);
  return PdfColor.fromInt((0xFF << 24) | (r << 16) | (g << 8) | b);
}

PdfColor darken(PdfColor color, double amount) {
  final i = color.toInt();
  final r = (((i >> 16) & 0xff) * (1 - amount)).round().clamp(0, 255);
  final g = (((i >> 8) & 0xff) * (1 - amount)).round().clamp(0, 255);
  final b = ((i & 0xff) * (1 - amount)).round().clamp(0, 255);
  return PdfColor.fromInt((0xFF << 24) | (r << 16) | (g << 8) | b);
}

PdfColor whiteWithOpacity(double opacity) {
  final alpha = (opacity * 255).round().clamp(0, 255);
  return PdfColor.fromInt((alpha << 24) | 0xFFFFFF);
}
