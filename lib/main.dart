import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // камера
import 'dart:io'; // для збережння фото на телефоні
import 'dart:async'; // взаємодія з нативним коддом
import 'package:flutter/services.dart'; // взаємодія з методами

void main() {
  runApp(const NativeFeaturesApp());
}

class NativeFeaturesApp extends StatelessWidget {
  const NativeFeaturesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: NativeFeaturesPage(),
    );
  }
}

class NativeFeaturesPage extends StatefulWidget {
  const NativeFeaturesPage({super.key});

  @override
  _NativeFeaturesPageState createState() => _NativeFeaturesPageState();
}

class _NativeFeaturesPageState extends State<NativeFeaturesPage> {
  // Змінна для отримання статичного рядка з нативного коду
  String _nativeMessage = 'Press the button to call native code!';
  // Змінна для збереження зображення
  File? _image;

  // MethodChannel для звернення до нативного коду
  static const platform = MethodChannel('com.example.native_features/native');

  // Метод для отримання повідомлення з нативного коду
  Future<void> _getNativeMessage() async {
    try {
      final String result = await platform.invokeMethod('getNativeMessage');
      setState(() {
        _nativeMessage = result;
      });
    } catch (e) {
      setState(() {
        _nativeMessage = 'Failed to get native message: $e';
      });
    }
  }

  // Метод для отримання фото з камери
  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);

    if (photo != null) {
      setState(() {
        _image = File(photo.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Native Features Example')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Кнопка виклику нативного коду
            ElevatedButton(
              onPressed: _getNativeMessage,
              child: const Text('Call Native Code'),
            ),
            const SizedBox(height: 16),
            Text(
              _nativeMessage,
              style: const TextStyle(fontSize: 16),
            ),
            const Divider(),
            // Кнопка відкриття камери
            ElevatedButton(
              onPressed: _pickImage,
              child: const Text('Take a Photo'),
            ),
            const SizedBox(height: 16),
            // Відображення зображення
            _image != null
                ? Image.file(_image!)
                : const Text('No image taken yet.'),
          ],
        ),
      ),
    );
  }
}
