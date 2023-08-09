import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import './item_card.dart';

class FilesListing extends StatefulWidget {
  const FilesListing({super.key, required this.fetchFunction});

  final Function fetchFunction;

  @override
  State<FilesListing> createState() => _FilesListingState();
}

class _FilesListingState extends State<FilesListing> {
  List<Plugin> _filesList = [];
  bool _isLoading = true;
  int? _selectedIndex;

  Future<List<Plugin>> fetchFiles() async {
    _isLoading = true;
    final list = await widget.fetchFunction();
    setState(() {
      _filesList = list;
      _isLoading = false;
    });
    // await widget.fetchFunction();
    // List<Plugin> list = [];
    return list;
  }

  @override
  void initState() {
    super.initState();
    fetchFiles();
  }

  @override
  Widget build(BuildContext context) {
    double screenSize = (MediaQuery.of(context).size.width - 64);
    double cardSize = UiUtils.calculateCardSize(screenSize);
    return Skeleton(
      isLoading: _isLoading,
      skeleton: SkeletonAvatar(
        style: SkeletonAvatarStyle(
          width: double.infinity,
          height: cardSize,
          padding: const EdgeInsets.all(8),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: SizedBox(
        height: cardSize,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: null,
          itemCount: _filesList.length,
          itemBuilder: (BuildContext context, int index) {
            return ItemCard(index: index, file: _filesList[index]);
          },
        ),
      ),
    );
  }
}
