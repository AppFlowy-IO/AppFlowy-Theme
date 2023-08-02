import 'package:appflowy_theme_marketplace/src/blocs/db_bloc/db_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/db_bloc/db_bloc.dart';
import '../../blocs/db_bloc/db_event.dart';
import '../../blocs/search_file_bloc/search_file_bloc.dart';
import '../../blocs/search_file_bloc/search_file_state.dart';
import '../../utils/firestore_utils.dart';
import '../../widgets/files_listing.dart';
import '../../widgets/item_card.dart';
import '../../widgets/list_category_text.dart';


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
      child: BlocConsumer<DbBloc, DbState>(
        listener: (BuildContext context, DbState state) { 
          if(state is DbUpdated){
            context.read<DbBloc>().add(DbReloadRequested());
          }
        },
        builder: (BuildContext context, DbState state) { 
          if(state is DbReloading){
            return const Center(
              child: CircularProgressIndicator()
            );
          }
          else {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 0),
              child: BlocBuilder<SearchFilesBloc, SearchFilesState>(
                builder: (BuildContext context, SearchFilesState state) {
                  List<Widget> files = List.generate(state.filesList.length, (index) => 
                    ItemCard(index: index, file: state.filesList[index])
                  );
                  if(state is EmptySearch){
                    return Column(
                      children: const [
                        SizedBox(height: 32),
                        ListCategoryText('Recently Added'),
                        FilesListing(fetchFunction: FireStoreUtils.listFilesByDate),
                  
                        SizedBox(height: 32),
                        ListCategoryText('Most Rated'),
                        FilesListing(fetchFunction: FireStoreUtils.listFilesByRatings),
                  
                        SizedBox(height: 32),
                        ListCategoryText('Most Downloaded'),
                        FilesListing(fetchFunction: FireStoreUtils.listFilesByDownloadCount),
                  
                        SizedBox(height: 32),
                        ListCategoryText('Featured'),
                        FilesListing(fetchFunction: FireStoreUtils.listFiles),
                      ],
                    );
                  }
                  else if(state is SearchLoading){
                    return const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  else if(state is SearchSuccess)
                    return Wrap(
                      children: files,
                    );
                  else if(state is SearchFailed)
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
