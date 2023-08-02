
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../models/plugin_zip_file.dart';
import '../utils/ui_utils.dart';

class ItemCardDetails extends StatefulWidget {
  const ItemCardDetails({super.key, required this.fileContent});
  final PluginZipFile fileContent;

  @override
  State<ItemCardDetails> createState() => _ItemCardDetailsState();
}

class _ItemCardDetailsState extends State<ItemCardDetails> {
  @override
  Widget build(BuildContext context) {
    List<Widget> fileContent = widget.fileContent.toJson().entries.map((entry) {
      if(entry.key == 'rating') {
        return ListTile(
          title: Text(entry.key),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: UiUtils.sizeM),
              RatingBar.builder(
                initialRating: widget.fileContent.rating,
                direction: Axis.horizontal,
                ignoreGestures: true,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: UiUtils.sizeXL,
                itemPadding: const EdgeInsets.symmetric(
                  horizontal: 0.0,
                  vertical: 0.0,
                ),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (_) {},
              ),
            ],
          ),
        );
      }
      else {
        return ListTile(
          title: Text(entry.key),
          subtitle: Text(entry.value.toString()),
        );
      }
    }).toList();

    return AlertDialog(
      title: Row(
        children: [
          const Text('File details'),
          const Spacer(),
          IconButton(
            splashColor: Colors.transparent,
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
      content: Container(
        width: MediaQuery.of(context).size.width * (1/3),
        height: MediaQuery.of(context).size.height * (2/3),
        color: Colors.grey[800],
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          controller: null,
          itemCount: fileContent.length,
          itemBuilder: (BuildContext context, int index) {
            return fileContent[index];
          },
        )
      ),
      actions: const [
        
      ],
    );
  }
}