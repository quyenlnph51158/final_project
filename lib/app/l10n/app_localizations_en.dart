// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'Final Project';

  @override
  String get general_hotline => 'Hotline';

  @override
  String get general_hotlineNumber => '+84 90 111 81 85';

  @override
  String get general_emailInfo => 'booking@wonderingvietnam.com';

  @override
  String get general_workingHours => 'Working Hours';

  @override
  String get general_workingTime => 'From 8:00 AM - 10:00 PM';

  @override
  String get general_sendButton => 'Send';

  @override
  String get general_copyright => 'Copyright © 2025 All Rights Reserved';

  @override
  String get general_visaPayment => 'VISA';

  @override
  String get general_coFounder => 'Co Founder';

  @override
  String get general_readMore => 'Read More';

  @override
  String get general_allReviews => 'All Reviews';

  @override
  String get general_anonymousCustomer => 'Anonymous Customer';

  @override
  String get general_selectTicket => 'Select Ticket';

  @override
  String get general_lowestPrice => 'Lowest Price';

  @override
  String get general_bookingButton => 'BOOK TICKET';

  @override
  String get general_changeButton => 'Change';

  @override
  String get general_consultationButton => 'GET CONSULTATION';

  @override
  String get general_detailButton => 'Details';

  @override
  String get general_passengerLabel => 'Passengers & Class';

  @override
  String get general_totalPassengers => 'Passengers';

  @override
  String get general_coFounderName => 'Tieu Quynh';

  @override
  String get general_coFounderRole => 'Co Founder';

  @override
  String get general_viewAllTours => 'VIEW ALL';

  @override
  String get general_close => 'Close';

  @override
  String get general_select => 'Select';

  @override
  String get general_reviews => 'Reviews';

  @override
  String get error_title => 'An error occurred';

  @override
  String get error_noDataFound => 'No data found.';

  @override
  String get error_retryButton => 'Retry';

  @override
  String get error_loadingData => 'Loading data...';

  @override
  String get error_dataLoadingFailed => 'Failed to load data: ';

  @override
  String get error_tourListLoadingFailed => 'Tour List loading failed: ';

  @override
  String get error_categoryLoadingFailed => 'Category loading failed: ';

  @override
  String get error_flightDataLoadingFailed => 'Failed to load flight data: ';

  @override
  String get error_flightSearchMissingInput =>
      'Please enter both departure and destination points.';

  @override
  String get error_flightSearchConnectionFailed =>
      'A connection error occurred: ';

  @override
  String get error_tourNotFound => 'No matching tours found.';

  @override
  String get error_image_load => 'Image failed to load';

  @override
  String get error_airportDataLoadingFailed => 'Failed to load airport data: ';

  @override
  String get error_flight_date_invalid =>
      'Return date must be after departure date.';

  @override
  String get error_flight_seat_not_implemented =>
      'Seat code search feature is not yet implemented.';

  @override
  String get error_flightOutboundDataLoadingFailed =>
      'Flight outbound loading failed!!!';

  @override
  String get error_flightReturnDataLoadingFailed =>
      'Flight return loading failed!!!';

  @override
  String get tab_search => 'Search';

  @override
  String get tab_cancel => 'Cancel';

  @override
  String get tab_itinerary => 'Itinerary';

  @override
  String get tab_tour => 'Tour';

  @override
  String get tab_flight => 'Flight';

  @override
  String get tab_train => 'Train';

  @override
  String get tab_checkSchedule => 'Check Schedule';

  @override
  String get search_loading => 'Searching...';

  @override
  String get policy_loadDataFailed => 'Load data failed:';

  @override
  String get policy_detail => 'Detail policy';

  @override
  String get policy_loadDataPolicyFailed => 'Load data policy failed';

  @override
  String get policy_loadDetailPolicyFailed => 'Load detail policy failed:';

  @override
  String policy_searchCodeArticleCode(Object postId) {
    return 'Search code article failed $postId.';
  }

  @override
  String train_directOfMove(
    Object arrivalStation,
    Object departureStation,
    Object trainCompany,
  ) {
    return 'Selected: $trainCompany ($departureStation → $arrivalStation)';
  }

  @override
  String get tour_detail_read_all_reviews => 'Read all reviews';

  @override
  String get tour_detail_based_on => 'Based on';

  @override
  String get tour_detail_reviews_count => 'reviews';

  @override
  String get tour_detail_no_images => 'No images available';

  @override
  String get tour_detail_itinerary => 'Itinerary';

  @override
  String get tour_detail_highlights => 'Highlights';

  @override
  String get tour_detail_featured_sub => 'For you';

  @override
  String get tour_detail_featured_main => 'Featured Tours';

  @override
  String get tour_detail_no_tours => 'No suitable tours found.';

  @override
  String get tour_detail_prev => 'Prev';

  @override
  String get tour_detail_next => 'Next';

  @override
  String tour_detail_page_info(Object current, Object total) {
    return 'Page $current / $total';
  }

  @override
  String get reviews_all_title => 'All Reviews';

  @override
  String get reviews_summary => 'Review Overview';

  @override
  String get reviews_filter_all => 'All';

  @override
  String reviews_filter_star(Object count) {
    return ' stars ($count)';
  }

  @override
  String get menu_homeTitle => 'HOME';

  @override
  String get menu_tourTitle => 'TOUR';

  @override
  String get menu_flightTitle => 'FLIGHT TICKET';

  @override
  String get menu_trainTitle => 'TRAIN TICKET';

  @override
  String get menu_blogTitle => 'BLOG';

  @override
  String get menu_bookNowButton => 'BOOK NOW';

  @override
  String get menu_navigatingToBook => 'Navigating to Book Now page...';

  @override
  String get menu_tabTour => 'Tour';

  @override
  String get menu_tabFlight => 'Flight';

  @override
  String get menu_tabTrain => 'Train';

  @override
  String get form_defaultDestination => 'Destination';

  @override
  String get form_defaultDeparture => 'Ha Noi';

  @override
  String get form_defaultReturnDate => 'Not selected';

  @override
  String get form_defaultClass => 'Economy';

  @override
  String get form_classPremiumEconomy => 'Premium Economy';

  @override
  String get form_classBusiness => 'Business';

  @override
  String get form_classFirst => 'First Class';

  @override
  String get form_searchTourButton => 'Search Tour';

  @override
  String get form_searchFlightButton => 'Search Flight';

  @override
  String get form_searchTrainButton => 'Search Train';

  @override
  String get form_confirmButton => 'Confirm';

  @override
  String get form_tripRoundTrip => 'Round Trip';

  @override
  String get form_tripOneWay => 'One Way';

  @override
  String get form_labelDestination => 'Destination';

  @override
  String get form_labelDepartureDate => 'Departure Date';

  @override
  String get form_labelDeparturePlace => 'Departure Place';

  @override
  String get form_labelFlightWhereGo => 'Where do you want to go?';

  @override
  String get form_labelFlightWhereArrive => 'Arrive ?';

  @override
  String get form_labelFlightDeparture => 'Departing From';

  @override
  String get form_labelFlightArrival => 'Arriving At';

  @override
  String get form_labelFlightReturnDate => 'Return Date';

  @override
  String get form_labelTrainDeparture => 'Departing from Station';

  @override
  String get form_labelTrainArrival => 'Arriving at Station';

  @override
  String get form_labelTrainWhereArrive => 'Train arrive?';

  @override
  String get form_labelSearchHint => 'Search...';

  @override
  String get form_labelAdult => 'Adult';

  @override
  String get form_labelAdultSubtitle => '11+ years old';

  @override
  String get form_labelChild => 'Child';

  @override
  String get form_labelChildSubtitle => '2 - 11 years old';

  @override
  String get form_labelInfant => 'Infant';

  @override
  String get form_labelInfantSubtitle => 'Under 2 years old (Lap)';

  @override
  String get form_labelTicketClass => 'Ticket Class';

  @override
  String get form_modalSelectDestination => 'Select Destination';

  @override
  String get form_modalSelectAirportDeparture => 'Select Departure Airport';

  @override
  String get form_modalSelectAirportArrival => 'Select Arrival Airport';

  @override
  String get form_modalSelectStationDeparture => 'Select Departure Station';

  @override
  String get form_modalSelectStationArrival => 'Select Arrival Station';

  @override
  String get form_modalPassengerTitle => 'Passengers & Class';

  @override
  String get form_modalSearchLocationHint => 'Search location...';

  @override
  String get form_selectDestinationHint => 'Select Destination';

  @override
  String get flight_screen_header_title => 'Find Your Perfect Flight';

  @override
  String get flight_screen_service_title =>
      'Elevate Your Experience with\n Extra Amenities';

  @override
  String get flight_screen_top_destinations => 'Top International Destinations';

  @override
  String get flight_feature_luggage_title => 'Free 7kg Carry-on Baggage';

  @override
  String get flight_feature_luggage_sub =>
      'Carry up to 7kg of hand luggage \n free of charge.';

  @override
  String get flight_feature_online_checkin_title => 'Online Check-in Available';

  @override
  String get flight_feature_online_checkin_sub =>
      'Easy online check-in in just a few steps, \n saving you time.';

  @override
  String get flight_feature_checkin_available_title => 'Check-in Open Early';

  @override
  String get flight_feature_checkin_available_sub =>
      'Check-in starts 180 minutes \n before departure.';

  @override
  String get flight_error_fill_info =>
      'Please provide Departure, Destination, and Departure Date.';

  @override
  String get flight_error_return_date =>
      'Return date must be after departure date.';

  @override
  String get flight_error_empty_seat_code =>
      'Booking code and Email cannot be empty.';

  @override
  String get flight_label_only_from => 'Only from';

  @override
  String get flight_results_outbound => 'Outbound';

  @override
  String get flight_results_return => 'Return';

  @override
  String flight_results_selected_outbound(Object flightCode, Object time) {
    return 'Selected outbound: $flightCode - $time';
  }

  @override
  String flight_results_found_count(Object count) {
    return '$count results found';
  }

  @override
  String flight_results_selecting_return(Object code) {
    return 'Outbound $code selected. Loading return flights...';
  }

  @override
  String flight_results_selected_final(
    Object code,
    Object seatClass,
    Object type,
  ) {
    return 'Selected $type flight $code, Class: $seatClass';
  }

  @override
  String flight_results_duration_min(Object minutes) {
    return '$minutes mins';
  }

  @override
  String flight_results_duration_hour(Object hours, Object minutes) {
    return '${hours}h ${minutes}m';
  }

  @override
  String get flight_returnDate => 'Return date';

  @override
  String get flight_arrivalToWhichAirport =>
      'Which airport are you arriving at?';

  @override
  String get flight_arrivalAtTheAirport => 'Arrive at the airport';

  @override
  String get flight_bookingCode => 'Booking code';

  @override
  String get flight_seatCode => 'Seat code';

  @override
  String get flight_enterYourBookingCode => 'Enter your booking code';

  @override
  String get flight_enterYourSeatCode => 'Enter your seat code';

  @override
  String get flight_enterYourEmail => 'Enter your email';

  @override
  String get flight_viewLatestDeals => 'View the latest departure deals';

  @override
  String get flight_noFlightsFound => 'No suitable flights were found.';

  @override
  String get flight_from => 'From ';

  @override
  String get flight_to => ' to ';

  @override
  String get flight_extraServices => 'Additional services';

  @override
  String get flight_searchNameOrCodeAirport =>
      'Search name or code airport ...';

  @override
  String flight_resultFlightDate(Object date) {
    return 'Date: $date';
  }

  @override
  String get flight_stopNo => 'stop no';

  @override
  String get flight_directFlight => 'Direct flight';

  @override
  String get flight_selectReturnTicket => 'Select return ticket';

  @override
  String get flight_selectOutboundTicket => 'Select outbound ticket';

  @override
  String get flight_shrink => 'Shrink';

  @override
  String get flight_readDetailPolicyTicket => 'Read detail policy ticket';

  @override
  String get flight_luggage => 'Luggage';

  @override
  String get flight_change => 'Change';

  @override
  String get flight_returnTicket => 'Return ticket';

  @override
  String get flight_selectReturnFlight => 'Select return flight';

  @override
  String get form_consultation_departure_date => 'Departure Date';

  @override
  String get form_consultation_departure_point => 'Departure Point';

  @override
  String get form_consultation_name_label => 'Full Name';

  @override
  String get form_consultation_name_hint => 'Enter full name';

  @override
  String get form_consultation_phone_label => 'Phone Number';

  @override
  String get form_consultation_phone_hint => 'Enter phone number';

  @override
  String get form_consultation_email_label => 'Email';

  @override
  String get form_consultation_email_hint => 'Enter Email';

  @override
  String get form_consultation_note_label => 'Special Requests';

  @override
  String get form_consultation_note_hint => 'Additional notes (if any)';

  @override
  String get form_consultation_policy_cancel => 'Cancellation Policy';

  @override
  String get form_consultation_view_detail => 'View details.';

  @override
  String get form_consultation_book_now_pay_later => 'Book now and pay later';

  @override
  String get form_consultation_flexible_desc =>
      ' - Secure your spot while staying flexible.';

  @override
  String get form_consultation_submit_button => 'GET CONSULTATION';

  @override
  String get form_consultation_submitting_snackbar =>
      'Sending consultation request...';

  @override
  String form_consultation_success_msg(Object message) {
    return 'Success: $message';
  }

  @override
  String form_consultation_validation_error(Object error) {
    return 'Validation error: $error';
  }

  @override
  String form_consultation_required_error(Object field) {
    return 'Please enter $field';
  }

  @override
  String get form_consultation_app_title_mock => 'Flight Results';

  @override
  String get header_titleLine1 => 'Make every trip a';

  @override
  String get header_titleLine2 => 'delightful experience';

  @override
  String get home_tourSectionTitleVibes => 'For You';

  @override
  String get home_tourSectionTitleFeatured => 'Featured Tours';

  @override
  String get home_tourSectionTitleSearch => 'Tours to';

  @override
  String get home_tourSearchSnackbar => 'Showing Featured Tours.';

  @override
  String get home_destinationSnackbar => 'Selected:';

  @override
  String get home_promotionSectionVibes => 'Offers';

  @override
  String get home_promotionSectionTitle => 'For You';

  @override
  String get home_promotionSnackbar => 'You selected the offer:';

  @override
  String get home_destinationsTitle => '🔥 Tour Categories';

  @override
  String get home_aboutUsVibes => 'Introduction';

  @override
  String get home_aboutUsTitleLine1 => 'Welcome to';

  @override
  String get home_aboutUsTitleLine2 => 'Wondering Vietnam';

  @override
  String get home_aboutUsDescription =>
      'Wondering operates in the fields of tourism, flight tickets, and event organization in Vietnam. We always provide meticulous and dedicated services with the desire that \"every trip is a worthwhile experience story\". Our staff constantly strives to improve expertise and service quality.';

  @override
  String get home_aboutUsGuideTitle => 'Guide';

  @override
  String get home_aboutUsGuideSubtitle =>
      'Connecting services across the country and internationally';

  @override
  String get home_aboutUsMissionTitle => 'Vision & Mission';

  @override
  String get home_aboutUsMissionSubtitle =>
      'Enhancing worthwhile travel experiences.';

  @override
  String get home_exploreButton => 'Start Exploring';

  @override
  String get home_exploreSnackbar => 'Starting exploration...';

  @override
  String get home_trainSearchSnackbar => 'Searching... (\$text)';

  @override
  String get footer_contact => 'Contact';

  @override
  String get footer_introduce => 'About Us';

  @override
  String get footer_socialMediaConnect => 'Connect';

  @override
  String get footer_informationTitle => 'Information';

  @override
  String get footer_newsTitle => 'News';

  @override
  String get footer_cancellationPolicy => 'Cancellation Policy';

  @override
  String get footer_guideTitle => 'Guide';

  @override
  String get footer_registerOffer => 'Register for Offers';

  @override
  String get footer_policyFlight => 'Flight Ticket';

  @override
  String get footer_policyTour => 'Tour';

  @override
  String get footer_policyTrain => 'Train Ticket';

  @override
  String get footer_policyCruise => 'Cruise';

  @override
  String get footer_introDescription =>
      'Wondering Vietnam specializes in providing and consulting services for domestic and international tours in Vietnam.';

  @override
  String get footer_addressDetail =>
      'Address: SH0212P1, Park 1 Tower, Vinhomes TimesCity Park Hill, 458 Minh Khai, Vinh Tuy, Hanoi';

  @override
  String get footer_contactDetail =>
      'Hotline/Zalo: +84 90 111 81 85 / +84 76 979 8833';

  @override
  String get footer_emailDetail => 'Email: booking@wonderingvietnam.com';

  @override
  String get footer_emailTitle => 'Email';

  @override
  String get footer_registerOfferDescription =>
      'Leave your email to receive the earliest promotional information.';

  @override
  String get footer_emailSentSnackbar => 'Email registration for offers sent!';

  @override
  String get social_facebook => 'Facebook';

  @override
  String get social_instagram => 'Instagram';

  @override
  String get social_tiktok => 'Tiktok';

  @override
  String get social_whatsapp => 'WhatsApp';
}
