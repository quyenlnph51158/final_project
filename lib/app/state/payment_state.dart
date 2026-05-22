import 'package:freezed_annotation/freezed_annotation.dart';

// Tên file này phải trùng với tên file vật lý (payment_state.dart)
part 'payment_state.freezed.dart';

@freezed
class PaymentState with _$PaymentState {
  const factory PaymentState.initial() = _Initial;
  const factory PaymentState.loading() = _Loading;
  const factory PaymentState.processing() = _Processing;
  const factory PaymentState.success() = _Success;
  const factory PaymentState.failure(String error) = _Failure;
}