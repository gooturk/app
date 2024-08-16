import 'package:gooturk/common/model/custom_button_model.dart';
import 'package:gooturk/common/model/custom_dialog_model.dart';

class CustomException implements Exception {
  final String message;
  final CustomDialogModel dialogModel;

  CustomException({
    required this.message,
    required this.dialogModel,
  });

  @override
  String toString() {
    return 'error occurred : $message';
  }
}

class AccountDeleteException extends CustomException {
  AccountDeleteException()
      : super(
          message: '계정 삭제 중 오류가 발생했습니다.',
          dialogModel: CustomDialogModel(
            title: '계정 삭제 오류',
            description: '계정 삭제 중 오류가 발생했습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class NoInternetException extends CustomException {
  NoInternetException()
      : super(
          message: '인터넷 연결이 끊겼습니다.',
          dialogModel: CustomDialogModel(
            title: '인터넷 연결 오류',
            description: '인터넷 연결이 끊겼습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class AppleSocialLoginException extends CustomException {
  AppleSocialLoginException()
      : super(
          message: 'Apple 로그인 중 오류가 발생했습니다.',
          dialogModel: CustomDialogModel(
            title: 'Apple 로그인 오류',
            description: 'Apple 로그인 중 오류가 발생했습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class UnimplementedException extends CustomException {
  UnimplementedException()
      : super(
          message: '아직 준비중인 기능입니다.',
          dialogModel: CustomDialogModel(
            title: '알림',
            description: '아직 준비중인 기능이에요',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class UnknownAnnouncementException extends CustomException {
  UnknownAnnouncementException()
      : super(
          message: '알 수 없는 공지사항입니다.',
          dialogModel: CustomDialogModel(
            title: '알림',
            description: '알 수 없는 공지사항입니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class UnknownCafeException extends CustomException {
  UnknownCafeException()
      : super(
          message: '알 수 없는 카페입니다.',
          dialogModel: CustomDialogModel(
            title: '알림',
            description: '알 수 없는 카페입니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class GPSException extends CustomException {
  GPSException()
      : super(
          message: 'GPS를 켜주세요.',
          dialogModel: CustomDialogModel(
            title: 'GPS 오류',
            description: 'GPS를 켜주세요.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class MatchingException extends CustomException {
  MatchingException()
      : super(
          message: '매칭 중 오류가 발생했습니다.',
          dialogModel: CustomDialogModel(
            title: '매칭 오류',
            description: '매칭 중 오류가 발생했습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class MatchingFailedException extends CustomException {
  MatchingFailedException()
      : super(
          message: '주변 카페가 수락하지 않아 매칭에 실패했습니다.',
          dialogModel: CustomDialogModel(
            title: '매칭 실패',
            description: '매칭에 실패했습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class NotMatchedException extends CustomException {
  NotMatchedException()
      : super(
          message: '완료된 매칭이 없습니다.',
          dialogModel: CustomDialogModel(
            title: '매칭 오류',
            description: '완료된 매칭이 없습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}

class MethodChannelException extends CustomException {
  MethodChannelException()
      : super(
          message: 'MethodChannel이 초기화되지 않았습니다.',
          dialogModel: CustomDialogModel(
            title: 'MethodChannel 오류',
            description: 'MethodChannel이 초기화되지 않았습니다.',
            customButtonModel: CustomButtonModel(
              title: '확인',
            ),
          ),
        );
}