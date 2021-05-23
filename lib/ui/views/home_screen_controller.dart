import 'dart:async';

import 'package:get/get.dart';
import 'package:medicare/Services/auth_service/auth_service.dart';
import 'package:medicare/Services/student_data_service/student_data_service.dart';
import 'package:medicare/datamodel/student_data.dart';
import 'package:medicare/ui/route/route_names.dart';
import 'package:medicare/utils/locator.dart';

import 'authentication/default_auth/default_auth_screen.dart';

class HomeScreenController extends GetxController {
  HomeMenu selectedItem = HomeMenu.dashboard;

  bool isDarkMode = false;

  AuthService _authService = locator<AuthService>();
  StudentDataService _studentDataService = locator<StudentDataService>();

  bool isAssistant = false;

  StreamSubscription<bool> _authSubscription;

  bool enableNotifications = true;

  StreamSubscription<StudentData> _studentDataStreamSub;
  StudentData studentData =
      StudentData(name: "Null", email: "Null", matric: "Null");

  void closeDrawer(HomeMenu option) async {
    Get.back();

    await Future.delayed(Duration(milliseconds: 500));

    if (option == HomeMenu.signOut) {
      try {
        await _authService.signOut();
      } catch (e) {}

      Get.offNamedUntil(RouteName.default_auth, (route) => false);

      return;
    }

    selectedItem = option;
    update();
  }

  @override
  void onInit() {
    super.onInit();
    listenForAuthChanges();
    fetchStudentData();
  }

  void fetchStudentData() {
    _studentDataStreamSub =
        _studentDataService.listenForStudentData().listen((event) {
      studentData =
          event ?? StudentData(name: "Null", email: "Null", matric: "Null");

      update();
    });
  }

  void listenForAuthChanges() {
    _authSubscription = _authService.changeUser().listen((event) {
      if (!event) {
        Get.offAll(AuthScreen());
      }

      update();
    });
  }

  @override
  Future<void> onClose() async {
    await _authSubscription?.cancel();

    await _studentDataStreamSub?.cancel();

    return super.onClose();
  }

  String getDeggiaPopMenuTitle({DeggiaPopMenu value}) {
    String title = "";

    switch (value) {
      case DeggiaPopMenu.theme:
        title = "Theme";
        break;
      case DeggiaPopMenu.topic:
        title = "Enable Notifications";
        break;
      case DeggiaPopMenu.notification:
        title = "Send Notifications";
        break;
    }

    return title;
  }
}

enum DeggiaPopMenu {
  theme,
  topic,
  notification,
}

enum HomeMenu {
  dashboard,
  appointment,
  pill_reminder,
  notifications,
  appointment_history,
  signOut
}