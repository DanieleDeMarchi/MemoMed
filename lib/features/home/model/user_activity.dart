import 'package:memo_med/features/commons/activity.dart';
import 'package:memo_med/features/family/model/user.dart';

class UserWithActivities {
  final User user;
  late List<Activity> activities;

  UserWithActivities(this.user){
    activities= [];
  }

  List<Activity> getCompleted(){
    return activities.where((e) => e.isCompleted()).toList();
  }

  int getCount(){
    return activities.length;
  }

  int getCompletedCount(){
    return getCompleted().length;
  }

  void appendActivity(Activity a){
    activities.add(a);
  }

}