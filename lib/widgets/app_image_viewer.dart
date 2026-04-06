import 'dart:io';
import 'package:flutter/material.dart';
import 'package:myapp/theme/app_colors.dart';

class ImageViewer extends StatefulWidget {
  final String label;
  final File? image;
  final String emptyMessage;

  const ImageViewer({
    super.key,
    this.label = "Image",
    this.image,
    this.emptyMessage = "No image available",
  });

  @override
  State<ImageViewer> createState() => _ImageViewerState();
}

class _ImageViewerState extends State<ImageViewer> {
  File? _image;

  @override
  void initState() {
    super.initState();
    _image = widget.image; 
  }

  @override
  void didUpdateWidget(covariant ImageViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.image != oldWidget.image) {
      _image = widget.image; 
    }
  }

  void _openPreview() {
    if (_image == null) return;

    showDialog(
      context: context,
      barrierColor: AppColors.black.withOpacity(0.5), // 50% dark overlay
      builder: (_) => Dialog(
        backgroundColor: AppColors.background,
        insetPadding: EdgeInsets.zero,
        child: Stack(
          children: [
            InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: Image.file(_image!),
              ),
            ),

            Positioned(
              top: 40,
              right: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const CircleAvatar(
                  backgroundColor: AppColors.primary,
                  child: Icon(Icons.close, color: AppColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasImage = _image != null;

    

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text(
        //   widget.label,
        //   style: const TextStyle(
        //     fontWeight: FontWeight.bold,
        //     fontSize: 14,
        //     color: AppColors.primary,
        //   ),
      Container(
        width: double.infinity,
        decoration: hasImage
          ? BoxDecoration(
          border: Border.all(color: AppColors.primary),
          borderRadius: BorderRadius.circular(8),
        )
      : null, 
      child: hasImage? 
      GestureDetector(
          onTap: _openPreview,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.file(
              _image!,
              width: double.infinity,
              fit: BoxFit.fitWidth,
            ),
          ),
        )
      : 
      Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Text(
              widget.emptyMessage,
              style: const TextStyle(
                color: AppColors.textFaded,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      )
      ],
    );
  }
}
