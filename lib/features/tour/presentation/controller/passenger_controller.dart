import 'package:flutter/material.dart';


import '../state/passenger_state.dart';

class PassengerController extends ChangeNotifier {
  PassengerState _state;
  final int maxTotal = 9;

  PassengerController(PassengerState initialState) : _state = initialState;

  PassengerState get state => _state;

  void updateAdults(int val) {
    if (val < 1) return;
    int newInfants = _state.infants > val ? val : _state.infants;
    _state = _state.copyWith(adults: val, infants: newInfants);
    notifyListeners();
  }

  void updateChildren(int val) {
    if (val < 0 || (val + _state.adults) > maxTotal) return;
    _state = _state.copyWith(children: val);
    notifyListeners();
  }

  void updateInfants(int val) {
    if (val < 0 || val > _state.adults) return;
    _state = _state.copyWith(infants: val);
    notifyListeners();
  }
}