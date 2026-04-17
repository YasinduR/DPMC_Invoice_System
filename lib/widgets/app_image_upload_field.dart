import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:myapp/theme/app_colors.dart';

class ImageUploadField extends StatefulWidget {
  final String label;
  final ValueChanged<File?> onImageSelected;
  final File? selectedImage; // 👈 add this

  const ImageUploadField({
    super.key,
    required this.label,
    required this.onImageSelected,
    required this.selectedImage,
  });

  @override
  State<ImageUploadField> createState() => _ImageUploadFieldState();
}

class _ImageUploadFieldState extends State<ImageUploadField> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _image = widget.selectedImage; // 👈 set initial value
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await _picker.pickImage(source: source, imageQuality: 70);

    if (picked != null) {
      setState(() {
        _image = File(picked.path);
      });
      widget.onImageSelected(_image);
    }
  }

  void _showPickerOptions() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => SafeArea(
            child: Wrap(
              children: [
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Take Photo'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Choose from Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _removeImage() {
    setState(() {
      _image = null;
    });
    widget.onImageSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _showPickerOptions,
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(
                color:
                    _image == null
                        ? AppColors.borderIntense
                        : AppColors.primary, // highlight when image exists
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child:
                _image == null
                    ? SizedBox(
                      height: 150,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.upload_file,
                              size: 40,
                              color: AppColors.borderIntense,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Upload Image',
                              style: TextStyle(
                                color: AppColors.borderIntense,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    : Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 300, // 👈 prevents huge images
                            ),
                            child: Image.file(
                              _image!,
                              width: double.infinity,
                              fit: BoxFit.fitWidth, // 👈 dynamic height
                            ),
                          ),
                        ),

                        // ❌ Remove button
                        Positioned(
                          right: 8,
                          top: 8,
                          child: GestureDetector(
                            onTap: _removeImage,
                            child: Container(
                              decoration: BoxDecoration(
                                color: AppColors.black,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(4.0),
                                child: Icon(
                                  Icons.close,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
          ),
        ),
      ],
    );
  }
}
