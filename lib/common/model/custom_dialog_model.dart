
import 'package:gooturk/common/model/custom_button_model.dart';

class CustomDialogModel {
  final String title;
  final String description;
  final CustomButtonModel customButtonModel;

  CustomDialogModel({
    required this.title,
    required this.description,
    required this.customButtonModel,
  });
}

class CustomDialogWithTwoButtonsModel extends CustomDialogModel {
  final CustomButtonModel customButtonModelSecond;

  CustomDialogWithTwoButtonsModel({
    required super.title,
    required super.description,
    required super.customButtonModel,
    required this.customButtonModelSecond,
  });
}
