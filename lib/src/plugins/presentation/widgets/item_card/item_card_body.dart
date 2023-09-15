import 'package:appflowy_theme_marketplace/src/authentication/application/auth_bloc/auth_bloc.dart';
import 'package:appflowy_theme_marketplace/src/plugins/application/factories/user_factory.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import '../../../../widgets/error_dialog.dart';
import '../../../../widgets/ui_utils.dart';
import '../../../domain/models/plugin.dart';
import '../../../domain/models/user.dart';
import '../rating_form.dart';
import 'download_dialog.dart';
import 'price_tag.dart';

class ItemCardBody extends StatelessWidget {
  const ItemCardBody({
    super.key,
    required this.file,
  });
  final Plugin file;
  
  void _showDownloadDialog(BuildContext context, User user) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return DownloadDialog(plugin: file, user: user);
      },
    );
  }

  void _showRequireLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const ErrorDialog(message: 'Please log in to make purchase');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final User uploader = file.uploader;
      
    final Widget uploaderDetails = Row(
      children: [
        const CircleAvatar(
          backgroundColor: Colors.black,
          radius: UiUtils.sizeS,
          child: Icon(Icons.person, size: UiUtils.sizeL),
        ),
        const SizedBox(width: UiUtils.sizeS),
        Text(
          (uploader.name == '' || uploader.name == null) ? 'Unknown' : uploader.name!,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );

    final Widget ratingDetails = Row(
      children: [
        RatingBar.builder(
          initialRating: file.rating,
          minRating: 1,
          direction: Axis.horizontal,
          ignoreGestures: true,
          allowHalfRating: true,
          itemCount: 5,
          itemSize: UiUtils.sizeM,
          itemPadding: const EdgeInsets.symmetric(
            horizontal: 0.0,
            vertical: 0.0,
          ),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (r) {},
        ),
        Text(
          '(${file.ratingCount})',
          style: const TextStyle(
            decoration: TextDecoration.underline,
            color: UiUtils.blue,
            fontSize: UiUtils.sizeL,
          ),
        ),
      ],
    );

    final downloadButton = ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(UiUtils.sizeL),
        ),
      ),
      child: const Icon(
        Icons.download,
        color: Colors.white,
        size: UiUtils.sizeXL,
      ),
      onPressed: () {
        AuthState userStatus = context.read<AuthBloc>().state;
        if (userStatus is AuthenticateSuccess){
          final user = userStatus.user;
          if (user == null)
            throw Exception('Could not find user');
          final pluginUser = UserFactory.fromAuth(user);
          _showDownloadDialog(context, pluginUser);
        }
        else {
          _showRequireLoginDialog(context);
        }
      }
    );

    final Widget featuresBar = Row(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return RatingForm(file, file.rating);
              },
            );
          },
          child: ratingDetails,
        ),
        const SizedBox(width: UiUtils.sizeS),
        const Spacer(),
        SizedBox(
          height: UiUtils.sizeXL,
          child: downloadButton,
        ),
      ],
    );
    
    return Stack(
      children: [
        PriceTag(price: file.price),
        Padding(
          padding: const EdgeInsets.all(UiUtils.sizeS),
          child: Column(
            children: [
              const Expanded(
                child: Icon(
                  Icons.folder,
                  size: UiUtils.sizeXXL * 2,
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Text(file.name),
              ),
              const SizedBox(height: UiUtils.sizeS),
              uploaderDetails,
              const SizedBox(height: UiUtils.sizeS),
              featuresBar,
            ],
          ),
        ),
      ],
    );
  }
}