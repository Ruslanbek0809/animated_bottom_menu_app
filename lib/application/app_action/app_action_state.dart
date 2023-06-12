part of 'app_action_cubit.dart';

@freezed
class AppActionState with _$AppActionState {
  factory AppActionState({
    required bool isSlided,
    required bool isDragged,
  }) = _AppActionState;

  factory AppActionState.initial() => AppActionState(
        isSlided: false,
        isDragged: false,
      );
}
