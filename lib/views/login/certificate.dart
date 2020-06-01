import 'dart:async';
import 'package:agent37_flutter/api/member.dart';
import 'package:agent37_flutter/api/order.dart';
import 'package:agent37_flutter/components/v-button.dart';
import 'package:agent37_flutter/components/v-loading.dart';
import 'package:agent37_flutter/models/gift-packages.dart';
import 'package:agent37_flutter/provide/user.dart';
import 'package:agent37_flutter/utils/global.dart';
import 'package:agent37_flutter/utils/oss.dart';
import 'package:agent37_flutter/utils/validate.dart';
import 'package:agent37_flutter/views/login/components/gift-item.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CertificatePage extends StatefulWidget {
  final String no;
  final String from;
  CertificatePage({this.no, this.from});
  @override
  _CertificatePageState createState() => _CertificatePageState();
}

class _CertificatePageState extends State<CertificatePage> {
  GiftPackagesModel curGift;
  Timer _timer;
  int _countdownTime;
  var giftListFuture;
  String offlineVoucher;
  int _orderOverTime = 0;

  void _getOrderInfo() async {
    if (widget.from == 'order' && !Validate.isNon(G.getPref('orderOverTime'))) {
      setState(() {
        _orderOverTime = int.parse(G.getPref('orderOverTime'));
      });
    } else {
      var result = await OrderApi().getGiftPackageOrders();
      setState(() {
        _orderOverTime = result.data['data']['orderOverime'];
      });
      G.setPref('orderOverTime', result.data['data']['orderOverime'].toString());
    }
    countDown();
  }

