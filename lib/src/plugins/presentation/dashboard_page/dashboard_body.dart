import 'package:appflowy_theme_marketplace/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../widgets/files_listing.dart';
import '../widgets/item_card/item_card.dart';
import '../widgets/list_category_text.dart';
import '../../application/plugin/plugin_bloc.dart';
import '../../application/search/plugin_search_bloc.dart';
import '../../domain/repositories/plugin_repository.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({super.key});

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
              child: BlocBuilder<PluginSearchBloc, PluginSearchState>(
                builder: (BuildContext context, PluginSearchState state) {
                  if (state is EmptySearch) {
                    return Column(
                      children: [
                        const SizedBox(height: 32),
                        const ListCategoryText('Recently Added'),
                        FilesListing(fetchFunction: getIt.get<PluginRepository>().byDate),
                        const SizedBox(height: 32),
                        const ListCategoryText('Most Rated'),
                        FilesListing(fetchFunction: getIt.get<PluginRepository>().byRatings),
                        const SizedBox(height: 32),
                        const ListCategoryText('Most Downloaded'),
                        FilesListing(fetchFunction: getIt.get<PluginRepository>().byDownloadCount),
                        const SizedBox(height: 32),
                        const ListCategoryText('Featured'),
                        FilesListing(fetchFunction: getIt.get<PluginRepository>().list),
                      ],
                    );
                  } else if (state is SearchLoading) {
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  } else if (state is SearchSuccess) {
                    List<Widget> files = List.generate(
                        state.filesList.length, (index) => ItemCard(index: index, file: state.filesList[index]));
                    return Wrap(
                      children: files,
                    );
                  }
                  else if (state is SearchFailed)
                    return const Text('error');
                  else
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
