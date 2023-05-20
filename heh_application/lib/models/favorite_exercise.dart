import 'package:heh_application/models/exercise_model/exercise_detail.dart';
import 'package:heh_application/models/sign_up_user.dart';

class FavoriteExercise {
  String? favoriteExerciseID;
  String exerciseDetailID;
  ExerciseDetail1? exerciseDetail1;
  String userID;
  SignUpUser? signUpUser;


  FavoriteExercise(
      { this.favoriteExerciseID,
      required this.exerciseDetailID,
        this.exerciseDetail1,
      required this.userID,
        this.signUpUser,
});
  factory FavoriteExercise.fromMap(Map<String, dynamic> json) {
    return FavoriteExercise(
        favoriteExerciseID: json['favoriteExerciseID'],
        exerciseDetailID: json['exerciseDetailID'],
        exerciseDetail1: ExerciseDetail1.fromMap(json['exerciseDetail']),
        userID: json['userID'],
        signUpUser: SignUpUser.fromMap(json['user'], ''),
);
  }
}
