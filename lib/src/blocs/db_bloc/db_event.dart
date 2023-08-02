
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/rating.dart';

abstract class DbEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UploadDataRequested extends DbEvent {
  UploadDataRequested(this.uploadFile, this.user, this.price);

  final PlatformFile uploadFile;
  final User user;
  final double price;
  
  @override
  List<Object> get props => [];
}

class AddRatingDataRequested extends DbEvent {
  AddRatingDataRequested(this.ratingDocId, this.rating);

  final String ratingDocId;
  final Rating rating;
  
  @override
  List<Object> get props => [];
}

class ResetStateRequested extends DbEvent {
  @override
  List<Object> get props => [];
}

class DbReloadRequested extends DbEvent {
  @override
  List<Object> get props => [];
}