  countDown() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      int nowTime = (DateTime.now().millisecondsSinceEpoch / 1000).round();
      int result = (_orderOverTime / 1000).round() - nowTime;
      if (result < 0) {
        _timer?.cancel();
        G.navigateTo(context, '/create-account', replace: true);
      }
      setState(() {
        _countdownTime = result;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   _countdownTime = int.parse(widget.time);
    // });
    // startCountdownTimer();
    _getOrderInfo();
    giftListFuture = _getGiftList();
    // _getGiftList();
  }

  @override
  void dispose() {
    super.dispose();
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hex('#F3F4F6'),
      appBar: AppBar(
        title: Text('线下凭证上传'),
        centerTitle: true,
        elevation: 0,
      ),
      body: Container(
        // padding: G.setWidth(20),
        child: Column(
          children: <Widget>[
            FutureBuilder(
              future: giftListFuture,
              builder: (context, shapshot) {
                if (shapshot.hasData && curGift != null) {
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: G.setWidth(20)),
                    child: GiftItem(item: curGift),
                  );
                } else {
                  return VLoading();
                }
              },
            ),
            Container(
              height: G.setWidth(74),
              alignment: Alignment.center,
              child: Text(_clock(_countdownTime),
                  style: TextStyle(fontSize: G.setSp(24), color: hex('#999'))),
            ),
            _upload(),
            _btnWrap()
          ],
        ),
      ),
    );
  }

  Future _getGiftList() async {
    var result = await MemberApi().giftpackage();
    if (result.data['code'] == 200 && result.data['data'] != null) {
      result.data['data'].forEach((item) {
        GiftPackagesModel gift = GiftPackagesModel.fromJson(item);
        if (gift.giftPackageNo == widget.no) {
          setState(() {
            curGift = gift;
          });
        }
      });
      if (curGift == null) {
        G.toast('礼包已失效，请重新选择');
        G.navigateTo(context, '/create-account', replace: true);
      }
      return 'end';
    }
  }

  void startCountdownTimer() {
    const oneSec = const Duration(seconds: 1);

    var callback = (timer) {
      return setState(() {
        if (_countdownTime < 1) {
          _timer.cancel();
          G.removePref('orderOverTime');
          G.navigateTo(context, '/create-account', replace: true);
        } else {
          _countdownTime = _countdownTime - 1;
        }
      });
    };

    _timer = Timer.periodic(oneSec, callback);
  }

  String _clock(int restTime) {
    if (restTime != null) {
      int hour = (restTime / 3600).floor();
      int min = restTime % 3600 ~/ 60;
      int sec = restTime % 60;
      return '剩余支付时间：$hour时$min分$sec秒';
    }
    return '剩余支付时间：计算中……';
  }

  Widget _upload() {
    return Container(
        width: double.infinity,
        height: G.setHeight(480),
        padding: EdgeInsets.all(G.setWidth(20)),
        decoration: BoxDecoration(color: hex('#fff')),
        child: Column(
          children: <Widget>[
            InkWell(
                onTap: () {
                  G.setContext(context);
                  Oss.selectSource((path) {
                    setState(() {
                      offlineVoucher = path;
                    });
                    print(offlineVoucher);
                  });
                },
                child: Container(
                  height: G.setHeight(378),
                  child: Stack(
                    children: <Widget>[
                      Container(
                        width: G.setWidth(710),
                        height: G.setHeight(378),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                Validate.isNon(offlineVoucher)
                                    ? 0
                                    : G.setWidth(10)),
                            image: Validate.isNon(offlineVoucher)
                                ? DecorationImage(
                                    fit: BoxFit.fill,
                                    image: AssetImage(
                                        'lib/assets/images/upload-bill_bg.png'))
                                : null),
                        child: Validate.isNon(offlineVoucher)
                            ? null
                            : FadeInImage.assetNetwork(
                                fit: BoxFit.scaleDown,
                                placeholder: '${G.imgBaseUrl}loading.gif', // kTransparentImage,
                                image: offlineVoucher),
                      ),
                      !Validate.isNon(offlineVoucher)
                          ? Container(
                              alignment: Alignment.center,
                              color: rgba(0, 0, 0, .5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Image.asset(
                                    'lib/assets/images/upload-billed_icon.png',
                                    width: G.setWidth(60),
                                    height: G.setHeight(60),
                                  ),
                                  G.spacing(18),
                                  Text('点击重新上传',
                                      style: TextStyle(
                                          fontSize: G.setSp(28),
                                          color: hex('#fff')))
                                ],
                              ),
                            )
                          : Container()
                    ],
                  ),
                )),
            G.spacing(25),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.error_outline,
                  size: G.setWidth(24),
                  color: hex('#999'),
                ),
                Container(width: G.setWidth(10)),
                Text(
                  '请务必上传清晰完整的支付凭证，否则影响审核结果',
                  style: TextStyle(fontSize: G.setSp(24), color: hex('#999')),
                )
              ],
            )
          ],
        ));
  }

  Widget _btnWrap() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: G.setWidth(50)),
      margin: EdgeInsets.only(top: G.setHeight(80)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          VButton(
            rgbStart: [214, 219, 255],
            rgbEnd: [214, 219, 255],
            textColor: '#6982FF',
            width: 310,
            fn: () {
              G.navigateTo(context, '/create-account', replace: true);
            },
            text: '重选礼包',
            shadown: [
              BoxShadow(
                  color: hex('#BABFE1'), blurRadius: 2.0, spreadRadius: 0.0)
            ],
          ),
          VButton(
              width: 310,
              fn: () async {
                if (Validate.isNon(offlineVoucher)) {
                  G.toast('请上传凭证');
                } else {
                  Map data = {
                    'giftPackageNo': curGift.giftPackageNo,
                    'giftPackagePromotionNo': curGift.giftPackagePromotionNo,
                    'offlineVoucher': offlineVoucher
                  };
                  var result = await OrderApi().offlinePay(data);
                  if (result.data['code'] == 200 && result.data['data'] == true) {
                    // G.toast('提交凭证成功');
                    G.removePref('orderOverTime');
                    Provider.of<UserProvide>(context).updateUserAuth();
                  } else {
                    G.toast('凭证提交失败');
                  }
                }
              },
              text: '提交凭证',
              shadown: [
                BoxShadow(
                    color: hex('#6D7FFE'), blurRadius: 2.0, spreadRadius: 0.0)
              ])
        ],
      ),
    );
  }
}
