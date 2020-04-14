import 'dart:async';
import 'dart:wasm';

import 'package:agent37_flutter/api/member.dart';
import 'package:agent37_flutter/components/Icon.dart';
import 'package:agent37_flutter/components/v-loading.dart';
import 'package:agent37_flutter/components/v-underline_indicator.dart';
import 'package:agent37_flutter/models/home-info.dart';
import 'package:agent37_flutter/provide/user.dart';
import 'package:agent37_flutter/utils/global.dart';
import 'package:agent37_flutter/utils/validate.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:provider/provider.dart';
import 'package:simple_tooltip/simple_tooltip.dart';
import './components/shareWindow.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  EasyRefreshController _refreshController = EasyRefreshController();
  HomeInfoModel homeinfo;

  Future _getHomeinfo(context) async {
    var result = await MemberApi().getHomeInfo();
    if (result.data['data'] != null) {
      setState(() {
        homeinfo = homeInfoModelFromJson(result.data['data']);
      });
    }
    return 'feture end';
  }



  // 头部按钮
  Widget _head() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: G.setWidth(30)),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          brightness: Brightness.dark,
          actionsIconTheme: IconThemeData(color: hex('#FFF')),
          actions: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: G.setWidth(15)),
                child: iconsetting(size: G.setSp(48)),
              ),
              onTap: () {},
            ),
            InkWell(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: G.setWidth(15)),
                  child: iconmsg(size: G.setSp(48)),
                ),
                onTap: () {}),
          ],
        ));
  }

  // 用户信息
  Widget _userInfo() {
    return Container(
      height: G.setHeight(120),
      padding: EdgeInsets.symmetric(horizontal: G.setWidth(50)),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: G.setWidth(60),
            backgroundImage: AssetImage('${G.imgBaseUrl}logo.png'),
          ),
          Container(width: G.setWidth(20)),
          Column(
            mainAxisAlignment: Validate.isNon(homeinfo.shareCode)
                ? MainAxisAlignment.center
                : MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(homeinfo.nickname ?? '未知',
                      style:
                          TextStyle(fontSize: G.setSp(30), color: hex('#FFF'))),
                  Container(width: G.setWidth(10)),
                  Image.asset(
                    '${G.imgBaseUrl}home/check-status_icon.png',
                    width: G.setWidth(140),
                    height: G.setHeight(50),
                  ),
                ],
              ),
              Validate.isNon(homeinfo.shareCode)
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Text('邀请码：${homeinfo.shareCode}',
                            style: TextStyle(
                                fontSize: G.setSp(30), color: hex('#FFF'))),
                        Container(
                          margin: EdgeInsets.only(left: G.setWidth(10)),
                          padding: EdgeInsets.fromLTRB(G.setWidth(18),
                              G.setHeight(5), G.setWidth(18), G.setHeight(5)),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: hex('#FFF'))),
                          child: InkWell(
                            onTap: () {
                              G.setClipboard('1234143');
                            },
                            child: Text(
                              '复制',
                              style: TextStyle(
                                  fontSize: G.setSp(22), color: hex('#FFF')),
                            ),
                          ),
                        )
                      ],
                    )
            ],
          ),
        ],
      ),
    );
  }

  void openShare() {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context){
          return new Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              new ListTile(
                // leading: new Icon(Icons.photo_library),
                title: Center(
                  child: Text('会员推荐分享'),
                ),
                onTap: () {
                  // _openGallery();
                  Navigator.pop(context);
                  openShareWindow(context, 'member');
                },
              ),
              new ListTile(
                // leading: new Icon(Icons.photo_library),
                title: Center(
                  child: Text('代理推荐分享'),
                ),
                onTap: () {
                  // _openGallery();
                  Navigator.pop(context);
                  openShareWindow(context, 'agent');
                },
              ),
              new ListTile(
                // leading: new Icon(Icons.photo_library),
                title: Center(
                  child: Text('取消'),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
    );
  }

  // 任务子项
  Widget _missionItem(String title, int val) {
    return InkWell(
        onTap: () {},
        child: Container(
          width: G.setWidth(325),
          height: G.setHeight(210),
          padding: EdgeInsets.symmetric(
              vertical: G.setHeight(38), horizontal: G.setWidth(30)),
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: AssetImage('${G.imgBaseUrl}home/subordinate_bg.png'),
                  fit: BoxFit.fill)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(title,
                  style: TextStyle(
                      fontSize: G.setSp(30),
                      color: hex('#333'),
                      fontWeight: FontWeight.w500)),
              Container(
                height: G.setHeight(15),
                decoration: BoxDecoration(
                    border: Border.all(color: hex('#6982FF')),
                    borderRadius: BorderRadius.circular(7.5)),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.transparent,
                  valueColor: AlwaysStoppedAnimation(hex('#6982FF')),
                  value: val / 10,
                ),
              ),
              Text('$val/10',
                  style:
                      TextStyle(fontSize: G.setSp(30), color: hex('#424242')))
            ],
          ),
        ));
  }

  // 资格任务
  Widget _mission() {
    return Container(
      margin: EdgeInsets.only(top: G.setHeight(60), bottom: G.setHeight(20)),
      width: G.setWidth(710),
      height: G.setHeight(380),
      padding: EdgeInsets.symmetric(
          horizontal: G.setWidth(10), vertical: G.setHeight(15)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: hex('#FFF')),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                height: G.setHeight(80),
                // color: hex('ff0'),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('资格任务',
                        style: TextStyle(
                            fontSize: G.setSp(30), color: hex('#424242'))),
                    Text('距结束：23天5小时23分',
                        style: TextStyle(
                            fontSize: G.setSp(24), color: hex('#686868'))),
                  ],
                ),
              ),
              Container(
                height: G.setHeight(80),
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () {
                    G.router.navigateTo(context, '/fine-point');
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('查看细则',
                          style: TextStyle(
                              fontSize: G.setSp(24), color: hex('#0091F0'))),
                      SizedBox(width: G.setWidth(10)),
                      iconarrow(color: hex('#0091F0'), size: G.setSp(24))
                    ],
                  ),
                )
              )
            ],
          ),
          G.spacing(25),
          Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: G.setHeight(230),
                  width: G.setWidth(690),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      _missionItem('开通钻石会员', 3),
                      _missionItem('钻石会员有效订单', 7)
                    ],
                  ),
                ),
                Positioned(
                    top: 0,
                    left: 0,
                    width: G.setWidth(690),
                    height: G.setHeight(230),
                    child: Opacity(
                      opacity: 0.6,
                      child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: hex('#333'),
                              borderRadius: BorderRadius.circular(10)),
                          child: InkWell(
                            onTap: () {},
                            child: Container(
                              width: G.setWidth(200),
                              height: G.setHeight(60),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(color: hex('#fff')),
                                borderRadius:
                                    BorderRadius.circular(G.setWidth(50)),
                              ),
                              child: Text('申请延时',
                                  style: TextStyle(
                                      color: hex('#FFF'),
                                      fontSize: G.setSp(28))),
                            ),
                          )),
                    ))
              ],
            ),
          )
        ],
      ),
    );
  }

  // 数据统计tabbar选项栏
  List<Widget> _statisticsTabItem() {
    List<String> types = ['今日', '本月', '上月'];
    return types.map((type) {
      return Tab(
          icon: Text(type,
              style: TextStyle(
                  fontSize: G.setSp(30),
                  color: hex('#262626'),
                  fontWeight: FontWeight.w500)));
    }).toList();
  }

  // 数据统计子项内容
  Widget _statisticsContentItem(String type) {
    List data;
    List title = [
      '预估商品销售分佣',
      '预估会员居间服务费',
      '预估礼包销售分佣',
      '订单数',
      '会员注册数',
      '代理商注册数',
    ];
    switch (type) {
      case 'today':
        data = [
          homeinfo.todayPendingPurchaseServiceFee,
          homeinfo.todayPendingMemberServiceFee,
          homeinfo.todayPendingGiftPackageServiceFee,
          homeinfo.todayIncreasedOrderNum,
          homeinfo.todayIncreasedAppMemberNum,
          homeinfo.todayIncreasedAgentNum,
        ];
        break;
      case 'thisMonth':
        data = [
          homeinfo.thisMonthPendingPurchaseServiceFee,
          homeinfo.thisMonthPendingMemberServiceFee,
          homeinfo.thisMonthPendingGiftPackageServiceFee,
          homeinfo.thisMonthIncreasedOrderNum,
          homeinfo.thisMonthIncreasedAppMemberNum,
          homeinfo.thisMonthIncreasedAgentNum,
        ];
        break;
      case 'lastMonth':
        data = [
          homeinfo.lastMonthPendingPurchaseServiceFee,
          homeinfo.lastMonthPendingMemberServiceFee,
          homeinfo.lastMonthPendingGiftPackageServiceFee,
          homeinfo.lastMonthIncreasedOrderNum,
          homeinfo.lastMonthIncreasedAppMemberNum,
          homeinfo.lastMonthIncreasedAgentNum,
        ];
        break;
      default:
    }
    return MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Container(
            child: GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, //横轴三个子widget
                  // childAspectRatio: 237 / 200 //宽高比为1时，子widget
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return Container(
                      height: G.setHeight(200),
                      width: G.setWidth(237),
                      decoration: BoxDecoration(
                          border: Border(
                        bottom: index < 3
                            ? BorderSide(color: hex('#E6E6E6'))
                            : BorderSide.none,
                        right: (index + 1) % 3 != 0
                            ? BorderSide(color: hex('#E6E6E6'))
                            : BorderSide.none,
                      )),
                      child: Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.center,
                                child: Text.rich(TextSpan(children: [
                                  TextSpan(
                                      text: "￥",
                                      style: TextStyle(
                                          color: hex('#333'),
                                          fontSize: G.setSp(24))),
                                  TextSpan(
                                      text: data[index].toString(),
                                      style: TextStyle(
                                          color: hex('#333'),
                                          fontSize: G.setSp(36))),
                                ])),
                              ),
                              G.spacing(15),
                              Text(title[index],
                                  style: TextStyle(
                                      fontSize: G.setSp(24),
                                      color: hex('#999')))
                            ],
                          ),
                          index < 3
                              ? Positioned(
                                  top: G.setWidth(20),
                                  right: G.setWidth(20),
                                  child: ToolTip(
                                      direction: (index + 1) % 3 == 0
                                          ? 'left'
                                          : 'down'),
                                )
                              : Positioned(
                                  top: 0,
                                  right: 0,
                                  child: Container(
                                    width: G.setWidth(65),
                                    height: G.setWidth(65),
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.contain,
                                          image: AssetImage(
                                              '${G.imgBaseUrl}pic-icon/new-tri_icon.png')),
                                    ),
                                  ))
                        ],
                      ));
                })));
  }

  // 数据统计
  Widget _statistics() {
    return Container(
        height: G.setHeight(500),
        decoration: BoxDecoration(
            color: hex('#FFF'), borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: <Widget>[
            Container(
                height: G.setHeight(94),
                width: G.setWidth(710),
                decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: hex('#E6E6E6')))),
                child: TabBar(
                    indicator: VUnderlineTabIndicator(
                        borderSide: BorderSide(
                            width: G.setHeight(6), color: hex('#6982FF'))),
                    controller: _tabController,
                    tabs: _statisticsTabItem())),
            Container(
                height: G.setHeight(400),
                width: G.setWidth(710),
                child: TabBarView(
                  controller: _tabController,
                  children: <Widget>[
                    _statisticsContentItem('today'),
                    _statisticsContentItem('thisMonth'),
                    _statisticsContentItem('lastMonth'),
                  ],
                ))
          ],
        ));
  }

  Widget _menu() {
    List<Map> menuList = [
      {'title': '财务管理', 'icon': '${G.imgBaseUrl}home/finance.png', 'url': '/'},
      {'title': '邀请分享', 'icon': '${G.imgBaseUrl}home/share.png', 'url': '/'},
      {'title': '我的钱包', 'icon': '${G.imgBaseUrl}home/wallet.png', 'url': '/'},
      {'title': '会员管理', 'icon': '${G.imgBaseUrl}home/agent.png', 'url': '/'},
      {'title': '代理商管理', 'icon': '${G.imgBaseUrl}home/vip.png', 'url': '/'},
      {'title': '客户服务', 'icon': '${G.imgBaseUrl}home/contact.png', 'url': '/'},
    ];
    return Container(
        margin: EdgeInsets.symmetric(vertical: G.setHeight(20)),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(G.setWidth(10)),
            color: hex('#FFF')),
        width: G.setWidth(710),
        padding: EdgeInsets.symmetric(
            horizontal: G.setWidth(60), vertical: G.setHeight(20)),
        height: G.setHeight(390),
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: G.setWidth(20),
                // crossAxisSpacing: G.setWidth(20),
                crossAxisCount: 3, //横轴三个子widget
                childAspectRatio: 1 //宽高比为1时，子widget
                ),
            itemCount: 6,
            itemBuilder: (context, index) {
              Map item = menuList[index];
              return InkWell(
                onTap: () {
                  G.router.navigateTo(context, item['url']);
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(item['icon'],
                        width: G.setWidth(80), height: G.setWidth(80)),
                    G.spacing(15),
                    Text(item['title'], style: TextStyle(
                      fontSize: G.setSp(28),
                      color: hex('#666')
                    ))
                  ],
                ),
              );
            },
          ),
        ));
  }

  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 3);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: EasyRefresh(
          controller: _refreshController,
          enableControlFinishRefresh: true,
          header: ClassicalHeader(
              // TODO:: 组件化
              refreshText: '下拉刷新',
              refreshReadyText: '释放以刷新',
              refreshingText: '刷新中……',
              refreshedText: '刷新完成',
              infoText: '更新于 %T'),
          onRefresh: () async {
            await Provider.of<UserProvide>(context).refreshUserinfo();
            _refreshController.finishRefresh(success: true);
          },
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: _getHomeinfo(context),
              builder: (context, shapshot) {
                // UserinfoModel userinfo =
                //     Provider.of<UserProvide>(context).userinfo;
                if (shapshot.hasData && homeinfo != null) {
                  return Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            alignment: Alignment.topCenter,
                            image: AssetImage(
                                '${G.imgBaseUrl}home/home-banner_1.png'),
                            fit: BoxFit.fitWidth)),
                    child: Column(
                      children: <Widget>[
                        _head(),
                        _userInfo(),
                        _mission(),
                        _statistics(),
                        _menu()
                      ],
                    ),
                  );
                } else {
                  return Container(
                      height: G.setHeight(1334),
                      width: double.infinity,
                      child: VLoading());
                }
              },
            ),
          )),
    );
  }
}

