import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';
import 'package:ventou/variables/colors.dart';

class ImageResizer extends StatefulWidget {
  final File imageFile;
  final Function(File) onImageResized;
  final double defaultWidth;
  final double defaultHeight;

  const ImageResizer({
    Key? key,
    required this.imageFile,
    required this.onImageResized,
    this.defaultWidth = 400,
    this.defaultHeight = 400,
  }) : super(key: key);

  @override
  State<ImageResizer> createState() => _ImageResizerState();
}

class _ImageResizerState extends State<ImageResizer> {
  late File currentImageFile;
  late double currentWidth;
  late double currentHeight;
  bool isResizing = false;
  // Ajouter une clé unique basée sur le timestamp
  final String uniqueKey = DateTime.now().millisecondsSinceEpoch.toString();

  @override
  void initState() {
    super.initState();
    currentImageFile = widget.imageFile;
    currentWidth = widget.defaultWidth;
    currentHeight = widget.defaultHeight;
  }

  @override
  void didUpdateWidget(covariant ImageResizer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageFile.path != oldWidget.imageFile.path) {
      setState(() {
        currentImageFile = widget.imageFile;
        currentWidth = widget.defaultWidth;
        currentHeight = widget.defaultHeight;
      });
    }
  }

Future<void> _resizeImage() async {
  setState(() {
    isResizing = true;
  });

  try {
    final imageBytes = await currentImageFile.readAsBytes();
    final image = img.decodeImage(imageBytes);

    if (image != null) {
      final resizedImage = img.copyResize(
        image,
        width: currentWidth.toInt(),
        height: currentHeight.toInt(),
      );

      final resizedBytes = Uint8List.fromList(img.encodeJpg(resizedImage, quality: 90));

      // Utiliser un fichier temporaire qui ne sera pas immédiatement supprimé
      final tempDir = await getTemporaryDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final tempFile = File('${tempDir.path}/temp_resize_$timestamp.jpg');
      await tempFile.writeAsBytes(resizedBytes);

      widget.onImageResized(tempFile);
    }
  } catch (e) {
    debugPrint('Erreur lors du redimensionnement: $e');
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  } finally {
    setState(() {
      isResizing = false;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: currentWidth,
          height: currentHeight,
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.orange),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              currentImageFile,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          'Dimensions: ${currentWidth.toInt()} x ${currentHeight.toInt()}',
          style: const TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 10),
        Slider(
          value: currentWidth,
          min: 150,
          max: 300,
          divisions: 40,
          activeColor: AppColors.orange,
          label: currentWidth.round().toString(),
          onChanged: (value) {
            setState(() {
              currentWidth = value;
              currentHeight = value; // Maintenir un ratio carré
            });
          },
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: isResizing ? null : _resizeImage,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: isResizing
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : const Text(
                  'Valider',
                  style: TextStyle(fontSize: 16, color: AppColors.blanc),
                ),
        ),
      ],
    );
  }
}
