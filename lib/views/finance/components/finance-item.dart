import 'package:agent37_flutter/models/finance.dart';
import 'package:agent37_flutter/utils/global.dart';
import 'package:color_dart/color_dart.dart';
import 'package:flutter/material.dart';

class FinanceItem extends StatelessWidget {
  final FinanceItemModel item;
  FinanceItem(this.item);

  @override
  Widget build(BuildContext context) {
    // 财务列表子项产品内容
    List<Widget> _financeItemProduct() {
      Widget product(RefundOrders product) {
        return Stack(overflow: Overflow.visible, children: <Widget>[
          Container(
              padding: EdgeInsets.symmetric(vertical: G.setWidth(30)),
              decoration: BoxDecoration(
                  border: Border(
                      bottom: BorderSide(
                          color: hex('#ddd'), width: G.setWidth(1)))),
              child: Column(
                children: <Widget>[
                  Container(
                    width: G.setWidth(710),
                    // padding: EdgeInsets.only(bottom: G.setWidth(15)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: G.setWidth(170),
                          height: G.setWidth(170),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(G.setWidth(10)),
                              image: product.orderImageUrl != null
                              ? DecorationImage(
                                  image: NetworkImage(
                                    // 产品图
                                    product.orderImageUrl,
                                  ),
                                  fit: BoxFit.fill)
                                  : null
                                  )
                              ,
                        ),
                        Expanded(
                          // 内容区域
                          // flex: 1,
                          child: Container(
                              height: G.setWidth(170),
                              padding: EdgeInsets.symmetric(
                                  horizontal: G.setWidth(20)),
                              child: Column(
                                // 规格说明
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  // 标题与价格
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                          width: G.setWidth(324),
                                          child: Text(
                                            product.goodsName,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                fontSize: G.setSp(26),
                                                color: hex('333')),
                                          )),
                                      Text.rich(
                                        TextSpan(
                                            style: TextStyle(
                                                fontSize: G.setSp(24),
                                                color: hex('#333')),
                                            text: '￥',
                                            children: [
                                              TextSpan(
                                                  text: product.refundAmount.toString(),
                                                  style: TextStyle(
                                                      fontSize: G.setSp(26),
                                                      color: hex('#333'))),
                                            ]),
                                      )
                                    ],
                                  ),
                                  G.spacing(10),
                                  // 规格 数量
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(product.spec??'',
                                          style: TextStyle(
                                              color: hex('#85868A'),
                                              fontSize: G.setSp(26))),
                                      Text('X${product.quantity}',
                                          style: TextStyle(
                                              color: hex('#85868A'),
                                              fontSize: G.setSp(26)))
                                    ],
                                  ),
                                  G.spacing(20),
                                  product.refundOrderTime != null 
                                  ? Text('退款时间：${G.formatTime(product.refundOrderTime)}',
                                      style: TextStyle(
                                          color: hex('#85868A'),
                                          fontSize: G.setSp(24)))
                                  : Container()
                                ],
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              )),
          // Divider(color: hex('D7D7D7'),),
          Positioned(
            top: 0,
            right: G.setWidth(-20),
            child: Image.asset(
              '${G.imgBaseUrl}pic-icon/refund_icon.png',
              width: G.setWidth(78),
              height: G.setWidth(78),
            ),
          )
          // Divider(color: hex('#d7d7d7'))
        ]);
      }

      List<RefundOrders> productList = item.refundOrders;
      return productList.map((type) {
        return product(type);
      }).toList();
    }

    // 财务列表页脚
    Widget _financeItemFooter() {
      return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: G.setWidth(300),
                  child: Text('购买企业：${item.enterpriseName ?? "未知"}',
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                    style: TextStyle(
                        color: hex('#666'),
                        fontSize: G.setSp(24),
                        height: 36 / 24)),
                ),
                // G.spacing(6),

                Text('支付时间：${G.formatTime(item.payTime)}',
                    style: TextStyle(
                        color: hex('#666'),
                        fontSize: G.setSp(24),
                        height: 36 / 24))
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Text.rich(TextSpan(
                    text: '订单金额：',
                    style: TextStyle(
                        color: hex('#252525'),
                        fontSize: G.setSp(30),
                        height: 36 / 24),
                    children: [
                      TextSpan(
                          text: '￥',
                          style: TextStyle(
                              color: hex('#252525'), fontSize: G.setSp(24))),
                      TextSpan(
                          text: item.totalOrderAmount.toString(),
                          style: TextStyle(
                              color: hex('#252525'), fontSize: G.setSp(30))),
                    ])),
                item.commissionFeeRate != null 
                ? Text('比例：${item.commissionFeeRate}%',
                    style: TextStyle(
                        height: 36 / 24,
                        color: hex('#252525'),
                        fontSize: G.setSp(26)))
                : Container(),
                Text.rich(TextSpan(
                    text: '预估服务费：',
                    style: TextStyle(
                        height: 36 / 24,
                        color: hex('#252525'),
                        fontSize: G.setSp(30)),
                    children: [
                      TextSpan(
                          text: '￥',
                          style: TextStyle(
                              color: hex('#252525'), fontSize: G.setSp(24))),
                      TextSpan(
                          text: item.commission.toString(),
                          style: TextStyle(
                              color: hex('#252525'), fontSize: G.setSp(30))),
                    ])),
              ],
            )
          ],
        ),
      );
    }

    return Container(
      width: G.setWidth(710),
      margin: EdgeInsets.symmetric(horizontal: G.setWidth(20)),
      padding: EdgeInsets.all(G.setWidth(20)),
      decoration: BoxDecoration(
          color: hex('#FFF'),
          borderRadius: BorderRadius.circular(G.setWidth(10))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('单号：${item.orderNo}'),
                  item.isShowTodayFlag
                      ? Container(
                          margin: EdgeInsets.only(left: G.setWidth(10)),
                          child: Image.asset(
                            '${G.imgBaseUrl}pic-icon/new-ellipse.png',
                            width: G.setWidth(60),
                            height: G.setWidth(34),
                          ),
                        )
                      : Container()
                ],
              ),
              Text(['未知', '待结算', '已结算', '已关闭'][item.status])
            ],
          ),
          Container(
            height: G.setWidth(18),
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(
                        color: hex('#D7D7D7'), width: G.setWidth(1)))),
          ),
          FinanceProduct(item),
          item.refundOrders != null && item.refundOrders.length > 0
              ? Column(children: _financeItemProduct())
              : Container(),
          G.spacing(16),
          _financeItemFooter()
        ],
      ),
    );
  }
}

