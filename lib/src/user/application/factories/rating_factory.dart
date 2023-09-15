import '../../../plugins/domain/models/rating.dart' as plugin;
import '../../domain/models/rating.dart';

class RatingFactory {
  static Rating fromPlugin(plugin.Rating rating) {
    return Rating(
      date: rating.date,
      rating: rating.rating,
      reviewer: rating.reviewer,
      pluginId: rating.pluginId,
      pluginName: rating.pluginName,
    );
  }
}