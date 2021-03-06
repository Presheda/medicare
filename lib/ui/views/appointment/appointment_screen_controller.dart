import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:medicare/Services/appointment_service/appointment_service.dart';
import 'package:medicare/datamodel/appointment_history.dart';
import 'package:medicare/ui/shared/info_snackbar.dart';
import 'package:medicare/utils/locator.dart';

import '../home_screen_controller.dart';

class AppointmentScreenController extends GetxController {
  TextEditingController complaintController = TextEditingController();

  FocusNode complainFocus = FocusNode();

  AppointmentService _appointmentService = locator<AppointmentService>();

  bool showAppointTime = false;

  ScheduleTime scheduleTime = ScheduleTime.eleven05;

  bool submittedAppointment = false;

  void closeDrawer() {
    try {
      var controller = Get.find<HomeScreenController>();

      controller.closeDrawer(HomeMenu.dashboard);
    } catch (e) {}
  }

  void nextClicked() {
    if (submittedAppointment == true) {
      closeDrawer();

      return;
    }

    if (showAppointTime == true) {
      submittedAppointment = true;

      update();

      _appointmentService.bookAppointment();

      return;
    }

    String complain = complaintController.text.trim();

    if (complain.isEmpty) {
      showInfoSnackBar(message: "Please enter a complaint");
      return;
    }

    showAppointTime = true;

    update();
  }

  String getTitle(ScheduleTime e) {
    var jiffy = Jiffy();

    switch (e) {
      case ScheduleTime.eleven05:
        jiffy.add(minutes: 5);
        break;

      case ScheduleTime.eleven10:
        jiffy.add(minutes: 10);
        break;
      case ScheduleTime.eleven15:
        jiffy.add(minutes: 15);
        break;
      case ScheduleTime.eleven20:
        jiffy.add(minutes: 20);
        break;
      case ScheduleTime.eleven25:
        jiffy.add(minutes: 25);
        break;
      case ScheduleTime.eleven30:
        jiffy.add(minutes: 30);
        break;
    }

    String time = jiffy.jm;

    return time;
  }

  void selectTime(ScheduleTime e) {
    scheduleTime = e;

    update();
  }

  String getButtonText() {
    if (submittedAppointment) return "Go Home".toUpperCase();

    return showAppointTime ? "Submit".toUpperCase() : "next".toUpperCase();
  }
}

enum ScheduleTime { eleven05, eleven10, eleven15, eleven20, eleven25, eleven30 }
