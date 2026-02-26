import 'package:final_project/app/l10n/app_localizations.dart';
import 'package:final_project/features/policy/data/service/policy_service.dart';
import 'package:final_project/features/policy/presentation/state/policy_state.dart';
import 'package:flutter/cupertino.dart';

import '../../data/models/policy_infomation.dart';

class PolicyController extends ChangeNotifier {
  PolicyState _state = PolicyState.initial();
  PolicyState get state => _state;
  final PolicyService _policyService=PolicyService();
  final ScrollController scrollController = ScrollController();
  Future<void> initData(AppLocalizations l10n, int postId) async {

    if (postId == 0) {
      _updateState(_state.copyWith(
        isLoading: false,
        policy: null,
        errorMessage: l10n.policy_searchCodeArticleCode(postId),
      ));
      return;
    }

    _updateState(_state.copyWith(
      isLoading: true,
      errorMessage: null,
    ));

    try {
      final Policy policyData =
      await _policyService.fetchPolicy(postId: postId);

      _updateState(_state.copyWith(
        policy: policyData,
        isLoading: false,
        errorMessage: null,
      ));

      print('Dữ liệu chính sách đã được tải: ${policyData.title}');
    } catch (e) {
      print('LỖI KHI TẢI CHÍNH SÁCH: $e');
      _updateState(_state.copyWith(
        policy: null,
        isLoading: false,
        errorMessage:
        '${l10n.policy_loadDetailPolicyFailed} ${e.toString()}',
      ));
    }
  }

  void _updateState(PolicyState newState) {
    _state = newState;
    notifyListeners();
  }
}