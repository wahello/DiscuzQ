import 'package:dio/dio.dart';
import 'package:discuzq/widgets/common/discuzToast.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:discuzq/models/metaModel.dart';
import 'package:discuzq/models/notificationModel.dart';
import 'package:discuzq/utils/dateUtil.dart';
import 'package:discuzq/utils/global.dart';
import 'package:discuzq/utils/request/request.dart';
import 'package:discuzq/utils/request/urls.dart';
import 'package:discuzq/widgets/appbar/appbar.dart';
import 'package:discuzq/widgets/common/discuzAvatar.dart';
import 'package:discuzq/widgets/common/discuzDivider.dart';
import 'package:discuzq/widgets/common/discuzLink.dart';
import 'package:discuzq/widgets/common/discuzListTile.dart';
import 'package:discuzq/widgets/common/discuzNomoreData.dart';
import 'package:discuzq/widgets/common/discuzRefresh.dart';
import 'package:discuzq/widgets/common/discuzText.dart';
import 'package:discuzq/widgets/htmRender/htmlRender.dart';
import 'package:discuzq/widgets/skeleton/discuzSkeleton.dart';
import 'package:discuzq/widgets/ui/ui.dart';

///
/// 消息通知列表页面
///
class NotificationListDelegate extends StatefulWidget {
  final NotificationTypesItem type;

  const NotificationListDelegate({@required this.type});

  @override
  _NotificationDelegateState createState() => _NotificationDelegateState();
}

class _NotificationDelegateState extends State<NotificationListDelegate> {
  /// refresh controller
  final RefreshController _controller = RefreshController();

  ///
  /// _pageNumber
  int _pageNumber = 1;

  ///
  /// meta
  MetaModel _meta;

  ///
  /// _enablePullUp
  /// 是否允许加载更多
  bool _enablePullUp = false;

  ///
  /// loading
  /// 是否正在加载
  bool _loading = false;

  ///
  /// _continueToRead
  /// 是否是连续加载
  bool _continueToRead = false;

  ///
  /// 通知数据
  ///
  List<NotificationModel> _notifications = [];

