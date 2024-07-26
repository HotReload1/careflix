import 'package:careflix/layers/data/data_provider/auth_provider.dart';
import 'package:careflix/layers/data/model/user_model.dart';
import 'package:careflix/layers/data/repository/auth_repository.dart';
import 'package:careflix/layers/data/repository/profile_repository.dart';
import 'package:flutter/cupertino.dart';

import '../../../injection_container.dart';
import '../../../layers/data/model/rule.dart';
import '../../../layers/data/repository/rule_repository.dart';
import '../../../layers/logic/show_lists/show_lists_cubit.dart';

class AppState extends ChangeNotifier {
  final _profileRpo = sl<ProfileRepository>();
  final _ruleRepo = sl<RuleRepository>();

  UserModel? userModel;
  Rule? _rule;

  Rule? get rule => _rule;

  Future init() async {
    await Future.wait([getUserProfile(), getRule()]);
  }

  Future getUserProfile() async {
    userModel = await _profileRpo.getUserProfile();
  }

  addShowToUserList(String id) {
    userModel!.userListIds.add(id);
    notifyListeners();
    sl<ShowListsCubit>().changeUserLists(userModel!.userListIds);
    _profileRpo.changeUserList(userModel!.userListIds);
  }

  removeShowFromList(String id) {
    userModel!.userListIds!.remove(id);
    notifyListeners();
    sl<ShowListsCubit>().changeUserLists(userModel!.userListIds);
    _profileRpo.changeUserList(userModel!.userListIds);
  }

  Future getRule() async {
    try {
      _rule = await _ruleRepo.getRule();
      print(_rule);
      notifyListeners();
    } catch (e) {
      print("error");
    }
  }

  Future setRule(Rule rule) async {
    try {
      _rule = rule;
      notifyListeners();
    } catch (e) {}
  }
}
