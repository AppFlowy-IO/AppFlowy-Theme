import 'package:appflowy_theme_marketplace/src/plugins/presentation/widgets/item_card/item_card_detail.dart';
import 'package:appflowy_theme_marketplace/src/widgets/star_rating_bar.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import '../../../domain/models/plugin.dart';

class ItemListile extends StatefulWidget {
  const ItemListile({
    super.key,
    required this.file,
    required this.index,
  });

  final Plugin file;
  final int index;

  @override
  State<ItemListile> createState() => _ItemListileState();
}

class _ItemListileState extends State<ItemListile> {

  @override
  Widget build(BuildContext context) {
    void showCardDetails(Plugin plugin) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return ItemCardDetails(fileContent: plugin);
        },
      );
    }
    return ListTile(
      enabled: true,
      dense: false,
      horizontalTitleGap: 0.0,
      selectedColor: UiUtils.blue,
      selectedTileColor: Colors.grey[800],
      splashColor: UiUtils.transparent,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: UiUtils.sizeL,
      ),
      leading: const SizedBox(
        height: double.infinity,
        child: Icon(Icons.file_copy),
      ),
      title: Text(widget.file.name),
      subtitle: Text(widget.file.uploader.email ?? widget.file.uploader.uid),
      trailing: SizedBox(
        width: 200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            StarRatingBar(rating: widget.file.rating),
            Text(
              '(${widget.file.ratingCount})',
              style: const TextStyle(
                decoration: TextDecoration.underline,
                color: UiUtils.blue,
                fontSize: UiUtils.sizeL,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        showCardDetails(widget.file);
      },
    );
  }
}