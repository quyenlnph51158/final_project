import 'package:final_project/features/train/presentation/state/train_data_state.dart';
import 'package:final_project/features/train/presentation/state/train_filter_state.dart';
import 'package:final_project/features/train/presentation/state/train_form_state.dart';
import 'package:final_project/features/train/presentation/state/train_ui_state.dart';

class TrainState {
  final TrainFormState form;
  final TrainUiState ui;
  final TrainDataState data;
  final TrainFilterState filter;

  TrainState({
    required this.form,
    required this.ui,
    required this.data,
    required this.filter,
  });

  factory TrainState.initial() {
    return TrainState(
        form: TrainFormState.initial(),
        ui: TrainUiState.initial(),
        data: TrainDataState.initial(),
        filter: TrainFilterState.initial(),
    );
  }

  TrainState copyWith({
    TrainFormState? form,
    TrainUiState? ui,
    TrainDataState? data,
    TrainFilterState? filter,
  }) {
    return TrainState(
        form: form ?? this.form,
        ui: ui  ?? this.ui,
        data: data ?? this.data,
      filter: filter ?? this.filter
    );
  }
}
