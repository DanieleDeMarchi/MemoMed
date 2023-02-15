

import 'package:memo_med/features/family/repository/user_repository.dart';

import '../model/user.dart';

class UserService {
  static final UserService _userService = UserService._internal();

  late final UserRepository _userRepository;

  factory UserService() {
    return _userService;
  }

  UserService._internal(){
    _userRepository = UserRepository();
  }

  Future<List<User>> getAll() async {
    return _userRepository.fetchAll();
  }

  Future<User> insertOne(User user) async {
    return _userRepository.insertOne(user);
  }

  Future<User> updateOne(User user) async {
    return _userRepository.updateOne(user);
  }

  Future<void> remove(User user) async {
    _userRepository.deleteOne(user);
  }

}