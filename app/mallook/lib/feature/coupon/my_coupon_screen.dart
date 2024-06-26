import 'package:flutter/material.dart';
import 'package:mallook/constants/gaps.dart';
import 'package:mallook/constants/sizes.dart';
import 'package:mallook/feature/coupon/api/coupon_api_service.dart';
import 'package:mallook/feature/coupon/model/page_my_coupon.dart';
import 'package:mallook/global/widget/custom_circular_wait_widget.dart';
import 'package:mallook/global/widget/home_icon_button.dart';

class MyCouponScreen extends StatefulWidget {
  const MyCouponScreen({super.key});

  @override
  State<MyCouponScreen> createState() => _MyCouponScreenState();
}

class _MyCouponScreenState extends State<MyCouponScreen> {
  final ScrollController _scrollController = ScrollController();
  final List<MyCoupon> coupons = [];
  int _cursor = 99999999999;
  bool _isCouponLoading = false;

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (_scrollController.offset >=
              (_scrollController.position.maxScrollExtent * 0.9) &&
          !_scrollController.position.outOfRange) {
        _loadMoreCoupons();
      }
    });
    _loadMoreCoupons();
  }

  void _loadMoreCoupons() async {
    if (_cursor == 0) return;
    if (!_isCouponLoading) {
      if (mounted) {
        setState(() {
          _isCouponLoading = true;
        });
      }

      try {
        var loadedCoupons =
            await CouponApiService.getMyCoupons(cursor: _cursor);
        if (mounted) {
          setState(() {
            coupons.addAll(
                (loadedCoupons.content ?? [])); // 기존 _products List에 새로운 제품 추가
            if ((loadedCoupons.content ?? []).isNotEmpty) {
              _cursor = (loadedCoupons.content ?? []).last.myCouponId! - 1;
            }
          });
        }
      } finally {
        _isCouponLoading = false;
      }
    }
  }

  void _deleteCoupon(MyCoupon coupon) async {
    Map<String, dynamic> body = {
      "memberCouponList": [coupon.myCouponId],
    };

    var result = await CouponApiService.removeCoupon(body: body);
    coupons.remove(coupon);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 1,
        shadowColor: Colors.grey.shade400,
        centerTitle: true,
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: Sizes.size18,
        ),
        title: const Text('내 쿠폰 목록'),
        actions: const [
          HomeIconButton(),
          Gaps.h24,
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size12,
          vertical: Sizes.size24,
        ),
        child: RefreshIndicator(
          onRefresh: () async {
            _cursor = 999999999;
            coupons.clear();
            _loadMoreCoupons();
          },
          child: ListView.separated(
            controller: _scrollController,
            itemBuilder: (context, index) {
              if (index < coupons.length) {
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: Sizes.size2,
                    horizontal: Sizes.size4,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: Sizes.size10,
                    horizontal: Sizes.size14,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: Colors.grey.shade300,
                      width: Sizes.size1,
                    ),
                    borderRadius: BorderRadius.circular(
                      Sizes.size16,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        offset: const Offset(2, 1),
                      )
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coupons[index].name!,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: Sizes.size16,
                              ),
                            ),
                            Gaps.v10,
                            Text(
                              coupons[index].type == 'MONEY'
                                  ? '${coupons[index].amount} ₩'
                                  : '${coupons[index].amount} %',
                              style: const TextStyle(
                                color: Colors.pink,
                                fontSize: Sizes.size28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Gaps.v5,
                            Row(
                              children: [
                                Text(
                                  "만료: ",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Sizes.size14,
                                  ),
                                ),
                                Gaps.h5,
                                Text(
                                  coupons[index].expiredTime ?? "",
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontWeight: FontWeight.bold,
                                    fontSize: Sizes.size14,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Gaps.h20,
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            '삭제시 재발급이\n 어렵습니다.',
                            textAlign: TextAlign.center,
                            maxLines: 3,
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: Sizes.size10,
                            ),
                          ),
                          Gaps.v4,
                          ElevatedButton(
                            onPressed: () => _deleteCoupon(coupons[index]),
                            child: const Text("쿠폰 삭제"),
                          ),
                        ],
                      )
                    ],
                  ),
                );
              } else {
                return CustomCircularWaitWidget(
                  onTap: () => _loadMoreCoupons(),
                );
              }
            },
            separatorBuilder: (context, index) => Gaps.v10,
            itemCount: coupons.length + 1,
          ),
        ),
      ),
    );
  }
}
