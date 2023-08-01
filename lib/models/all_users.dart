import 'package:woofme/models/user_info.dart';

class AllUsers {
  List<UserInfo> users;

  AllUsers({this.users = const []});

  int get numberOfUsers => users.length;
}
