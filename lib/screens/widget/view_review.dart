import 'package:booklibrary/constants.dart';
import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/app_functions.dart';
import 'package:booklibrary/core/extentions/textstyles.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/core/local_storage/localStorageHelper.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';

class ViewReview extends StatefulWidget {
  const ViewReview({Key? key}) : super(key: key);

  @override
  State<ViewReview> createState() => _ViewReviewState();
}

class _ViewReviewState extends State<ViewReview> {


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
      ),
      padding: const EdgeInsets.only(left: 18, right: 18, top: 18, bottom: 15),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ImageHelper.loadFromAsset(AppAssets.bgReview,
              fit: BoxFit.cover, width: 200, height: 146),
          const SizedBox(
            height: 30,
          ),
          Text(
            'Rate us 5 star',
            style: TextStyles.defaultStyle.bold
                .copyWith(fontSize: 24, color: const Color(0XFF536A92)),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            'Support us by  give 5 star and write your review',
            style: TextStyles.defaultStyle.normal
                .copyWith(fontSize: 14, color: const Color(0XFF333333)),
          ),
          const SizedBox(
            height: 30,
          ),
          ImageHelper.loadFromAsset(AppAssets.icStarRate,
              fit: BoxFit.cover, height: 40, width: 260),
          const SizedBox(
            height: 30,
          ),
          Touchable(
              onTap: () async{
                await LocalStorageHelper.setString(
                    KEY_DATE_TIME, '01/01/3000');
                Get.back();
                LaunchReview.launch(
                  androidAppId: "app.digitalcontent.onepdf",
                  iOSAppId: "585027354",
                );
              },
              child: Container(
                decoration: const BoxDecoration(
                    color: Color(0XFF536A92),
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                child: const Center(
                  child: Text(
                    'Rate Now',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                height: 42,
                width: 192,
              )),
          const SizedBox(
            height: 20,
          ),
          Touchable(
              onTap: () {
                Get.back();
              },
              child: const SizedBox(
                child: Center(
                  child: Text(
                    'Maybe later',
                    style: TextStyle(
                        color: Color(0XFFA1A1AA),fontSize: 14),
                  ),
                ),
                width: 192,
              )),
          const SizedBox(
            height: 5,
          ),
        ],
      ),
    );
  }
}
