import 'package:final_project/features/tour/presentation/sections/promotion_section.dart';

import '../../../../core/constants/colors.dart';
import '../../data/models/policy_infomation.dart';

class PolicyState{
  final String? errorMessage;
  final Policy? policy;
  final bool isLoading;
  final TravelTab selectedTab;
  final FlightTab selectedFlightTab;
  const PolicyState({
    required this.errorMessage,
    required this.policy,
    required this.isLoading,
    required this.selectedTab,
    required this.selectedFlightTab,

  });
  factory PolicyState.initial()
  {
    return PolicyState(
      errorMessage: null,
      policy: null,
      isLoading: true,
      selectedTab: TravelTab.tour,
      selectedFlightTab: FlightTab.flight
    );
  }
  PolicyState copyWith({
    String? errorMessage,
    Policy? policy,
    bool? isLoading,
    TravelTab? selectedTab,
    FlightTab? selectedFlightTab,
  }){
    return PolicyState(
      errorMessage: errorMessage ?? this.errorMessage,
      policy: policy ?? this.policy,
      isLoading: isLoading ?? this.isLoading,
      selectedTab: selectedTab ?? this.selectedTab,
      selectedFlightTab: selectedFlightTab ?? this.selectedFlightTab,
    );
}


}