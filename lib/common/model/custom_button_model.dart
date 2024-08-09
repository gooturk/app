class CustomButtonModel {
  final String title;
  final bool? isDisabled;
  final bool? isDismiss;
  final Function()? onPressed;
  CustomButtonModel({
    required this.title,
    this.isDisabled,
    this.onPressed,
    this.isDismiss,
  });
}
