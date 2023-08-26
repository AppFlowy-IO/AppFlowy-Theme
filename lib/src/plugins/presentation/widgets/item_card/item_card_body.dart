import 'package:appflowy_theme_marketplace/src/plugins/application/plugin/plugin_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../../../widgets/ui_utils.dart';
import '../../../domain/models/plugin.dart';
import '../../../domain/models/user.dart';
import '../rating_form.dart';
import 'price_tag.dart';

class ItemCardBody extends StatelessWidget {
  const ItemCardBody({
    super.key,
    required this.file,
    required this.showPurchaseDialog,
  });
  final Plugin file;
  final Function showPurchaseDialog;

  @override
  Widget build(BuildContext context) {
    final AuthState userStatus = context.read<AuthBloc>().state;
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
      //TODO: if the file is not free, display a buy button, if logged in user already bought the file, display download
      //TODO: if the file is owned by uploader? they are not supposed to pay to download their file
      child: file.price == 0 || (userStatus is AuthenticateSuccess && userStatus.user!.uid == uploader.uid)
        ? const Icon(
            Icons.download,
            color: Colors.white,
            size: UiUtils.sizeXL,
          )
        : const Text('Buy'),
      onPressed: () async {
        if (file.downloadURL != '') {
          context.read<PluginBloc>().add(IncrementDownloadCountRequested(file));
          await launchUrl(Uri.parse(file.downloadURL));
        } else {
          //TODO: if the user purchased the item, //find a way to give them a temporary download url
          showPurchaseDialog(context);
        }
      },
    );

    final Widget featuresBar = Row(
      children: [
        GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return RatingForm(file.pluginId, file.rating);
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