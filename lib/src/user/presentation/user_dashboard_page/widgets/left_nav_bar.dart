import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletons/skeletons.dart';

import '../../../../widgets/ui_utils.dart';
import '../../../application/bloc/user_bloc/user_bloc.dart';
import '../../../domain/models/user.dart';
import 'onboarding_info.dart';
import 'upload_btn.dart';

class LeftNavigationBar extends StatefulWidget {
  const LeftNavigationBar({super.key, required this.uid});

  final String uid;

  @override
  State<LeftNavigationBar> createState() => _LeftNavigationBarState();
}

class _LeftNavigationBarState extends State<LeftNavigationBar> {
  int? _selectedIndex;

  @override
  void initState() {
    context.read<UserBloc>().add(GetAndUpdateUserDataRequested(widget.uid));
    super.initState();
  }
  
  Widget userInfo(User user) {
    return Container(
      color: UiUtils.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!user.onboardCompleted)
            OnboardInfo(stripeId: user.stripeId!),
          const SizedBox(height: UiUtils.sizeM),
        ],
      ),
    );
  }

  void listTiletap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    switch (index) {
      case 1:
        Navigator.pushNamed(context, '/orders');
        break;
      case 2:
        Navigator.pushNamed(context, '/ratings');
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> itemsList = [
      const UploadButton(),
      const Text(
        'My Orders',
        style: FontText.font_14,
      ),
      const Text(
        'My Reviews',
        style: FontText.font_14,
      ),
    ];

    return Container(
      width: UiUtils.leftNavBarWidth,
      decoration: const BoxDecoration(
        border: Border(
          right: BorderSide(
            color: UiUtils.gray, 
            width: UiUtils.borderWidth_1, 
          ),
        ),
      ),
      child: BlocBuilder<UserBloc, UserState>(
        builder: (BuildContext context, UserState state) {
          return Skeleton(
            isLoading: state is! UserLoaded,
            skeleton: SkeletonAvatar(
              style: SkeletonAvatarStyle(
                width: UiUtils.leftNavBarWidth,
                height: double.infinity,
                padding: const EdgeInsets.all(8),
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: itemsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return itemsList[index];
                      }
                      return ListTile(
                        selected: index == _selectedIndex ? true : false,
                        splashColor: UiUtils.transparent,
                        selectedColor: UiUtils.blue,
                        title: itemsList[index],
                        onTap: () => listTiletap(index),
                      );
                    },
                  ),
                ),
                const Spacer(),
                if (state is UserLoaded)
                  userInfo(state.user),
              ],
            ),
          );
        }
      ),
    );
  }
}
