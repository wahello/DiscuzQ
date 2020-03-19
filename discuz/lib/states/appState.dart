import 'package:scoped_model/scoped_model.dart';

class AppState extends Model {
  // forum 站点信息
  dynamic _forum;
  get forum => _forum;
  void updateForum(dynamic forum) {
    _forum = forum;
    notifyListeners();
  }

  // categories 分类
  List<dynamic> _categories;
  get categories => _categories;
  void updateCategories(List<dynamic> categories) {
    _categories = categories;
    notifyListeners();
  }

  // 已经登录的用户
  dynamic _user;
  get user => _user;
  void updateUser(dynamic user) {
    _user = user;
    notifyListeners();
  }

  // 本地设置项
  dynamic _appConf;
  get appConf => _appConf;

  /// 初始化配置状态
  void initAppConf(dynamic conf) {
    if (conf == null) {
      return;
    }
    _appConf = conf;
    notifyListeners();
  }

  ///
  /// 使用key 更新配置状态
  void updateAppConfByKeyName(String key, dynamic val) {
    _appConf[key] = val;
    notifyListeners();
  }
}
