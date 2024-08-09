import 'package:gooturk/common/component/custom_dialog.dart';
import 'package:gooturk/common/exception/custom_exception.dart';
import 'package:gooturk/common/provider/go_router_provider.dart';

class CustomExceptionHandler {
  static hanldeException(dynamic error) {
    if (error is CustomException) {
      showCustomDialog(
        context: rootNavigatorKey.currentContext!,
        model: error.dialogModel,
      )();
    } else if (error is Exception) {
      print(error);
    } else {
      print(error);
    }
  }
}