class FinanceProduct extends StatelessWidget {
  final FinanceItemModel data;
  FinanceProduct(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: G.setWidth(30)),
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: hex('#ddd'), width: G.setWidth(1)))),
        child: Column(
          children: <Widget>[
            Container(
              width: G.setWidth(710),
              // padding: EdgeInsets.only(bottom: G.setWidth(15)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: G.setWidth(170),
                    height: G.setWidth(170),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(G.setWidth(10)),
                        image: data.orderImageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(
                              // 产品图
                              data.orderImageUrl,
                            ),
                            fit: BoxFit.fill)
                        : null 
                    ),
                  ),
                  Expanded(
                    // 内容区域
                    // flex: 1,
                    child: Container(
                        height: G.setWidth(170),
                        padding:
                            EdgeInsets.symmetric(horizontal: G.setWidth(20)),
                        child: Column(
                          // 规格说明
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // 标题与价格
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                    width: G.setWidth(324),
                                    child: Text(
                                      data.goodsName,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: G.setSp(26),
                                          color: hex('333')),
                                    )),
                                Text.rich(
                                  TextSpan(
                                      style: TextStyle(
                                          fontSize: G.setSp(24),
                                          color: hex('#333')),
                                      text: '￥',
                                      children: [
                                        TextSpan(
                                            text: data.goodsAmount.toString(),
                                            style: TextStyle(
                                                fontSize: G.setSp(26),
                                                color: hex('#333'))),
                                      ]),
                                )
                              ],
                            ),
                            G.spacing(10),
                            // 规格 数量
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(data.spec??'',
                                    style: TextStyle(
                                        color: hex('#85868A'),
                                        fontSize: G.setSp(26))),
                                Text('X${data.quantity}',
                                    style: TextStyle(
                                        color: hex('#85868A'),
                                        fontSize: G.setSp(26)))
                              ],
                            ),
                          ],
                        )),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}
