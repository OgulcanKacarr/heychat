import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:image_picker/image_picker.dart'; // Fotoğraf seçmek için
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/view_model/feed/feed_page_view_model.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';

final viewModel = ChangeNotifierProvider((ref) => FeedPageViewModel());

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final TextEditingController _descriptionController = TextEditingController();
  ConstMethods _constMethods = ConstMethods();
  //seçilen fotoğraf
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: AppStrings.add_post,
        isBack: false,
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/home_page");
        },
      ),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Fotoğraf seç ve yükle
          setState(() {
            _selectedImage = await _constMethods.selectAndUploadImage(context, imageType: "post", caption: _descriptionController.text);
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImagePicker(),
        _buildDescriptionField(),
      ],
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        Container(
          width: AppSizes.screenWidth(context),
          height: AppSizes.screenHeight(context) * 0.5,
          child: _selectedImage != null
              ? Image.file(_selectedImage!)
              : const Center(child: Text(AppStrings.noPostSelectPhoto)),
        ),
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _descriptionController,
        maxLines: 4,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: AppStrings.description_hint,
        ),
      ),
    );
  }
}
