import 'package:appflowy_theme_marketplace/src/blocs/auth_bloc/auth_state.dart';
import 'package:appflowy_theme_marketplace/src/utils/ui_utils.dart';
import 'package:appflowy_theme_marketplace/src/widgets/item_card_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:collection';
import 'dart:html' as html;

import '../models/plugin_zip_file.dart';
import '../models/uploader.dart';
import '../blocs/auth_bloc/auth_bloc.dart';
import '../payment/stripe.dart';
import '../utils/firestore_utils.dart';
import 'rating_form.dart';

class ItemCard extends StatefulWidget {
  const ItemCard({super.key, required this.index, required this.file});

  final int index;
  final QueryDocumentSnapshot<Object?> file;

  @override
  State<ItemCard> createState() => _ItemCardState();
}

class _ItemCardState extends State<ItemCard> {
  bool isHovered = false;

  dynamic _showPurchaseDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('purchase'),
          content: ElevatedButton(
            onPressed: _purchaseItem,
            child: const Text('Purchase'),
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Complete'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<void> _purchaseItem() async {
    final fileMap = Map<String, dynamic>.from(widget.file.data() as LinkedHashMap);
    final PluginZipFile zipFile = PluginZipFile.fromJson(fileMap);
    try{
      //TODO: handles all errors check, refactor into server work
      //NOTE: server should only return redirect url to client
      final newProduct = await Stripe.createProduct(zipFile);
      UploaderData uploaderData = await FireStoreUtils.getUserDataByMail(zipFile.uploader['email']);
      if(uploaderData.stripeId == null || uploaderData.stripeId == '')
        throw Exception('user is not registered to be a seller');
      final newCheckoutSession = await Stripe.createInvoice(uploaderData.stripeId!, newProduct['default_price']['id'], 10);
      html.window.location.assign(newCheckoutSession['url']);
    } on Exception catch(e){
      rethrow;
    }
  }
  @override
  Widget build(BuildContext context) {
    final fileMap = Map<String, dynamic>.from(widget.file.data() as LinkedHashMap);
    final PluginZipFile zipFile = PluginZipFile.fromJson(fileMap);
    final UploaderData uploader = UploaderData.fromJson(zipFile.uploader);
    final double screenSize = (MediaQuery.of(context).size.width - UiUtils.sizeXXL * 2);

    return MouseRegion(
      onEnter: (_) {
        setState(() {
          isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          isHovered = false;
        });
      },
      child: GestureDetector(
        onTap: () => showDialog(
          context: context,
          builder: (BuildContext context) => ItemCardDetails(fileContent: zipFile),
        ),
        child: Container(
          padding: const EdgeInsets.all(UiUtils.sizeS),
          width: UiUtils.calculateCardSize(screenSize),
          height: UiUtils.calculateCardSize(screenSize),

          child: AnimatedContainer(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, UiUtils.sizeS),
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color:Colors.grey[800],
              borderRadius: BorderRadius.circular(UiUtils.sizeS),
              boxShadow: [
                BoxShadow(
                  color: isHovered ? Colors.grey[700]! : Colors.black54,
                  offset: const Offset(UiUtils.sizeXS/2, UiUtils.sizeXS/2),
                  blurRadius: UiUtils.sizeXS/2,
                  spreadRadius: UiUtils.sizeXS/2,
                ),
              ],
            ),
            child: Stack(
              children: [
                Positioned(
                  top: UiUtils.sizeS,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: UiUtils.sizeM, vertical: UiUtils.sizeXS),
                    decoration: const BoxDecoration(
                      color: UiUtils.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(UiUtils.sizeL),
                        bottomLeft: Radius.circular(UiUtils.sizeL),
                        topRight: Radius.zero,
                        bottomRight: Radius.zero,
                      ),
                    ),
                    child: Text(
                      zipFile.price == 0 ? 'Free' : '${zipFile.price}\$',
                      style: const TextStyle(color: Colors.white, fontSize: UiUtils.sizeL),
                    ),
                  ),
                ),
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
                        child: Text(zipFile.name),
                      ),
                      const SizedBox(height: UiUtils.sizeS),
                      Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: UiUtils.sizeS,
                            child: Icon(Icons.person, size: UiUtils.sizeL),
                          ),
                          const SizedBox(width: UiUtils.sizeS),
                          Text(
                            uploader.name == '' ? 'anonymous' : uploader.name!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      const SizedBox(height: UiUtils.sizeS),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return RatingForm(widget.file.id, zipFile.rating);
                                },
                              );
                            },
                            child: Row(
                              children: [
                                RatingBar.builder(
                                  initialRating: zipFile.rating,
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
                                  '(${zipFile.ratingCount})',
                                  style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: UiUtils.blue,
                                    fontSize: UiUtils.sizeL,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: UiUtils.sizeS),
                          const Spacer(),
                          SizedBox(
                            height: UiUtils.sizeXL,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(UiUtils.sizeL),
                                ),
                              ),
                              //TODO: if the file is not free, display a buy button, if logged in user already bought the file, display download
                              child: zipFile.price == 0 ? const Icon( 
                                Icons.download,
                                color: Colors.white,
                                size: UiUtils.sizeXL,
                              ) : const Text('Buy'),
                              onPressed: () async {
                                if(zipFile.downloadURL != ''){
                                  // only count the download number for logged in user
                                  if(context.read<AuthBloc>().state is AuthenticateSuccess)
                                    await FireStoreUtils.incrementDownloadCount(widget.file.id);
                                  await launchUrl(Uri.parse(zipFile.downloadURL));
                                }
                                else {
                                  //TODO: if the user purchased the item,
                                  //find a way to give them a temporary download url
                                  _showPurchaseDialog(context);
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// class _ItemCardState extends State<ItemCard> {}
