import 'package:appflowy_theme_marketplace/src/user/presentation/user_dashboard_page/widgets/file_detail.dart';
import 'package:appflowy_theme_marketplace/src/user/presentation/user_dashboard_page/widgets/left_nav_bar.dart';
import 'package:appflowy_theme_marketplace/src/widgets/ui_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../../application/bloc/storage_bloc/storage_bloc.dart';
import '../../domain/models/user.dart';
import '../../domain/repositories/user_repository.dart';

enum FileType {
  free,
  paid,
}

enum ViewMode {
  ratings,
  orders,
  storageFiles,
  releasedFiles,
}

class UserDashboardBody extends StatefulWidget {
  const UserDashboardBody({
    super.key,
    required this.user,
    required this.userRepository,
    required this.openDrawer,
    required this.setDrawerContent,
  });
  final User user;
  final UserRepository userRepository;
  final VoidCallback openDrawer;
  final Function setDrawerContent;

  @override
  State<UserDashboardBody> createState() => _UserBodyState();
}

class _UserBodyState extends State<UserDashboardBody> {
  int? _selectedIndex;
  FileType listType = FileType.paid;
  ViewMode viewmode = ViewMode.storageFiles;
  bool isLoading = true;

  @override
  void initState() {
    context.read<StorageBloc>().add(GetUploadedFilesRequested(uid: widget.user.uid, bucket: 'paid_plugins'));
    super.initState();
  }

  void getFilesList(FileType type) {
    setState(() {
      if (type == FileType.free) {
        context.read<StorageBloc>().add(
          GetUploadedFilesRequested(
            uid: widget.user.uid,
            bucket: 'free_plugins',
          ),
        );
      } else {
        context.read<StorageBloc>().add(
          GetUploadedFilesRequested(
            uid: widget.user.uid,
            bucket: 'paid_plugins',
          ),
        );
      }
      listType = type;
      _selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Widget filesList = BlocConsumer<StorageBloc, StorageState>(
      listener: (BuildContext context, StorageState state) {
        if (state is StorageUploadSuccess || state is StorageFailed || state is StorageDeleteSuccess) {
          getFilesList(listType);
        }
      },    
      builder: (BuildContext context, StorageState state) {
        return Expanded(
          child: Skeleton(
            skeleton: SkeletonListView(),
            isLoading: state is StorageSearching,
            child: ListView.builder(
              itemCount: state.files.length,
              itemBuilder: (BuildContext context, int index) {
                final DateTime date = DateTime.parse(state.files[index].createdAt!);
                return ListTile(
                  selected: index == _selectedIndex ? true : false,
                  splashColor: UiUtils.transparent,
                  selectedColor: UiUtils.blue,
                  leading: const Icon(Icons.folder_zip),
                  title: Text(state.files[index].name),
                  minLeadingWidth : UiUtils.sizeS,
                  subtitle: Text(UiUtils.formatDate(date)),
                  onTap: () {
                    widget.openDrawer();
                    widget.setDrawerContent(
                      FileDetail(
                        fileContent: state.files[index],
                        bucket: listType == FileType.free ? 'free_plugins' : 'paid_plugins',
                      ),
                    );
                    setState(() => _selectedIndex = index);
                  },
                );
              },
            ),
          ),
        );
      },
    );

    final Widget filesListingOptions = Row(
      children: [
        ContentSpacer.horizontalSpacer_16,
        const Text('My Storage Files', style: FontText.font_18),
        const Spacer(),
        ElevatedButton(
          onPressed: listType == FileType.free ? () => getFilesList(FileType.paid) : null,
          child: const Text('Paid'),
        ),
        ContentSpacer.horizontalSpacer_16,
        ElevatedButton(
          onPressed: listType == FileType.paid ? () => getFilesList(FileType.free) : null,
          child: const Text('Free'),
        ),
        ContentSpacer.horizontalSpacer_16,
      ],
    );

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          LeftNavigationBar(uid: widget.user.uid),
          Expanded(
            child: Column(
              children: [
                filesListingOptions,
                ContentSpacer.verticalSpacer_16,
                filesList,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
