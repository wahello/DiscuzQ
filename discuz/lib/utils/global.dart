import 'package:flutter/material.dart';

class Global {
  ///
  /// appname
  /// 应用程式名称
  ///
  static const String appname = 'DiscuzQ';

  ///
  /// domain
  /// 服务端域名
  /// 注意： 不要在域名后面加 / 路径符
  /// 注意：不要填写301或者302的域名
  ///
  static const String domain = 'https://discuz.chat';

  ///
  /// 隐私政策和用户协议常规不需要设置
  /// 若设置后将指定打开链接内的用户协议
  /// 默认情况下，程序设计自动加载dz中设置的协议
  /// 该配置项根据需要来开启
  ///
  /// 隐私协议
  static const String privacyUri = '';

  ///用户协议
  static const String policiesUri = '';

  /// 开启支付
  /// 允许支付功能
  /// 允许钱包功能
  /// 值得注意，当您设置为False时，请记得根据后续文档中的提示，编译时将Payment相关的SDK排出
  /// 如果不移除payment相关的SDK将导致你的应用无法上架
  static const bool enablePayment = true;

  ///
  /// theme
  static const Color primaryColor = Color(0xFF316598);

  ///
  /// splash color
  static const Color splashColor = Colors.transparent;

  ///
  /// highlightColor
  static const Color highlightColor = Colors.transparent;

  /// 日间模式底色
  static const Color scaffoldBackgroundColorLight = Color(0xFFF1F1F1);

  /// 夜间模式底色
  static const Color scaffoldBackgroundColorDark = Color(0xFF19232d);

  /// 日间模式全局底色
  static const Color backgroundColorLight = Color(0xFFF9F9F9);

  /// 夜间模式全局底色
  static const Color backgroundColorDark = Color(0xFF253341);

  /// 日间模式字体颜色
  static const Color textColorLight = Color(0xFF111111);

  /// 夜间模式字体颜色
  static const Color textColorDark = Color(0xFFF2F2F2);

  /// 日间模式subtitle字体颜色
  static const Color greyTextColorLight = Color(0xFF777777);

  /// 夜间模式字体颜色
  static const Color greyTextColorDark = Color(0xFF888888);

  /// 手势配置
  ///
  /// 抽屉手滑动作用域
  static const double drawerEdgeDragWidth = 40;

  /// 边
  static const BorderSide border =
      const BorderSide(width: .2, color: const Color(0x1F000000));

  /// 加密
  ///
  /// 在您用于发布时，请更新下面的信息，下面的信息将对本地sqlite存储或shared preferences进行简单加密
  /// 这个数据随便的，其实这种加密本身也是没有安全可言的，在本地，只是保存明文的话又太那啥了。
  static const String encryptKey = '58sw517e13e05accb62f28145d1b13ccd8';
  static const String encryptIV = '06549488ew505b715';

  ///
  /// 分页，单页加载数量
  /// 分页下拉加载组件将以此为准
  static const int requestPageLimit = 20;
}
