import 'package:flutter/material.dart';
import 'app/app.dart';
import 'core/di/injection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Injection.configure();
  runApp(const ForgeMomentsApp());
}
