import '../../../core/exception/app_exceptions.dart';
import '../data_provider/rule_provider.dart';
import '../model/rule.dart';

class RuleRepository {
  RuleProvider _ruleProvider;

  RuleRepository(this._ruleProvider);

  Future<Rule> getRule() async {
    final res = await _ruleProvider.getRule();
    if (!res.exists) {
      throw AppException("There is not any parental Control");
    }
    return Rule.fromMap(res);
  }
}
