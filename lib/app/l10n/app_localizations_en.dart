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
  String get general_passengerLabel => 'Passengers';

  @override
  String get general_totalPassengers => 'Passengers';

  @override
  String get general_coFounderName => 'Thuong Nguyen';

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
  String get rating_great => 'Great';

  @override
  String get rating_good => 'Good';

  @override
  String get rating_fine => 'Fine';

  @override
  String get rating_bad => 'Bad';

  @override
  String get rating_terrible => 'Terrible';

  @override
  String get sort_highestRating => 'Highest rating';

  @override
  String get sort_priceHighToLow => 'Price high to low';

  @override
  String get sort_priveLowToHigh => 'Price low to high';

  @override
  String get sort_durationShortToLong => 'Tour duration (Short to long)';

  @override
  String get sort_durationLongToShort => 'Tour duration (Long to short)';

  @override
  String get filter => 'Filter';

  @override
  String get sort => 'Sort';

  @override
  String get review => 'Review';

  @override
  String get type => 'Type';

  @override
  String get apply => 'Apply';

  @override
  String get tour_screenTourTitle => 'Tour';

  @override
  String get consultation_faqs => 'Frequently asked questions';

  @override
  String get faqs_answerLoading => 'Answers loading....';

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
  String no_review(Object selectedRating) {
    return 'There are no star ratings for $selectedRating';
  }

  @override
  String get tour_detail_tab_intro => 'Introduce';

  @override
  String get tour_detail_tab_schedule => 'Schedule';

  @override
  String get tour_detail_tab_review => 'Review';

  @override
  String get tour_detail_tab_question => 'Question';

  @override
  String get tour_detail_you_should_consult => 'You should consult';

  @override
  String get menu_homeTitle => 'HOME';

  @override
  String get menu_tourTitle => 'TOUR';

  @override
  String get menu_flightTitle => 'PLANE TICKET';

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
  String get form_modalPassengerTitle => 'Passengers';

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
  String get flight_viewLatestDeals => 'View the latest\ndeparture deals';

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
  String get flight_selectReturnTicket => 'Select';

  @override
  String get flight_selectOutboundTicket => 'Select';

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
  String flight_from_to(Object departure, Object destination) {
    return 'Flight from $departure to $destination';
  }

  @override
  String get selectSeatClass => 'Select seat class';

  @override
  String get flightDetails => 'Details';

  @override
  String get currentlySelected => 'Selected';

  @override
  String get selectThisJourney => 'Select';

  @override
  String get viewDetails => 'Details';

  @override
  String get departureDetails => '1. Departure details';

  @override
  String get returnDetails => '2. Arrive details';

  @override
  String stops(Object count) {
    return '$count stop';
  }

  @override
  String stopAt(Object city, Object duration) {
    return 'Stop at $city: $duration';
  }

  @override
  String get policy_carryOnBaggage => 'Carry-on baggage';

  @override
  String get policy_changeFlight => 'Flight change';

  @override
  String get policy_refund => 'Refund';

  @override
  String flight_fareAndCode(Object fareType, Object flightCode) {
    return '$fareType • Flight $flightCode';
  }

  @override
  String get text_btnContinue => 'Continue';

  @override
  String get text_change_btn => 'Change';

  @override
  String get selected_international_pair_ticket =>
      'Selected international pair ticket';

  @override
  String get selected_departure_flight_ticket =>
      'Selected departure flight ticket';

  @override
  String get selected_arrival_flight_ticket => 'Selected arrival flight ticket';

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
  String get home_destinationsTitle => 'Tour Categories';

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

  @override
  String get tipEnterNameTitle => 'Tips for Entering Your Name Correctly';

  @override
  String get tipEnterNameDesc =>
      'Enter your personal information exactly as it appears on the data page of your passport or ID card. All names must contain only standard English alphabetical characters (A to Z), with a maximum of 35 characters for your full name.';

  @override
  String get checkInfoTitle => 'Review and Verify Your Information';

  @override
  String get checkInfoDesc =>
      'During the booking process, you might accidentally change information or miss important notes.\n\nTherefore, once you have filled in all the required details, do not click the \"Continue\" button immediately. Always double-check the information you have entered.';

  @override
  String get wrongNameTitle => 'Incorrect Name on Flight Ticket';

  @override
  String get wrongNameDesc =>
      'If the personal information on your ticket does not match your passport or ID card, the airline reserves the right to deny you boarding. In this case, you will have to undergo an official name change process or purchase a new ticket.';

  @override
  String get understand => 'I Understand';

  @override
  String get titleSalutation => 'Select Title';

  @override
  String get titleFirstName => 'First / Middle Name';

  @override
  String get titleLastName => 'Last Name / Surname';

  @override
  String get salutationMr => 'Mr.';

  @override
  String get tip1Title => 'First/Middle or Last Name with a single letter';

  @override
  String get tip1Desc =>
      'If your first, middle, or last name contains only a single letter, please repeat that letter in the corresponding name field.';

  @override
  String get tip1Ex => 'Example name on passport: D Jonson';

  @override
  String get tip2Title => 'Names with special characters';

  @override
  String get tip2Desc =>
      'If your name is hyphenated or contains special characters such as apostrophes or accents, please remove them when entering your name.';

  @override
  String get tip2Ex => 'Example: Name on passport: John-Adam Smith';

  @override
  String get tip3Title => 'Single name in passport';

  @override
  String get tip3Desc =>
      'If you only have one name in your passport (regardless of whether it\'s a first, middle, or last name), please enter your name in the \"Last Name\" field and check the box \"This passenger does not have a first name in their passport\".';

  @override
  String get tip3Ex => 'Example: Name on passport: Thomas';

  @override
  String get tip4Title => 'Names with suffixes';

  @override
  String get tip4Desc =>
      'If your name includes a suffix, please enter the first name and suffix together in the \"First / Middle Name\" field.';

  @override
  String get tip4Ex => 'Example: Name on passport: William Smith Jr';

  @override
  String get train_headerTitle => 'Search for your trip';

  @override
  String get train_form_label_departure => 'Departure from';

  @override
  String get train_form_label_arrive => 'Arrive at';

  @override
  String get train_form_departure_date => 'Departure date';

  @override
  String get train_form_return_date => 'Arrive date';

  @override
  String get trip_information => 'Trip Information';

  @override
  String get itinerary => 'Itinerary';

  @override
  String get departure => 'DEPARTURE';

  @override
  String get return_trip => 'RETURN';

  @override
  String get to => 'to';

  @override
  String get enter_passenger_info => 'Enter Passenger Information';

  @override
  String get personal_info => 'Personal Information';

  @override
  String get passenger_name_note =>
      '* Please ensure you enter the name as it appears on the passport. Maximum 32 characters.';

  @override
  String get adult => 'Adult';

  @override
  String get child => 'Child';

  @override
  String get infant => 'Infant';

  @override
  String get contact_info => 'Contact Information';

  @override
  String get contact_note =>
      '* Please provide contact details to receive itinerary notifications.';

  @override
  String get country_code => 'Country Code';

  @override
  String get phone_number => 'Phone Number';

  @override
  String get email => 'Email';

  @override
  String get special_request => 'Special Request';

  @override
  String get request_content => 'Content';

  @override
  String get select_title => 'Select Title';

  @override
  String get mr => 'Mr.';

  @override
  String get mrs => 'Mrs.';

  @override
  String get ms => 'Ms.';

  @override
  String get first_middle_name => 'First & Middle Name';

  @override
  String get last_name => 'Last Name';

  @override
  String get passport_number => 'Passport Number';

  @override
  String get birthday => 'Date of Birth';

  @override
  String get continue_button => 'Continue';

  @override
  String get search => 'Search...';

  @override
  String get select => 'Select';

  @override
  String get tip_enter_name => 'Name tips';

  @override
  String get salutation => 'Title';

  @override
  String get select_salutation => 'Select title';

  @override
  String get last_name_passport => 'Last name (as on passport)';

  @override
  String get first_middle_name_passport =>
      'First & Middle name (as on passport)';

  @override
  String get example_last_name => 'e.g., NGUYEN';

  @override
  String get example_first_middle_name => 'e.g., VAN AN';

  @override
  String get accompanying_adult => 'Accompanying adult';

  @override
  String get select_accompanying_adult => 'Select accompanying adult';

  @override
  String get frequent_flyer_card => 'Frequent Flyer Card';

  @override
  String get airline => 'Airline';

  @override
  String get select_airline => 'Select airline';

  @override
  String get card_number => 'Card number';

  @override
  String get enter_card_number => 'Enter card number';

  @override
  String get titles => 'Mr,Mrs,Ms,Mr,Ms';

  @override
  String get airlines => 'Airlines';

  @override
  String get stop => 'Stops';

  @override
  String get departure_time => 'Departure Time';

  @override
  String get direct_flight => 'Direct';

  @override
  String get one_stop => '1 Stop';

  @override
  String get two_stops => '2 Stops';

  @override
  String get time_early => 'Early (0 AM - 5:59 AM)';

  @override
  String get time_morning => 'Morning (6 AM - 11:59 AM)';

  @override
  String get time_afternoon => 'Afternoon (12 PM - 5:59 PM)';

  @override
  String get time_evening => 'Evening (6 PM - 11:59 PM)';

  @override
  String get no_flights_found => 'No flights found';

  @override
  String get change_filter_instruction =>
      'Please try changing your selection or filters.';

  @override
  String get noSeatClassAvailable => 'No seat class available';

  @override
  String get understood => 'Understood';

  @override
  String get arrivalTime => 'Arrival time';

  @override
  String get vip_seat_explanation_title => 'VIP Seat Class Explanation';

  @override
  String get vip_seat_intro =>
      'VIP seat classes include: 2 Berth, King Size, and Queen Size. Below are the rules and conditions for each seat type:';

  @override
  String get vip_2_berth_title => 'VIP 2 Berth:';

  @override
  String get vip_2_berth_desc =>
      'Pricing is for the VIP 2 Berth cabin. Passengers will be charged for the full cabin even if traveling alone. This ensures the privacy and comfort of the cabin environment.';

  @override
  String get queen_size_title => 'Queen Size:';

  @override
  String get queen_size_desc =>
      'Queen Size seats offer a balance of comfort and space. Similar to King Size, solo travelers will be charged full price for the entire cabin.';

  @override
  String get king_size_title => 'King Size:';

  @override
  String get king_size_desc =>
      'King Size seats are designed for those desiring more space and comfort. If traveling alone, full fees for the King Size cabin apply, as cabins are sold as a whole.';

  @override
  String get note_title => 'Note:';

  @override
  String get note_desc =>
      'When booking, please note that if traveling alone, you will still be charged full fees for the entire cabin in these seat classes. This applies regardless of whether you are a solo traveler or part of a group (1, 3, 5, or 7 passengers), as cabins are sold as a whole rather than by individual seats.';

  @override
  String get loading_data => 'Loading data...';

  @override
  String get no_trains_found => 'No suitable trains found';

  @override
  String selected_trip_from_to(Object dep, Object dest) {
    return 'Selected trip from $dep to $dest';
  }

  @override
  String select_trip_from(Object station) {
    return 'Select trip from $station';
  }

  @override
  String get from_price => 'From';

  @override
  String get one_way => 'One way';

  @override
  String get view_details_short => 'Details';

  @override
  String station_with_name(Object name) {
    return '$name Station';
  }

  @override
  String get device => 'Device:';

  @override
  String get carrier => 'Carrier:';

  @override
  String get distance => 'Distance:';

  @override
  String get duration_label => 'Duration:';

  @override
  String get seat_class_default => 'Seat Class';

  @override
  String get select_seat_class_hint => 'Select seat class';

  @override
  String get best_seller => 'Best Seller';

  @override
  String get tour_activities => 'Tour & Activities';

  @override
  String get best_hotel => 'Best Hotel';

  @override
  String get favorite_destinations => 'Favorite Destinations';

  @override
  String get cheap_trips_offers => 'Special Trip Offers';

  @override
  String get login => 'Login';

  @override
  String get passWord => 'Password';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get noAccountYet => 'No account yet?';

  @override
  String get createAccount => 'Create account';

  @override
  String get yourAccount => 'Your account';

  @override
  String get register => 'Register';

  @override
  String get fullName => 'Full name';

  @override
  String get yourPhoneNumber => 'Your phone number';

  @override
  String get confirmPassword => 'Confirm password';

  @override
  String get success => 'Success';

  @override
  String get fail => 'Fail';

  @override
  String get alreadyAccount => 'Already account?';

  @override
  String get agree => 'Agree';

  @override
  String get faq_q1 =>
      'If the tour is canceled due to objective reasons (weather, natural disaster, national mourning, etc.), will I get a refund?';

  @override
  String get faq_a1 =>
      'In case of force majeure (natural disasters, epidemics, etc.), the company will provide a refund but may deduct expenses already paid to partners (hotels, airlines, etc.) that are non-refundable. Certain services depend on the specific refund/cancellation/change policies of the providers. If the cancellation is due to the company\'s fault, you will receive a 100% refund or be offered an alternative tour as requested.';

  @override
  String get faq_q2 => 'What are the available payment methods?';

  @override
  String get faq_a2 =>
      'Wondering Vietnam provides the following deposit/payment methods:<br><ul><li>Direct payment at the Wondering Vietnam Office</li><li>Online bank transfer (E-banking)</li></ul>';

  @override
  String get faq_q3 => 'Is my personal information kept private?';

  @override
  String get faq_a3 =>
      'Wondering Vietnam commits to not disclosing any of your information to third parties, except for necessary details provided to hotel partners for mandatory local residence registration as required by local authorities.';

  @override
  String get faq_q4 =>
      'Can I make special requests regarding accommodation, meals, etc.?';

  @override
  String get faq_a4 =>
      'You can contact us directly or fill in the \'Other Requests\' section when booking your tour.';

  @override
  String get faq_q5 => 'Can I request a VAT invoice?';

  @override
  String get faq_a5 =>
      'Wondering Vietnam will issue VAT invoices in accordance with the regulations of the Ministry of Finance.';

  @override
  String get errorDepartureEmpty => 'Please select a departure point !!!';

  @override
  String get errorDestinationEmpty => 'Please select a destination !!!';

  @override
  String get errorSameLocation =>
      'Departure and destination cannot be the same !!!';

  @override
  String get errorReturnDateEmpty => 'Please select a return date !!!';

  @override
  String get errorReturnBeforeDeparture =>
      'Return date cannot be before departure date !!!';

  @override
  String get errorSameDate =>
      'Departure and return dates cannot be the same !!!';
}
