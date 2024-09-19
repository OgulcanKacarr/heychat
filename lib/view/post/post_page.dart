import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:heychat/constants/AppSizes.dart';
import 'package:heychat/view_model/post/post_page_view_model.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/widgets/custom_app_bar_widget.dart';

final viewModel = ChangeNotifierProvider((ref) => PostPageViewModel());
class PostPage extends ConsumerStatefulWidget {
  const PostPage({super.key});

  @override
  ConsumerState<PostPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<PostPage> {
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _descriptionController.clear();
  }

  @override
  Widget build(BuildContext context) {
    var watch = ref.watch(viewModel);
    var read = ref.read(viewModel);
    return Scaffold(
      appBar: CustomAppBarWidget(
        title: AppStrings.add_post,
        isBack: false,
        onPressed: () {
          Navigator.pushReplacementNamed(context, "/home_page");
        },
      ),
      body: _buildBody(watch,read),
      bottomNavigationBar: ElevatedButton(
        onPressed: () async {
          // Fotoğrafı paylaş
            watch.sharePost(context, _descriptionController.text);
        },
      child: const Text(AppStrings.share),
      ),

    );
  }

  Widget _buildBody(PostPageViewModel watch, PostPageViewModel read) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildImagePicker(watch,read),
          _buildDescriptionField(),
        ],
      ),
    );
  }

  Widget _buildImagePicker(PostPageViewModel watch, PostPageViewModel read) {
    return Column(
      children: [
        Container(
          width: AppSizes.screenWidth(context),
          height: AppSizes.screenHeight(context) * 0.5,
          child: watch.getSelectedImage != null
              ? Image.file(watch.getSelectedImage!)
              : const Center(child: Text(AppStrings.noPostSelectPhoto)),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(onPressed: ()async{
           await watch.selectPhoto(context, _descriptionController.text);
          }, icon: const Icon(Icons.camera_alt_rounded)),
        )
      ],
    );
  }

  Widget _buildDescriptionField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        controller: _descriptionController,
        maxLines: 2,
        textInputAction: TextInputAction.done,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: AppStrings.description_hint,
        ),
      ),
    );
  }
}
