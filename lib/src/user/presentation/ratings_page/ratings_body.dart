import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../../../authentication/application/auth_bloc/auth_bloc.dart';
import '../../../plugins/domain/repositories/ratings_repository.dart';
import '../../../widgets/ui_utils.dart';
import '../../application/bloc/ratings_bloc/ratings_bloc.dart';
import '../../domain/models/rating.dart';
import 'rating_item.dart';

class RatingsBody extends StatefulWidget {
  const RatingsBody({super.key, required this.userStatus, required this.ratingsRepository});
  
  final AuthenticateSuccess userStatus;
  final RatingsRepository ratingsRepository;

  @override
  State<RatingsBody> createState() => _RatingsBody();
}

class _RatingsBody extends State<RatingsBody> {
  int? _selectedIndex;
  
  @override
  void initState() {
    super.initState();
    final user = widget.userStatus.user;
    if (user == null) {
      throw Exception('User is not defined');
    }
    context.read<RatingsBloc>().add(GetAllRatingsRequested(user.uid));
  }

  void showRatingDetailDialog(Rating rating, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return RatingDetail(rating: rating);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: BlocBuilder<RatingsBloc, RatingsState>(
        builder: (BuildContext context, RatingsState state) {
          if (state is RatingsLoading) {
            return const CircularProgressIndicator();
          
          } else if (state is RatingsLoaded) {
            return Column(
              children: [
                const Text(
                  'Ratings',
                  style: TextStyle(
                    fontSize: UiUtils.sizeXL,
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * (1 / 3),
                  height: MediaQuery.of(context).size.height * (2 / 3),
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    controller: null,
                    itemCount: state.ratings.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Rating rating = state.ratings[index];
                      return ListTile(
                        enabled: true,
                        selected: index == _selectedIndex,
                        dense: false,
                        horizontalTitleGap: 0.0,
                        selectedColor: UiUtils.blue,
                        selectedTileColor: Colors.grey[800],
                        splashColor: UiUtils.transparent,
                        contentPadding: const EdgeInsets.symmetric(horizontal: UiUtils.sizeL),
                        title: Text(rating.pluginName ?? rating.pluginId),
                        subtitle: Text(UiUtils.formatDate(rating.date)),
                        trailing: SizedBox(
                          child: RatingBar.builder(
                            initialRating: rating.rating,
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
                        ),
                        onTap: () {
                          setState(() {
                            _selectedIndex = index;
                          });
                          showRatingDetailDialog(rating, context);
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          }
          else {
            return Text(state is RatingsLoadFailed ? state.message : state.toString());
          }
        },
      ),
    
    );
  }
}