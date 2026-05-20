import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class FullProfileImageScreen extends StatefulWidget{
  final File? imageFile;
  const FullProfileImageScreen({super.key, required this.imageFile});

  @override
  State<FullProfileImageScreen> createState() => _FullProfileImageScreenState();
}

class _FullProfileImageScreenState extends State<FullProfileImageScreen>{
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState(){
    super.initState();
    _image = widget.imageFile;
  }
  
  @override
  Widget build(BuildContext context) {
    return PopScope<File?>(
      canPop: true,
      onPopInvokedWithResult:(didPop, result){
        if(!didPop){
          Navigator.pop(context, _image);
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF000000),
        appBar: AppBar(
          backgroundColor: const Color(0xFF000000),
          foregroundColor: const Color(0xFFFFF7F5),
          title: const Text("Profile Photo"),
          leading: IconButton(
            onPressed: (){
              Navigator.pop(context, _image);
            }, 
            icon: const Icon(Icons.arrow_back)),
          actions: [
            IconButton(
              onPressed: showEditOption,
              icon: const Icon(Icons.edit))
          ],
        ),
        body: Center(
          child: _image != null
          ? Image.file(_image!, fit: BoxFit.contain,)
          : const Image(image: AssetImage("assets/images/ProfileAvatar.png")),
        ),
      ),
    );
  }

  void showEditOption(){
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_){
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Camera"),
                onTap: (){
                  Navigator.pop(context);
                  pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Gallery"),
                onTap: (){
                  Navigator.pop(context);
                  pickFromGallery();
                },
              ),
            ],
          ),
        );
      }
    );
  }

  Future<void> pickFromCamera() async {
    final status = await Permission.camera.request();

    if (status.isGranted) {
      final image = await _picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        setState(() => _image = File(image.path));
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  Future<void> pickFromGallery() async {
    final status = await Permission.photos.request();

    if (status.isGranted) {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        setState(() => _image = File(image.path));
      }
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }
}
