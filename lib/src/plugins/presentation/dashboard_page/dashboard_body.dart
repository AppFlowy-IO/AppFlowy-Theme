import 'package:appflowy_theme_marketplace/main.dart';
import 'package:appflowy_theme_marketplace/src/plugins/presentation/widgets/item_card/item_listile.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../widgets/icon_button.dart';
import '../../domain/models/plugin.dart';
import '../widgets/files_listing.dart';
import '../widgets/item_card/item_card.dart';
import '../widgets/list_category_text.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/plugin_repository.dart';
import '../../application/search/plugin_search_bloc.dart';
import '../../application/plugin/plugin_bloc.dart';

enum ViewMode {
  grid,
  list,
}

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key, this.user});

  final User? user;

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  late ViewMode _viewMode;
  int? _selectedIndex;
  
  @override
  void initState() {
    super.initState();
    _viewMode = ViewMode.list;
  }

  void gridViewMode() {
    setState(() {
      _viewMode = ViewMode.grid;
    });
  }
  void listViewMode() {
    setState(() {
      _viewMode = ViewMode.list;
    });
  }

  void setSelectedIndex(index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget renderList(List<Plugin> filesList) {
    if (_viewMode == ViewMode.grid) {
      List<Widget> files = List.generate(
        filesList.length,
        (index) {
          return ItemCard(
            index: index,
            file: filesList[index],
          );
        }
      );
      return SizedBox(
        child: Wrap(
          children: files,
        ),
      );
    }
    List<Widget> files = List.generate(
      filesList.length,
      (index) {
        return ItemListile(
          index: index,
          file: filesList[index],
        );
      }
    );
    return Column(
      children: files,
    );
  }

  Column categoryListing = Column(
    children: [
      ContentSpacer.verticalSpacer_32,
      const ListCategoryText('Recently Added'),
      FilesListing(fetchFunction: getIt.get<PluginRepository>().byDate),
      ContentSpacer.verticalSpacer_32,
      const ListCategoryText('Most Rated'),
      FilesListing(fetchFunction: getIt.get<PluginRepository>().byRatings),
      ContentSpacer.verticalSpacer_32,
      const ListCategoryText('Most Downloaded'),
      FilesListing(fetchFunction: getIt.get<PluginRepository>().byDownloadCount),
      ContentSpacer.verticalSpacer_32,
      const ListCategoryText('Featured'),
      FilesListing(fetchFunction: getIt.get<PluginRepository>().list),
    ],
  );
  
  @override
  Widget build(BuildContext context) {
    Row searchModeRow = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        DefaulIconButton(
          onPressed: gridViewMode,
          icon: Icon(
            Icons.list_sharp,
            color: _viewMode == ViewMode.grid ? UiUtils.blue : null,
          ),
        ),
        DefaulIconButton(
          onPressed: listViewMode,
          icon: Icon(
            Icons.grid_view_sharp,
            color: _viewMode == ViewMode.list ? UiUtils.blue : null
          ),
        ),
      ],
    );

    return SingleChildScrollView(
      child: BlocConsumer<PluginBloc, PluginState>(
        listener: (BuildContext context, PluginState state) {
          if (state is PluginUpdated) {
            context.read<PluginBloc>().add(PluginReloadRequested());
          }
        },
        builder: (BuildContext context, PluginState state) {
          if (state is PluginReloading) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: UiUtils.sizeXXL, vertical: 0),
              child: BlocBuilder<PluginSearchBloc, PluginSearchState>(
                builder: (BuildContext context, PluginSearchState state) {
                  if (state is EmptySearch) {
                    return categoryListing;
                  } else if (state is SearchLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is SearchSuccess) {
                    Widget list = renderList(state.filesList);
                    return Column(
                      children: [
                        searchModeRow,
                        list,
                      ],
                    );
                  }
                  return const SizedBox();
                },
              ),
            );
          }
        },
      ),
    );
  }
}
