import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'data/models/cv_data.dart';
import 'data/repositories/hive_cv_repository.dart';
import 'providers/cv_provider.dart';
import 'app.dart';

const _seedVersion = 3;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final repository = HiveCVRepository();
  await repository.init();

  final currentVersion = repository.getSeedVersion();
  if (currentVersion < _seedVersion) {
    await repository.deleteAll();
    await _seedSampleCv(repository);
    await repository.setSeedVersion(_seedVersion);
  }

  runApp(
    ProviderScope(
      overrides: [
        cvRepositoryProvider.overrideWithValue(repository),
      ],
      child: const CVMakerApp(),
    ),
  );
}

Future<String?> _generateSamplePhoto() async {
  try {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 256.0;
    final center = Offset(size / 2, size / 2);
    final radius = size / 2;

    canvas.drawCircle(center, radius, Paint()..color = const Color(0xFF6C63FF));
    canvas.drawCircle(center, radius - 4, Paint()
      ..color = const Color(0xFF6C63FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2);

    final builder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontSize: 100,
      fontWeight: FontWeight.bold,
      fontFamily: 'Inter',
    ))
      ..pushStyle(ui.TextStyle(color: const Color(0xFFFFFFFF)))
      ..addText('AJ');
    final paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: size));
    canvas.drawParagraph(paragraph, Offset(0, (size - paragraph.height) / 2));

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.toInt(), size.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/sample_photo.png');
    await file.writeAsBytes(byteData.buffer.asUint8List());
    return file.path;
  } catch (_) {
    return null;
  }
}

Future<void> _seedSampleCv(HiveCVRepository repository) async {
  final photoPath = await _generateSamplePhoto();
  final sample = CVData(
    title: 'Alex Johnson - Flutter Developer',
    templateId: 'modern',
    primaryColor: 0xFF6C63FF,
    showPhoto: photoPath != null,
    personalInfo: PersonalInfo(
      fullName: 'Alex Johnson',
      photoPath: photoPath ?? '',
      email: 'alex.johnson@email.com',
      phone: '+1 (555) 123-4567',
      linkedIn: 'linkedin.com/in/alexjohnson',
      github: 'github.com/alexjohnson',
      portfolio: 'alexjohnson.dev',
      address: 'San Francisco, CA',
      jobTitle: 'Senior Flutter Developer',
      nationality: 'American',
    ),
    summary:
        'Senior Flutter Developer with 6+ years of experience building cross-platform mobile and web applications. Passionate about clean architecture, state management, and delivering delightful user experiences. Proven track record of leading teams and delivering apps with millions of users.',
    experiences: [
      Experience(
        company: 'TechCorp Inc.',
        position: 'Senior Flutter Developer',
        startDate: DateTime(2022, 3),
        current: true,
        description:
            'Leading the mobile team in building a fintech app serving 2M+ users. Architected the state management layer using Riverpod and implemented complex animation systems.',
        highlights: [
          'Reduced app size by 40% through code-splitting and lazy loading',
          'Led migration from Provider to Riverpod across 200+ screens',
          'Mentored 4 junior developers through structured code reviews',
        ],
      ),
      Experience(
        company: 'StartupXYZ',
        position: 'Mobile Developer',
        startDate: DateTime(2019, 6),
        endDate: DateTime(2022, 2),
        description:
            'Built and maintained a cross-platform e-commerce app from scratch. Implemented CI/CD pipeline and automated testing.',
        highlights: [
          'Developed custom widget library used across 3 product lines',
          'Integrated payment gateways (Stripe, PayPal)',
          'Achieved 98% crash-free rate on both platforms',
        ],
      ),
      Experience(
        company: 'WebAgency Co.',
        position: 'Junior Developer',
        startDate: DateTime(2017, 9),
        endDate: DateTime(2019, 5),
        description:
            'Developed responsive web applications using React and Angular. Transitioned to Flutter for mobile projects.',
      ),
    ],
    educations: [
      Education(
        institution: 'University of California, Berkeley',
        degree: 'Bachelor of Science',
        field: 'Computer Science',
        startDate: DateTime(2013, 9),
        endDate: DateTime(2017, 6),
        gpa: 3.7,
      ),
    ],
    skills: [
      Skill(name: 'Flutter', category: 'Technical', level: 5),
      Skill(name: 'Dart', category: 'Technical', level: 5),
      Skill(name: 'Riverpod', category: 'Technical', level: 4),
      Skill(name: 'Firebase', category: 'Technical', level: 4),
      Skill(name: 'Git', category: 'Technical', level: 5),
      Skill(name: 'REST APIs', category: 'Technical', level: 4),
      Skill(name: 'SQLite/Hive', category: 'Technical', level: 4),
      Skill(name: 'UI/UX Design', category: 'Design', level: 3),
      Skill(name: 'Agile/Scrum', category: 'Management', level: 4),
    ],
    languages: [
      Language(name: 'English', level: 'C2 - Native'),
      Language(name: 'Spanish', level: 'B1 - Intermediate'),
      Language(name: 'French', level: 'A2 - Elementary'),
    ],
    projects: [
      Project(
        name: 'OpenWeather Flutter Plugin',
        description:
            'Open-source Flutter package for weather data with animated widgets and offline caching. 500+ GitHub stars.',
        techStack: 'Flutter, Dart, REST APIs, Hive',
        url: 'github.com/alexjohnson/weather_plugin',
        startDate: DateTime(2023, 1),
        endDate: DateTime(2023, 6),
      ),
      Project(
        name: 'FitTracker App',
        description:
            'Cross-platform fitness tracking app with progress charts, workout plans, and social features.',
        techStack: 'Flutter, Firebase, BLoC, Google Fit API',
        startDate: DateTime(2022, 8),
        endDate: DateTime(2023, 2),
      ),
    ],
    certifications: [
      Certification(
        name: 'Google Associate Android Developer',
        issuer: 'Google',
        date: DateTime(2021, 11),
      ),
      Certification(
        name: 'Flutter & Dart - The Complete Guide',
        issuer: 'Udemy',
        date: DateTime(2020, 6),
      ),
    ],
  );
  await repository.save(sample);
}
