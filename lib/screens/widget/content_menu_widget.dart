import 'package:booklibrary/core/app_assets.dart';
import 'package:booklibrary/core/app_core.dart';
import 'package:booklibrary/core/helpers/image_helper.dart';
import 'package:booklibrary/data/local/local_db_manager.dart';
import 'package:booklibrary/model/pdf_file_model.dart';
import 'package:booklibrary/screens/widget/detail_dialog_widget.dart';
import 'package:booklibrary/screens/widget/dialog_confirm.dart';
import 'package:booklibrary/screens/widget/dialog_rename.dart';
import 'package:booklibrary/widgets/dialog_widget.dart';
import 'package:booklibrary/widgets/item_pdf_vertical.dart';
import 'package:booklibrary/widgets/touchable.dart';
import 'package:flutter/material.dart';

import '../../core/extentions/textstyles.dart';
import 'package:get/get.dart';

import '../../utils/pdf_file_manager.dart';

class ContentMenuWidget extends StatelessWidget {
  final PdfFileModel? data;
  final Decoration? decoration;
  bool? isFavorite;
  Function()? onDeleteFile;
  Function()? onFavorite;
  Function()? onPrint;

  ContentMenuWidget(
      {Key? key,
      this.data,
      this.decoration,
      this.isFavorite,
      this.onDeleteFile,
      this.onFavorite,
      this.onPrint})
      : super(key: key);

  StateSetter? nameState;

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const SizedBox();
    }
    return Container(
      decoration: decoration,
      padding: const EdgeInsets.all(10),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            StatefulBuilder(builder: (c, s) {
              nameState = s;
              return itemPdfVertical(data!, hideMenuIcon: true);
            }),
            const SizedBox(
              height: 10,
            ),
            _buildItem(AppAssets.icInfo, I18n().detailStr.tr, () {
              Get.dialog(DetailDialogWidget(data!));
            }),
            _buildItem(
              AppAssets.icEdit,
              I18n().renameStr.tr,
              () {
                Get.dialog(
                  DialogRename(
                    title: I18n().renameStr.tr,
                    text: data?.name
                        ?.substring(0, data?.name?.lastIndexOf('.pdf')),
                    callback: (name) async {
                      String newPath = data?.path ?? '';
                      try {
                        newPath =
                            newPath.substring(0, newPath.lastIndexOf('/'));
                        newPath = '$newPath/$name.pdf';
                        if (LocalDbManager().checkFileExits(newPath)) {
                          showSnackBarAction(
                              title: 'Thất bại',
                              message: 'Tên file đã tồn tại!');
                        } else {
                          await PdfManager()
                              .renameFile(newPath, data?.path ?? '');

                          data?.name = '$name.pdf';
                          data?.path = newPath;

                          if (nameState != null) {
                            nameState!(() {});
                          }
                        }
                      } catch (e) {}
                    },
                  ),
                );
              },
            ),
            StatefulBuilder(
              builder: (c, sate) {
                return _buildItem(
                  isFavorite == true
                      ? AppAssets.icUnFavorite
                      : AppAssets.icFavorite,
                  isFavorite == true
                      ? I18n().unFavoriteStr.tr
                      : I18n().favoriteStr.tr,
                  () {
                    isFavorite = !(isFavorite ?? false);
                    if (isFavorite == true) {
                      LocalDbManager().addFavorite(data!);
                    } else {
                      LocalDbManager().removeFavorite(data!);
                    }
                    sate(() {});
                    onFavorite?.call();
                  },
                );
              },
            ),
            _buildItem(AppAssets.icShare, I18n().shareStr.tr, () {
              PdfManager().shareFile(data?.path ?? '');
            }),
            _buildItem(
              AppAssets.icPrint,
              I18n().printStr.tr,
              () {
                onPrint?.call();
              },
            ),
            _buildItem(
              AppAssets.icBin,
              I18n().deleteStr.tr,
              () async {
                if (data != null) {
                  await Get.dialog(
                    DialogConfirmWidget(
                      callBack: () async {
                        await PdfManager().deleteFile(data!);
                        onDeleteFile?.call();
                        Get.back();
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String icon, String title, Function() callBack,
      {Color? iconColor}) {
    return Touchable(
      onTap: callBack,
      rippleAnimation: true,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            ImageHelper.loadFromAsset(icon, tintColor: iconColor),
            const SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyles.defaultStyle
                  .copyWith(color: const Color(0xff536A92)),
            ),
          ],
        ),
      ),
    );
  }
}
