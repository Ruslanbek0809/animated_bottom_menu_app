import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:injectable/injectable.dart';

part 'app_action_cubit.freezed.dart';
part 'app_action_state.dart';

@injectable
class AppActionCubit extends Cubit<AppActionState> {
  AppActionCubit() : super(AppActionState.initial());

  void isSlidedChanged(bool isSlided) async {
    emit(
      state.copyWith(
        isSlided: isSlided,
      ),
    );
  }

  void isDraggedChanged(bool isDragged) async {
    emit(
      state.copyWith(
        isDragged: isDragged,
      ),
    );
  }

  void isSlidedDraggedChanged(bool isSlided, bool isDragged) async {
    emit(
      state.copyWith(
        isSlided: isSlided,
        isDragged: isDragged,
      ),
    );
  }
}