// tooltip 如有需要可封装成组件
class ToolTip extends StatefulWidget {
  final String direction;
  ToolTip({@required this.direction});
  @override
  _ToolTipState createState() => _ToolTipState();
}

class _ToolTipState extends State<ToolTip> {
  bool show = false;
  Timer _timer;
  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          if (show == false) {
            setState(() {
              show = !show;
            });
            if (show) {
              _timer = Timer.periodic(Duration(seconds: 3), (timer) async {
                setState(() {
                  show = false;
                });
                _timer?.cancel();
              });
            }
          } else {
            _timer?.cancel();
            setState(() {
              show = false;
            });
          }
        },
        child: SimpleTooltip(
          arrowTipDistance: G.setHeight(10),
          backgroundColor: rgba(0, 0, 0, 0.6),
          ballonPadding: EdgeInsets.all(0),
          borderRadius: G.setWidth(10),
          customShadows: [],
          borderWidth: 0,
          borderColor: Colors.transparent,
          arrowBaseWidth: G.setWidth(20),
          arrowLength: G.setWidth(20),
          animationDuration: Duration(seconds: 0),
          show: show,
          tooltipDirection: widget.direction == 'down'
              ? TooltipDirection.down
              : TooltipDirection.left,
          child: Image.asset(
            '${G.imgBaseUrl}pic-icon/info_icon.png',
            width: G.setWidth(36),
            height: G.setWidth(36),
          ),
          content: Text("代理商通过销售产品礼包，获得产品礼包总额的30%作为销售分佣。产品礼包总额的30%作为销售分佣。",
              style: TextStyle(
                decoration: TextDecoration.none,
                fontSize: G.setSp(24),
                color: hex('#FFF'),
              )),
        ));
  }
}