  @override
  void setState(fn) {
    if (!mounted) {
      return;
    }
    super.setState(fn);
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 470))
        .then((_) async => await _requestData(pageNumber: 1));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DiscuzAppBar(
        title: widget.type.label,
      ),
      backgroundColor: DiscuzApp.themeOf(context).scaffoldBackgroundColor,
      body: _buildBody(context),
    );
  }

  ///
  /// 是否允许加载更多页面
  ///
  void _refreshEnablePullUp() {
    final bool enabled =
        _meta == null ? false : _meta.pageCount > _pageNumber ? true : false;
    _enablePullUp = enabled;
  }

  ///
  /// 生成搜索用户的组件
  ///
  Widget _buildBody(BuildContext context) => DiscuzRefresh(
        controller: _controller,
        enablePullDown: true,
        enablePullUp: _enablePullUp,
        onLoading: () async {
          if (_loading) {
            return;
          }
          await _requestData(pageNumber: _pageNumber + 1);
          _controller.loadComplete();
        },
        onRefresh: () async {
          await _requestData(pageNumber: 1);
          _controller.refreshCompleted();
        },
        child: _buildNotificationList(context),
      );

  ///
  /// 通知列表
  Widget _buildNotificationList(BuildContext context) {
    ///
    /// 骨架屏仅在初始化时加载
    ///
    if (!_continueToRead && _loading) {
      return const DiscuzSkeleton(
        isCircularImage: false,
        length: Global.requestPageLimit,
        isBottomLinesActive: false,
      );
    }

    if (_notifications.length == 0) {
      return const DiscuzNoMoreData();
    }

    return ListView(
      children: _notifications
          .map<Widget>((NotificationModel n) => Container(
              decoration: BoxDecoration(
                  color: DiscuzApp.themeOf(context).backgroundColor),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: 5, bottom: 5, left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const DiscuzDivider(
                      padding: 0,
                    ),
                    const SizedBox(height: 10),
                    widget.type == NotificationTypes.system
                        ? const SizedBox()
                        : Container(
                            child: DiscuzListTile(
                              contentPadding: const EdgeInsets.all(0),
                              leading: DiscuzAvatar(
                                  url: n.attributes.userAvatar, size: 40),
                              title: Row(
                                children: <Widget>[
                                  // todo 点击查看用户
                                  DiscuzText('${n.attributes.username}回复了我')
                                ],
                              ),
                              subtitle: DiscuzText(
                                DateUtil.formatDate(
                                    DateTime.parse(n.attributes.createdAt),
                                    format: "yyyy-MM-dd HH:mm"),
                                fontSize: 14,
                                color: DiscuzApp.themeOf(context).greyTextColor,
                              ),
                              trailing: DiscuzLink(
                                label: '删除',
                                onTap: () => DiscuzToast.failed(context: context, message: '暂不支持'),
                              ),
                            ),
                          ),
                    /// 仅系统通知显示标题
                    widget.type != NotificationTypes.system
                        ? const SizedBox()
                        : DiscuzText(
                            n.attributes.title,
                            fontWeight: FontWeight.bold,
                          ),
                    /// 仅系统通知显示时间
                    widget.type != NotificationTypes.system
                        ? const SizedBox()
                        : DiscuzText(
                            DateUtil.formatDate(
                                DateTime.parse(n.attributes.createdAt),
                                format: "yyyy-MM-dd HH:mm"),
                            fontSize: 14,
                            color: DiscuzApp.themeOf(context).greyTextColor,
                          ),
                    /// 渲染消息内容
                    /// todo: 点击到关联的帖子
                    HtmlRender(
                      html: n.attributes.postContent != ''
                          ? n.attributes.postContent
                          : n.attributes.content,
                    ),
                  ],
                ),
              )))
          .toList(),
    );
  }

  ///
  /// 请求用户搜索结果
  Future<void> _requestData({BuildContext context, int pageNumber}) async {
    if (_loading) {
      return;
    }

    if (pageNumber == 1) {
      _notifications.clear();

      /// 要清空历史搜索数据，否则会重复渲染到UI
      setState(() {
        _continueToRead = false;
      });
    }

    final dynamic data = {
      'filter[type]': widget.type.type,
      "page[number]": pageNumber ?? _pageNumber,
      'page[limit]': Global.requestPageLimit
    };

    setState(() {
      _loading = true;
    });

    Response resp = await Request(context: context)
        .getUrl(url: Urls.notifications, queryParameters: data);
    setState(() {
      _loading = false;
    });
    final List<dynamic> notifications = resp.data['data'] ?? [];

    List<NotificationModel> notificationModel;

    try {
      ///
      /// 生成新的 _users
      /// 当底部的setState触发UI更新时，实际上 _users会重新渲染UI，所以这里不必要SetState 否则就脱裤子放屁了
      notificationModel = notifications
          .where((u) => u['type'] == 'notification')
          .map((n) => NotificationModel.fromMap(maps: n))
          .toList();
    } catch (e) {
      print(e);
    }

    print({_notifications.length, resp.data['data'].length});

    setState(() {
      _loading = false;
      _pageNumber = pageNumber == null ? _pageNumber + 1 : pageNumber;
      _continueToRead = true;
      _notifications.addAll([...notificationModel]);

      /// pageNumber 在onload传入时已经自动加1
      _meta = MetaModel.fromMap(maps: resp.data['meta']);
      _refreshEnablePullUp();
    });
  }
}

///
/// 消息通知的类型
///
class NotificationTypes {
  ///
  /// 回复
  static const replies =
      const NotificationTypesItem(label: '回复我的', type: 'replied');

  ///
  /// 打赏我的
  static const rewarded =
      const NotificationTypesItem(label: '打赏我的', type: 'rewarded');

  ///
  /// 打赏我的
  static const liked =
      const NotificationTypesItem(label: '喜欢我的', type: 'liked');

  ///
  /// 系统消息
  static const system =
      const NotificationTypesItem(label: '系统消息', type: 'system');
}

class NotificationTypesItem {
  final String type;

  final String label;

  const NotificationTypesItem({@required this.type, @required this.label});
}
