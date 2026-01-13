import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Final Project'**
  String get appName;

  /// No description provided for @general_hotline.
  ///
  /// In en, this message translates to:
  /// **'Hotline'**
  String get general_hotline;

  /// No description provided for @general_hotlineNumber.
  ///
  /// In en, this message translates to:
  /// **'+84 90 111 81 85'**
  String get general_hotlineNumber;

  /// No description provided for @general_emailInfo.
  ///
  /// In en, this message translates to:
  /// **'booking@wonderingvietnam.com'**
  String get general_emailInfo;

  /// No description provided for @general_workingHours.
  ///
  /// In en, this message translates to:
  /// **'Working Hours'**
  String get general_workingHours;

  /// No description provided for @general_workingTime.
  ///
  /// In en, this message translates to:
  /// **'From 8:00 AM - 10:00 PM'**
  String get general_workingTime;

  /// No description provided for @general_sendButton.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get general_sendButton;

  /// No description provided for @general_copyright.
  ///
  /// In en, this message translates to:
  /// **'Copyright © 2025 All Rights Reserved'**
  String get general_copyright;

  /// No description provided for @general_visaPayment.
  ///
  /// In en, this message translates to:
  /// **'VISA'**
  String get general_visaPayment;

  /// No description provided for @general_coFounder.
  ///
  /// In en, this message translates to:
  /// **'Co Founder'**
  String get general_coFounder;

  /// No description provided for @general_readMore.
  ///
  /// In en, this message translates to:
  /// **'Read More'**
  String get general_readMore;

  /// No description provided for @general_allReviews.
  ///
  /// In en, this message translates to:
  /// **'All Reviews'**
  String get general_allReviews;

  /// No description provided for @general_anonymousCustomer.
  ///
  /// In en, this message translates to:
  /// **'Anonymous Customer'**
  String get general_anonymousCustomer;

  /// No description provided for @general_selectTicket.
  ///
  /// In en, this message translates to:
  /// **'Select Ticket'**
  String get general_selectTicket;

  /// No description provided for @general_lowestPrice.
  ///
  /// In en, this message translates to:
  /// **'Lowest Price'**
  String get general_lowestPrice;

  /// No description provided for @general_bookingButton.
  ///
  /// In en, this message translates to:
  /// **'BOOK TICKET'**
  String get general_bookingButton;

  /// No description provided for @general_changeButton.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get general_changeButton;

  /// No description provided for @general_consultationButton.
  ///
  /// In en, this message translates to:
  /// **'GET CONSULTATION'**
  String get general_consultationButton;

  /// No description provided for @general_detailButton.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get general_detailButton;

  /// No description provided for @general_passengerLabel.
  ///
  /// In en, this message translates to:
  /// **'Passengers & Class'**
  String get general_passengerLabel;

  /// No description provided for @general_totalPassengers.
  ///
  /// In en, this message translates to:
  /// **'Passengers'**
  String get general_totalPassengers;

  /// No description provided for @general_coFounderName.
  ///
  /// In en, this message translates to:
  /// **'Tieu Quynh'**
  String get general_coFounderName;

  /// No description provided for @general_coFounderRole.
  ///
  /// In en, this message translates to:
  /// **'Co Founder'**
  String get general_coFounderRole;

  /// No description provided for @general_viewAllTours.
  ///
  /// In en, this message translates to:
  /// **'VIEW ALL'**
  String get general_viewAllTours;

  /// No description provided for @general_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get general_close;

  /// No description provided for @general_select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get general_select;

  /// No description provided for @general_reviews.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get general_reviews;

  /// No description provided for @error_title.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error_title;

  /// No description provided for @error_noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found.'**
  String get error_noDataFound;

  /// No description provided for @error_retryButton.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get error_retryButton;

  /// No description provided for @error_loadingData.
  ///
  /// In en, this message translates to:
  /// **'Loading data...'**
  String get error_loadingData;

  /// No description provided for @error_dataLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load data: '**
  String get error_dataLoadingFailed;

  /// No description provided for @error_tourListLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Tour List loading failed: '**
  String get error_tourListLoadingFailed;

  /// No description provided for @error_categoryLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Category loading failed: '**
  String get error_categoryLoadingFailed;

  /// No description provided for @error_flightDataLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load flight data: '**
  String get error_flightDataLoadingFailed;

  /// No description provided for @error_flightSearchMissingInput.
  ///
  /// In en, this message translates to:
  /// **'Please enter both departure and destination points.'**
  String get error_flightSearchMissingInput;

  /// No description provided for @error_flightSearchConnectionFailed.
  ///
  /// In en, this message translates to:
  /// **'A connection error occurred: '**
  String get error_flightSearchConnectionFailed;

  /// No description provided for @error_tourNotFound.
  ///
  /// In en, this message translates to:
  /// **'No matching tours found.'**
  String get error_tourNotFound;

  /// No description provided for @error_image_load.
  ///
  /// In en, this message translates to:
  /// **'Image failed to load'**
  String get error_image_load;

  /// No description provided for @error_airportDataLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to load airport data: '**
  String get error_airportDataLoadingFailed;

  /// No description provided for @error_flight_date_invalid.
  ///
  /// In en, this message translates to:
  /// **'Return date must be after departure date.'**
  String get error_flight_date_invalid;

  /// No description provided for @error_flight_seat_not_implemented.
  ///
  /// In en, this message translates to:
  /// **'Seat code search feature is not yet implemented.'**
  String get error_flight_seat_not_implemented;

  /// No description provided for @error_flightOutboundDataLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Flight outbound loading failed!!!'**
  String get error_flightOutboundDataLoadingFailed;

  /// No description provided for @error_flightReturnDataLoadingFailed.
  ///
  /// In en, this message translates to:
  /// **'Flight return loading failed!!!'**
  String get error_flightReturnDataLoadingFailed;

  /// No description provided for @tab_search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get tab_search;

  /// No description provided for @tab_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get tab_cancel;

  /// No description provided for @tab_itinerary.
  ///
  /// In en, this message translates to:
  /// **'Itinerary'**
  String get tab_itinerary;

  /// No description provided for @tab_tour.
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get tab_tour;

  /// No description provided for @tab_flight.
  ///
  /// In en, this message translates to:
  /// **'Flight'**
  String get tab_flight;

  /// No description provided for @tab_train.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get tab_train;

  /// No description provided for @tab_checkSchedule.
  ///
  /// In en, this message translates to:
  /// **'Check Schedule'**
  String get tab_checkSchedule;

  /// No description provided for @search_loading.
  ///
  /// In en, this message translates to:
  /// **'Searching...'**
  String get search_loading;

  /// No description provided for @policy_loadDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Load data failed:'**
  String get policy_loadDataFailed;

  /// No description provided for @policy_detail.
  ///
  /// In en, this message translates to:
  /// **'Detail policy'**
  String get policy_detail;

  /// No description provided for @policy_loadDataPolicyFailed.
  ///
  /// In en, this message translates to:
  /// **'Load data policy failed'**
  String get policy_loadDataPolicyFailed;

  /// No description provided for @policy_loadDetailPolicyFailed.
  ///
  /// In en, this message translates to:
  /// **'Load detail policy failed:'**
  String get policy_loadDetailPolicyFailed;

  /// No description provided for @policy_searchCodeArticleCode.
  ///
  /// In en, this message translates to:
  /// **'Search code article failed {postId}.'**
  String policy_searchCodeArticleCode(Object postId);

  /// No description provided for @train_directOfMove.
  ///
  /// In en, this message translates to:
  /// **'Selected: {trainCompany} ({departureStation} → {arrivalStation})'**
  String train_directOfMove(
    Object arrivalStation,
    Object departureStation,
    Object trainCompany,
  );

  /// No description provided for @tour_detail_read_all_reviews.
  ///
  /// In en, this message translates to:
  /// **'Read all reviews'**
  String get tour_detail_read_all_reviews;

  /// No description provided for @tour_detail_based_on.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get tour_detail_based_on;

  /// No description provided for @tour_detail_reviews_count.
  ///
  /// In en, this message translates to:
  /// **'reviews'**
  String get tour_detail_reviews_count;

  /// No description provided for @tour_detail_no_images.
  ///
  /// In en, this message translates to:
  /// **'No images available'**
  String get tour_detail_no_images;

  /// No description provided for @tour_detail_itinerary.
  ///
  /// In en, this message translates to:
  /// **'Itinerary'**
  String get tour_detail_itinerary;

  /// No description provided for @tour_detail_highlights.
  ///
  /// In en, this message translates to:
  /// **'Highlights'**
  String get tour_detail_highlights;

  /// No description provided for @tour_detail_featured_sub.
  ///
  /// In en, this message translates to:
  /// **'For you'**
  String get tour_detail_featured_sub;

  /// No description provided for @tour_detail_featured_main.
  ///
  /// In en, this message translates to:
  /// **'Featured Tours'**
  String get tour_detail_featured_main;

  /// No description provided for @tour_detail_no_tours.
  ///
  /// In en, this message translates to:
  /// **'No suitable tours found.'**
  String get tour_detail_no_tours;

  /// No description provided for @tour_detail_prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get tour_detail_prev;

  /// No description provided for @tour_detail_next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get tour_detail_next;

  /// No description provided for @tour_detail_page_info.
  ///
  /// In en, this message translates to:
  /// **'Page {current} / {total}'**
  String tour_detail_page_info(Object current, Object total);

  /// No description provided for @reviews_all_title.
  ///
  /// In en, this message translates to:
  /// **'All Reviews'**
  String get reviews_all_title;

  /// No description provided for @reviews_summary.
  ///
  /// In en, this message translates to:
  /// **'Review Overview'**
  String get reviews_summary;

  /// No description provided for @reviews_filter_all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get reviews_filter_all;

  /// No description provided for @reviews_filter_star.
  ///
  /// In en, this message translates to:
  /// **' stars ({count})'**
  String reviews_filter_star(Object count);

  /// No description provided for @menu_homeTitle.
  ///
  /// In en, this message translates to:
  /// **'HOME'**
  String get menu_homeTitle;

  /// No description provided for @menu_tourTitle.
  ///
  /// In en, this message translates to:
  /// **'TOUR'**
  String get menu_tourTitle;

  /// No description provided for @menu_flightTitle.
  ///
  /// In en, this message translates to:
  /// **'FLIGHT TICKET'**
  String get menu_flightTitle;

  /// No description provided for @menu_trainTitle.
  ///
  /// In en, this message translates to:
  /// **'TRAIN TICKET'**
  String get menu_trainTitle;

  /// No description provided for @menu_blogTitle.
  ///
  /// In en, this message translates to:
  /// **'BLOG'**
  String get menu_blogTitle;

  /// No description provided for @menu_bookNowButton.
  ///
  /// In en, this message translates to:
  /// **'BOOK NOW'**
  String get menu_bookNowButton;

  /// No description provided for @menu_navigatingToBook.
  ///
  /// In en, this message translates to:
  /// **'Navigating to Book Now page...'**
  String get menu_navigatingToBook;

  /// No description provided for @menu_tabTour.
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get menu_tabTour;

  /// No description provided for @menu_tabFlight.
  ///
  /// In en, this message translates to:
  /// **'Flight'**
  String get menu_tabFlight;

  /// No description provided for @menu_tabTrain.
  ///
  /// In en, this message translates to:
  /// **'Train'**
  String get menu_tabTrain;

  /// No description provided for @form_defaultDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get form_defaultDestination;

  /// No description provided for @form_defaultDeparture.
  ///
  /// In en, this message translates to:
  /// **'Ha Noi'**
  String get form_defaultDeparture;

  /// No description provided for @form_defaultReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Not selected'**
  String get form_defaultReturnDate;

  /// No description provided for @form_defaultClass.
  ///
  /// In en, this message translates to:
  /// **'Economy'**
  String get form_defaultClass;

  /// No description provided for @form_classPremiumEconomy.
  ///
  /// In en, this message translates to:
  /// **'Premium Economy'**
  String get form_classPremiumEconomy;

  /// No description provided for @form_classBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get form_classBusiness;

  /// No description provided for @form_classFirst.
  ///
  /// In en, this message translates to:
  /// **'First Class'**
  String get form_classFirst;

  /// No description provided for @form_searchTourButton.
  ///
  /// In en, this message translates to:
  /// **'Search Tour'**
  String get form_searchTourButton;

  /// No description provided for @form_searchFlightButton.
  ///
  /// In en, this message translates to:
  /// **'Search Flight'**
  String get form_searchFlightButton;

  /// No description provided for @form_searchTrainButton.
  ///
  /// In en, this message translates to:
  /// **'Search Train'**
  String get form_searchTrainButton;

  /// No description provided for @form_confirmButton.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get form_confirmButton;

  /// No description provided for @form_tripRoundTrip.
  ///
  /// In en, this message translates to:
  /// **'Round Trip'**
  String get form_tripRoundTrip;

  /// No description provided for @form_tripOneWay.
  ///
  /// In en, this message translates to:
  /// **'One Way'**
  String get form_tripOneWay;

  /// No description provided for @form_labelDestination.
  ///
  /// In en, this message translates to:
  /// **'Destination'**
  String get form_labelDestination;

  /// No description provided for @form_labelDepartureDate.
  ///
  /// In en, this message translates to:
  /// **'Departure Date'**
  String get form_labelDepartureDate;

  /// No description provided for @form_labelDeparturePlace.
  ///
  /// In en, this message translates to:
  /// **'Departure Place'**
  String get form_labelDeparturePlace;

  /// No description provided for @form_labelFlightWhereGo.
  ///
  /// In en, this message translates to:
  /// **'Where do you want to go?'**
  String get form_labelFlightWhereGo;

  /// No description provided for @form_labelFlightWhereArrive.
  ///
  /// In en, this message translates to:
  /// **'Arrive ?'**
  String get form_labelFlightWhereArrive;

  /// No description provided for @form_labelFlightDeparture.
  ///
  /// In en, this message translates to:
  /// **'Departing From'**
  String get form_labelFlightDeparture;

  /// No description provided for @form_labelFlightArrival.
  ///
  /// In en, this message translates to:
  /// **'Arriving At'**
  String get form_labelFlightArrival;

  /// No description provided for @form_labelFlightReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Return Date'**
  String get form_labelFlightReturnDate;

  /// No description provided for @form_labelTrainDeparture.
  ///
  /// In en, this message translates to:
  /// **'Departing from Station'**
  String get form_labelTrainDeparture;

  /// No description provided for @form_labelTrainArrival.
  ///
  /// In en, this message translates to:
  /// **'Arriving at Station'**
  String get form_labelTrainArrival;

  /// No description provided for @form_labelTrainWhereArrive.
  ///
  /// In en, this message translates to:
  /// **'Train arrive?'**
  String get form_labelTrainWhereArrive;

  /// No description provided for @form_labelSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search...'**
  String get form_labelSearchHint;

  /// No description provided for @form_labelAdult.
  ///
  /// In en, this message translates to:
  /// **'Adult'**
  String get form_labelAdult;

  /// No description provided for @form_labelAdultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'11+ years old'**
  String get form_labelAdultSubtitle;

  /// No description provided for @form_labelChild.
  ///
  /// In en, this message translates to:
  /// **'Child'**
  String get form_labelChild;

  /// No description provided for @form_labelChildSubtitle.
  ///
  /// In en, this message translates to:
  /// **'2 - 11 years old'**
  String get form_labelChildSubtitle;

  /// No description provided for @form_labelInfant.
  ///
  /// In en, this message translates to:
  /// **'Infant'**
  String get form_labelInfant;

  /// No description provided for @form_labelInfantSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Under 2 years old (Lap)'**
  String get form_labelInfantSubtitle;

  /// No description provided for @form_labelTicketClass.
  ///
  /// In en, this message translates to:
  /// **'Ticket Class'**
  String get form_labelTicketClass;

  /// No description provided for @form_modalSelectDestination.
  ///
  /// In en, this message translates to:
  /// **'Select Destination'**
  String get form_modalSelectDestination;

  /// No description provided for @form_modalSelectAirportDeparture.
  ///
  /// In en, this message translates to:
  /// **'Select Departure Airport'**
  String get form_modalSelectAirportDeparture;

  /// No description provided for @form_modalSelectAirportArrival.
  ///
  /// In en, this message translates to:
  /// **'Select Arrival Airport'**
  String get form_modalSelectAirportArrival;

  /// No description provided for @form_modalSelectStationDeparture.
  ///
  /// In en, this message translates to:
  /// **'Select Departure Station'**
  String get form_modalSelectStationDeparture;

  /// No description provided for @form_modalSelectStationArrival.
  ///
  /// In en, this message translates to:
  /// **'Select Arrival Station'**
  String get form_modalSelectStationArrival;

  /// No description provided for @form_modalPassengerTitle.
  ///
  /// In en, this message translates to:
  /// **'Passengers & Class'**
  String get form_modalPassengerTitle;

  /// No description provided for @form_modalSearchLocationHint.
  ///
  /// In en, this message translates to:
  /// **'Search location...'**
  String get form_modalSearchLocationHint;

  /// No description provided for @form_selectDestinationHint.
  ///
  /// In en, this message translates to:
  /// **'Select Destination'**
  String get form_selectDestinationHint;

  /// No description provided for @flight_screen_header_title.
  ///
  /// In en, this message translates to:
  /// **'Find Your Perfect Flight'**
  String get flight_screen_header_title;

  /// No description provided for @flight_screen_service_title.
  ///
  /// In en, this message translates to:
  /// **'Elevate Your Experience with\n Extra Amenities'**
  String get flight_screen_service_title;

  /// No description provided for @flight_screen_top_destinations.
  ///
  /// In en, this message translates to:
  /// **'Top International Destinations'**
  String get flight_screen_top_destinations;

  /// No description provided for @flight_feature_luggage_title.
  ///
  /// In en, this message translates to:
  /// **'Free 7kg Carry-on Baggage'**
  String get flight_feature_luggage_title;

  /// No description provided for @flight_feature_luggage_sub.
  ///
  /// In en, this message translates to:
  /// **'Carry up to 7kg of hand luggage \n free of charge.'**
  String get flight_feature_luggage_sub;

  /// No description provided for @flight_feature_online_checkin_title.
  ///
  /// In en, this message translates to:
  /// **'Online Check-in Available'**
  String get flight_feature_online_checkin_title;

  /// No description provided for @flight_feature_online_checkin_sub.
  ///
  /// In en, this message translates to:
  /// **'Easy online check-in in just a few steps, \n saving you time.'**
  String get flight_feature_online_checkin_sub;

  /// No description provided for @flight_feature_checkin_available_title.
  ///
  /// In en, this message translates to:
  /// **'Check-in Open Early'**
  String get flight_feature_checkin_available_title;

  /// No description provided for @flight_feature_checkin_available_sub.
  ///
  /// In en, this message translates to:
  /// **'Check-in starts 180 minutes \n before departure.'**
  String get flight_feature_checkin_available_sub;

  /// No description provided for @flight_error_fill_info.
  ///
  /// In en, this message translates to:
  /// **'Please provide Departure, Destination, and Departure Date.'**
  String get flight_error_fill_info;

  /// No description provided for @flight_error_return_date.
  ///
  /// In en, this message translates to:
  /// **'Return date must be after departure date.'**
  String get flight_error_return_date;

  /// No description provided for @flight_error_empty_seat_code.
  ///
  /// In en, this message translates to:
  /// **'Booking code and Email cannot be empty.'**
  String get flight_error_empty_seat_code;

  /// No description provided for @flight_label_only_from.
  ///
  /// In en, this message translates to:
  /// **'Only from'**
  String get flight_label_only_from;

  /// No description provided for @flight_results_outbound.
  ///
  /// In en, this message translates to:
  /// **'Outbound'**
  String get flight_results_outbound;

  /// No description provided for @flight_results_return.
  ///
  /// In en, this message translates to:
  /// **'Return'**
  String get flight_results_return;

  /// No description provided for @flight_results_selected_outbound.
  ///
  /// In en, this message translates to:
  /// **'Selected outbound: {flightCode} - {time}'**
  String flight_results_selected_outbound(Object flightCode, Object time);

  /// No description provided for @flight_results_found_count.
  ///
  /// In en, this message translates to:
  /// **'{count} results found'**
  String flight_results_found_count(Object count);

  /// No description provided for @flight_results_selecting_return.
  ///
  /// In en, this message translates to:
  /// **'Outbound {code} selected. Loading return flights...'**
  String flight_results_selecting_return(Object code);

  /// No description provided for @flight_results_selected_final.
  ///
  /// In en, this message translates to:
  /// **'Selected {type} flight {code}, Class: {seatClass}'**
  String flight_results_selected_final(
    Object code,
    Object seatClass,
    Object type,
  );

  /// No description provided for @flight_results_duration_min.
  ///
  /// In en, this message translates to:
  /// **'{minutes} mins'**
  String flight_results_duration_min(Object minutes);

  /// No description provided for @flight_results_duration_hour.
  ///
  /// In en, this message translates to:
  /// **'{hours}h {minutes}m'**
  String flight_results_duration_hour(Object hours, Object minutes);

  /// No description provided for @flight_returnDate.
  ///
  /// In en, this message translates to:
  /// **'Return date'**
  String get flight_returnDate;

  /// No description provided for @flight_arrivalToWhichAirport.
  ///
  /// In en, this message translates to:
  /// **'Which airport are you arriving at?'**
  String get flight_arrivalToWhichAirport;

  /// No description provided for @flight_arrivalAtTheAirport.
  ///
  /// In en, this message translates to:
  /// **'Arrive at the airport'**
  String get flight_arrivalAtTheAirport;

  /// No description provided for @flight_bookingCode.
  ///
  /// In en, this message translates to:
  /// **'Booking code'**
  String get flight_bookingCode;

  /// No description provided for @flight_seatCode.
  ///
  /// In en, this message translates to:
  /// **'Seat code'**
  String get flight_seatCode;

  /// No description provided for @flight_enterYourBookingCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your booking code'**
  String get flight_enterYourBookingCode;

  /// No description provided for @flight_enterYourSeatCode.
  ///
  /// In en, this message translates to:
  /// **'Enter your seat code'**
  String get flight_enterYourSeatCode;

  /// No description provided for @flight_enterYourEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get flight_enterYourEmail;

  /// No description provided for @flight_viewLatestDeals.
  ///
  /// In en, this message translates to:
  /// **'View the latest departure deals'**
  String get flight_viewLatestDeals;

  /// No description provided for @flight_noFlightsFound.
  ///
  /// In en, this message translates to:
  /// **'No suitable flights were found.'**
  String get flight_noFlightsFound;

  /// No description provided for @flight_from.
  ///
  /// In en, this message translates to:
  /// **'From '**
  String get flight_from;

  /// No description provided for @flight_to.
  ///
  /// In en, this message translates to:
  /// **' to '**
  String get flight_to;

  /// No description provided for @flight_extraServices.
  ///
  /// In en, this message translates to:
  /// **'Additional services'**
  String get flight_extraServices;

  /// No description provided for @flight_searchNameOrCodeAirport.
  ///
  /// In en, this message translates to:
  /// **'Search name or code airport ...'**
  String get flight_searchNameOrCodeAirport;

  /// No description provided for @flight_resultFlightDate.
  ///
  /// In en, this message translates to:
  /// **'Date: {date}'**
  String flight_resultFlightDate(Object date);

  /// No description provided for @flight_stopNo.
  ///
  /// In en, this message translates to:
  /// **'stop no'**
  String get flight_stopNo;

  /// No description provided for @flight_directFlight.
  ///
  /// In en, this message translates to:
  /// **'Direct flight'**
  String get flight_directFlight;

  /// No description provided for @flight_selectReturnTicket.
  ///
  /// In en, this message translates to:
  /// **'Select return ticket'**
  String get flight_selectReturnTicket;

  /// No description provided for @flight_selectOutboundTicket.
  ///
  /// In en, this message translates to:
  /// **'Select outbound ticket'**
  String get flight_selectOutboundTicket;

  /// No description provided for @flight_shrink.
  ///
  /// In en, this message translates to:
  /// **'Shrink'**
  String get flight_shrink;

  /// No description provided for @flight_readDetailPolicyTicket.
  ///
  /// In en, this message translates to:
  /// **'Read detail policy ticket'**
  String get flight_readDetailPolicyTicket;

  /// No description provided for @flight_luggage.
  ///
  /// In en, this message translates to:
  /// **'Luggage'**
  String get flight_luggage;

  /// No description provided for @flight_change.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get flight_change;

  /// No description provided for @flight_returnTicket.
  ///
  /// In en, this message translates to:
  /// **'Return ticket'**
  String get flight_returnTicket;

  /// No description provided for @flight_selectReturnFlight.
  ///
  /// In en, this message translates to:
  /// **'Select return flight'**
  String get flight_selectReturnFlight;

  /// No description provided for @form_consultation_departure_date.
  ///
  /// In en, this message translates to:
  /// **'Departure Date'**
  String get form_consultation_departure_date;

  /// No description provided for @form_consultation_departure_point.
  ///
  /// In en, this message translates to:
  /// **'Departure Point'**
  String get form_consultation_departure_point;

  /// No description provided for @form_consultation_name_label.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get form_consultation_name_label;

  /// No description provided for @form_consultation_name_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter full name'**
  String get form_consultation_name_hint;

  /// No description provided for @form_consultation_phone_label.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get form_consultation_phone_label;

  /// No description provided for @form_consultation_phone_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter phone number'**
  String get form_consultation_phone_hint;

  /// No description provided for @form_consultation_email_label.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get form_consultation_email_label;

  /// No description provided for @form_consultation_email_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter Email'**
  String get form_consultation_email_hint;

  /// No description provided for @form_consultation_note_label.
  ///
  /// In en, this message translates to:
  /// **'Special Requests'**
  String get form_consultation_note_label;

  /// No description provided for @form_consultation_note_hint.
  ///
  /// In en, this message translates to:
  /// **'Additional notes (if any)'**
  String get form_consultation_note_hint;

  /// No description provided for @form_consultation_policy_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy'**
  String get form_consultation_policy_cancel;

  /// No description provided for @form_consultation_view_detail.
  ///
  /// In en, this message translates to:
  /// **'View details.'**
  String get form_consultation_view_detail;

  /// No description provided for @form_consultation_book_now_pay_later.
  ///
  /// In en, this message translates to:
  /// **'Book now and pay later'**
  String get form_consultation_book_now_pay_later;

  /// No description provided for @form_consultation_flexible_desc.
  ///
  /// In en, this message translates to:
  /// **' - Secure your spot while staying flexible.'**
  String get form_consultation_flexible_desc;

  /// No description provided for @form_consultation_submit_button.
  ///
  /// In en, this message translates to:
  /// **'GET CONSULTATION'**
  String get form_consultation_submit_button;

  /// No description provided for @form_consultation_submitting_snackbar.
  ///
  /// In en, this message translates to:
  /// **'Sending consultation request...'**
  String get form_consultation_submitting_snackbar;

  /// No description provided for @form_consultation_success_msg.
  ///
  /// In en, this message translates to:
  /// **'Success: {message}'**
  String form_consultation_success_msg(Object message);

  /// No description provided for @form_consultation_validation_error.
  ///
  /// In en, this message translates to:
  /// **'Validation error: {error}'**
  String form_consultation_validation_error(Object error);

  /// No description provided for @form_consultation_required_error.
  ///
  /// In en, this message translates to:
  /// **'Please enter {field}'**
  String form_consultation_required_error(Object field);

  /// No description provided for @form_consultation_app_title_mock.
  ///
  /// In en, this message translates to:
  /// **'Flight Results'**
  String get form_consultation_app_title_mock;

  /// No description provided for @header_titleLine1.
  ///
  /// In en, this message translates to:
  /// **'Make every trip a'**
  String get header_titleLine1;

  /// No description provided for @header_titleLine2.
  ///
  /// In en, this message translates to:
  /// **'delightful experience'**
  String get header_titleLine2;

  /// No description provided for @home_tourSectionTitleVibes.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get home_tourSectionTitleVibes;

  /// No description provided for @home_tourSectionTitleFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured Tours'**
  String get home_tourSectionTitleFeatured;

  /// No description provided for @home_tourSectionTitleSearch.
  ///
  /// In en, this message translates to:
  /// **'Tours to'**
  String get home_tourSectionTitleSearch;

  /// No description provided for @home_tourSearchSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Showing Featured Tours.'**
  String get home_tourSearchSnackbar;

  /// No description provided for @home_destinationSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Selected:'**
  String get home_destinationSnackbar;

  /// No description provided for @home_promotionSectionVibes.
  ///
  /// In en, this message translates to:
  /// **'Offers'**
  String get home_promotionSectionVibes;

  /// No description provided for @home_promotionSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'For You'**
  String get home_promotionSectionTitle;

  /// No description provided for @home_promotionSnackbar.
  ///
  /// In en, this message translates to:
  /// **'You selected the offer:'**
  String get home_promotionSnackbar;

  /// No description provided for @home_destinationsTitle.
  ///
  /// In en, this message translates to:
  /// **'🔥 Tour Categories'**
  String get home_destinationsTitle;

  /// No description provided for @home_aboutUsVibes.
  ///
  /// In en, this message translates to:
  /// **'Introduction'**
  String get home_aboutUsVibes;

  /// No description provided for @home_aboutUsTitleLine1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to'**
  String get home_aboutUsTitleLine1;

  /// No description provided for @home_aboutUsTitleLine2.
  ///
  /// In en, this message translates to:
  /// **'Wondering Vietnam'**
  String get home_aboutUsTitleLine2;

  /// No description provided for @home_aboutUsDescription.
  ///
  /// In en, this message translates to:
  /// **'Wondering operates in the fields of tourism, flight tickets, and event organization in Vietnam. We always provide meticulous and dedicated services with the desire that \"every trip is a worthwhile experience story\". Our staff constantly strives to improve expertise and service quality.'**
  String get home_aboutUsDescription;

  /// No description provided for @home_aboutUsGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get home_aboutUsGuideTitle;

  /// No description provided for @home_aboutUsGuideSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Connecting services across the country and internationally'**
  String get home_aboutUsGuideSubtitle;

  /// No description provided for @home_aboutUsMissionTitle.
  ///
  /// In en, this message translates to:
  /// **'Vision & Mission'**
  String get home_aboutUsMissionTitle;

  /// No description provided for @home_aboutUsMissionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enhancing worthwhile travel experiences.'**
  String get home_aboutUsMissionSubtitle;

  /// No description provided for @home_exploreButton.
  ///
  /// In en, this message translates to:
  /// **'Start Exploring'**
  String get home_exploreButton;

  /// No description provided for @home_exploreSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Starting exploration...'**
  String get home_exploreSnackbar;

  /// No description provided for @home_trainSearchSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Searching... (\$text)'**
  String get home_trainSearchSnackbar;

  /// No description provided for @footer_contact.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get footer_contact;

  /// No description provided for @footer_introduce.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get footer_introduce;

  /// No description provided for @footer_socialMediaConnect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get footer_socialMediaConnect;

  /// No description provided for @footer_informationTitle.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get footer_informationTitle;

  /// No description provided for @footer_newsTitle.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get footer_newsTitle;

  /// No description provided for @footer_cancellationPolicy.
  ///
  /// In en, this message translates to:
  /// **'Cancellation Policy'**
  String get footer_cancellationPolicy;

  /// No description provided for @footer_guideTitle.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get footer_guideTitle;

  /// No description provided for @footer_registerOffer.
  ///
  /// In en, this message translates to:
  /// **'Register for Offers'**
  String get footer_registerOffer;

  /// No description provided for @footer_policyFlight.
  ///
  /// In en, this message translates to:
  /// **'Flight Ticket'**
  String get footer_policyFlight;

  /// No description provided for @footer_policyTour.
  ///
  /// In en, this message translates to:
  /// **'Tour'**
  String get footer_policyTour;

  /// No description provided for @footer_policyTrain.
  ///
  /// In en, this message translates to:
  /// **'Train Ticket'**
  String get footer_policyTrain;

  /// No description provided for @footer_policyCruise.
  ///
  /// In en, this message translates to:
  /// **'Cruise'**
  String get footer_policyCruise;

  /// No description provided for @footer_introDescription.
  ///
  /// In en, this message translates to:
  /// **'Wondering Vietnam specializes in providing and consulting services for domestic and international tours in Vietnam.'**
  String get footer_introDescription;

  /// No description provided for @footer_addressDetail.
  ///
  /// In en, this message translates to:
  /// **'Address: SH0212P1, Park 1 Tower, Vinhomes TimesCity Park Hill, 458 Minh Khai, Vinh Tuy, Hanoi'**
  String get footer_addressDetail;

  /// No description provided for @footer_contactDetail.
  ///
  /// In en, this message translates to:
  /// **'Hotline/Zalo: +84 90 111 81 85 / +84 76 979 8833'**
  String get footer_contactDetail;

  /// No description provided for @footer_emailDetail.
  ///
  /// In en, this message translates to:
  /// **'Email: booking@wonderingvietnam.com'**
  String get footer_emailDetail;

  /// No description provided for @footer_emailTitle.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get footer_emailTitle;

  /// No description provided for @footer_registerOfferDescription.
  ///
  /// In en, this message translates to:
  /// **'Leave your email to receive the earliest promotional information.'**
  String get footer_registerOfferDescription;

  /// No description provided for @footer_emailSentSnackbar.
  ///
  /// In en, this message translates to:
  /// **'Email registration for offers sent!'**
  String get footer_emailSentSnackbar;

  /// No description provided for @social_facebook.
  ///
  /// In en, this message translates to:
  /// **'Facebook'**
  String get social_facebook;

  /// No description provided for @social_instagram.
  ///
  /// In en, this message translates to:
  /// **'Instagram'**
  String get social_instagram;

  /// No description provided for @social_tiktok.
  ///
  /// In en, this message translates to:
  /// **'Tiktok'**
  String get social_tiktok;

  /// No description provided for @social_whatsapp.
  ///
  /// In en, this message translates to:
  /// **'WhatsApp'**
  String get social_whatsapp;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
