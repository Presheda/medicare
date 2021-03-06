import 'dart:async';

import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:medicare/Services/notification_service/notification_service.dart';
import 'package:medicare/datamodel/notification_data.dart';
import 'package:medicare/utils/constant_string.dart';
import 'package:medicare/utils/locator.dart';

import '../home_screen_controller.dart';

class NotificationController extends GetxController {
  NotificationService _notificationService = locator<NotificationService>();

  List<NotificationData> notificationList = [];

  StreamSubscription<List<NotificationData>> _subscription;

  @override
  void onInit() {
    fetchNotification();

    super.onInit();
  }

  void closeDrawer(HomeMenu menu) {
    try {
      var controller = Get.find<HomeScreenController>();

      controller.closeDrawer(menu);
    } catch (e) {}
  }

  void fetchNotification() {
    _subscription = _notificationService.listenForStudentData().listen((event) {
      notificationList = event ?? [];
      update();
    });
  }

  String getImage(int i) {
    return notificationList[i].type == 0
        ? Constant.pillsImage
        : Constant.timeIcon;
  }

  @override
  void onClose() {
    _subscription?.cancel();
    super.onClose();
  }

  String getTimeNotif(int i) {
    DateTime date =
        DateTime.fromMillisecondsSinceEpoch(notificationList[i].time);

    var time = Jiffy({
      "year": date.year,
      "month": date.month,
      "day": date.day,
      "hour": date.hour
    }).jm;

    return notificationList[i].type == 0
        ? time
        : "$time " +
            " ${Jiffy({
              "year": date.year,
              "month": date.month,
              "day": date.day,
              "hour": date.hour
            }).yMMMMd}";
  }
}
