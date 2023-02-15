import 'package:memo_med/features/family/service/user_service.dart';
import 'package:riverpod/riverpod.dart';

import '../model/user.dart';

final initialListProvider =
FutureProvider((ref) => UserService().getAll());

final userListProvider =
FutureProvider.autoDispose((ref) => UserService().getAll());

final usersProvider = StateNotifierProvider<UsersNotifier, List<User>>((ref) {
  final list = ref.watch(initialListProvider);
  return UsersNotifier(ref, list.value);
});

class UsersNotifier extends StateNotifier<List<User>> {
  late final UserService _userService;
  late Ref ref;

  UsersNotifier( this.ref, [List<User>? users]) : super(users ?? []) {
    _userService = UserService();
  }

  Future<void> add(User user) async {
    User added = await _userService.insertOne(user);
    state = [...state, added];
  }


  Future<void> edit(User toUpdate) async {
    User updatedUser = await _userService.updateOne(toUpdate);
    state = [
      for (final user in state)
        if (user.id != toUpdate.id) user else updatedUser,
    ];
  }

  Future<void> remove(User toRemove) async {
    await _userService.remove(toRemove);
    state = [
      for (final user in state)
        if (user.id != toRemove.id) user,
    ];
  }

}
