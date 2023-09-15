import 'package:appflowy_theme_marketplace/src/plugins/domain/models/plugin.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:skeletons/skeletons.dart';
import './item_card/item_card.dart';

class FilesListing extends StatefulWidget {
  const FilesListing({super.key, required this.fetchFunction});

  final Function fetchFunction;

  @override
  State<FilesListing> createState() => _FilesListingState();
}

class _FilesListingState extends State<FilesListing> {
  int currentPage = 0;
    
  final PageController _pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );
  
  Future<List<Plugin>> fetchFiles() async {
    debugPrint('fetching files...');
    final List<Plugin> list = await widget.fetchFunction();
    return list;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  List<Widget> subWidgetsList(List<Widget> list, int curIndex, int cardsPerPage) {
    int start = curIndex * cardsPerPage;
    int end = start + cardsPerPage;
    if (end > list.length) {
      end = start + (list.length % cardsPerPage);
    }
    return list.sublist(start, end);
  }

  void nextPage() {
    setState(() {
      currentPage++;
    });
    _pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void prevPage() {
    setState(() {
      currentPage--;
    });
    _pageController.animateToPage(
      currentPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Row showControlButtons(int cardsPerPage, int numCards) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IconButton(
          onPressed: (currentPage > 0) ? prevPage : null,
          icon: const Icon(Icons.chevron_left_sharp),
          splashColor: UiUtils.transparent,
          splashRadius: UiUtils.sizeL,
        ),
        const SizedBox(width: UiUtils.sizeL),
        IconButton(
          onPressed: (currentPage < (numCards / cardsPerPage).floor()) ? nextPage : null,
          icon: const Icon(Icons.chevron_right_sharp),
          splashColor: UiUtils.transparent,
          splashRadius: UiUtils.sizeL,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final double screenSize = (MediaQuery.of(context).size.width - 64);
    final double cardSize = UiUtils.calculateCardSize(screenSize);
    final cardsPerPage = ScreenSize.from(screenSize).numCards;
    return FutureBuilder(
      future: fetchFiles(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if(snapshot.hasData){
          final List<Plugin> filesList = snapshot.data;
          final List<Widget> widgetsList = filesList.asMap().entries.map((entry) {
            final int index = entry.key;
            final Plugin plugin = entry.value;
            return ItemCard(index: index, file: plugin);
          }).toList();
          return Column(
            children: [
              showControlButtons(cardsPerPage, filesList.length),
              SizedBox(
                height: cardSize,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (int page) {
                    setState(() {
                      currentPage = page;
                    });
                  },
                  itemCount: (widgetsList.length / cardsPerPage).ceil(),
                  itemBuilder: (BuildContext context, int index) {
                    return Row(
                      children: subWidgetsList(widgetsList, index, cardsPerPage),
                    );
                  },
                ),
              ),
            ],
          );
        }
        return Skeleton(
          isLoading: !snapshot.hasData,
          skeleton: SkeletonAvatar(
            style: SkeletonAvatarStyle(
              width: double.infinity,
              height: cardSize,
              padding: const EdgeInsets.all(8),
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const SizedBox(),
        );
      },
    );
  }
}
