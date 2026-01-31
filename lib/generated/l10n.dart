// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `Your Studio`
  String get app_name {
    return Intl.message(
      'Your Studio',
      name: 'app_name',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancel {
    return Intl.message(
      'Cancel',
      name: 'cancel',
      desc: '',
      args: [],
    );
  }

  /// `Book Now`
  String get book_now {
    return Intl.message(
      'Book Now',
      name: 'book_now',
      desc: '',
      args: [],
    );
  }

  /// `Update Now`
  String get update_now {
    return Intl.message(
      'Update Now',
      name: 'update_now',
      desc: '',
      args: [],
    );
  }

  /// `Please login again`
  String get please_login_again {
    return Intl.message(
      'Please login again',
      name: 'please_login_again',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get something_went_wrong {
    return Intl.message(
      'Something went wrong',
      name: 'something_went_wrong',
      desc: '',
      args: [],
    );
  }

  /// `Existing Events`
  String get existing_events {
    return Intl.message(
      'Existing Events',
      name: 'existing_events',
      desc: '',
      args: [],
    );
  }

  /// `Welcome !`
  String get welcome_back {
    return Intl.message(
      'Welcome !',
      name: 'welcome_back',
      desc: '',
      args: [],
    );
  }

  /// `Videos`
  String get videos {
    return Intl.message(
      'Videos',
      name: 'videos',
      desc: '',
      args: [],
    );
  }

  /// `No photos available`
  String get no_photos_available {
    return Intl.message(
      'No photos available',
      name: 'no_photos_available',
      desc: '',
      args: [],
    );
  }

  /// `Rate us on Google play`
  String get rate_us_on_google_play {
    return Intl.message(
      'Rate us on Google play',
      name: 'rate_us_on_google_play',
      desc: '',
      args: [],
    );
  }

  /// `Create an account`
  String get create_an_account {
    return Intl.message(
      'Create an account',
      name: 'create_an_account',
      desc: '',
      args: [],
    );
  }

  /// `Photo selection info`
  String get photo_selection_info {
    return Intl.message(
      'Photo selection info',
      name: 'photo_selection_info',
      desc: '',
      args: [],
    );
  }

  /// `*Selected photos already moved to album design`
  String get selected_photos_already_moved_to_album_design {
    return Intl.message(
      '*Selected photos already moved to album design',
      name: 'selected_photos_already_moved_to_album_design',
      desc: '',
      args: [],
    );
  }

  /// `Reject`
  String get reject_photo {
    return Intl.message(
      'Reject',
      name: 'reject_photo',
      desc: '',
      args: [],
    );
  }

  /// `No photo selection album available`
  String get no_photo_selection_album_available {
    return Intl.message(
      'No photo selection album available',
      name: 'no_photo_selection_album_available',
      desc: '',
      args: [],
    );
  }

  /// `Logout`
  String get logout {
    return Intl.message(
      'Logout',
      name: 'logout',
      desc: '',
      args: [],
    );
  }

  /// `Please try  after some time`
  String get please_try_after_some_time {
    return Intl.message(
      'Please try  after some time',
      name: 'please_try_after_some_time',
      desc: '',
      args: [],
    );
  }

  /// `Photos in waiting list`
  String get photos_in_waiting_list {
    return Intl.message(
      'Photos in waiting list',
      name: 'photos_in_waiting_list',
      desc: '',
      args: [],
    );
  }

  /// `Photos moved to album design`
  String get photos_moved_to_album_design {
    return Intl.message(
      'Photos moved to album design',
      name: 'photos_moved_to_album_design',
      desc: '',
      args: [],
    );
  }

  /// `There is no event for restore`
  String get there_is_no_event_for_restore {
    return Intl.message(
      'There is no event for restore',
      name: 'there_is_no_event_for_restore',
      desc: '',
      args: [],
    );
  }

  /// `Welcome !`
  String get welcome {
    return Intl.message(
      'Welcome !',
      name: 'welcome',
      desc: '',
      args: [],
    );
  }

  /// `Gallery`
  String get gallery {
    return Intl.message(
      'Gallery',
      name: 'gallery',
      desc: '',
      args: [],
    );
  }

  /// `Events`
  String get events {
    return Intl.message(
      'Events',
      name: 'events',
      desc: '',
      args: [],
    );
  }

  /// `Move to waiting list`
  String get move_to_waiting_list {
    return Intl.message(
      'Move to waiting list',
      name: 'move_to_waiting_list',
      desc: '',
      args: [],
    );
  }

  /// `Are You Sure`
  String get are_you_sure {
    return Intl.message(
      'Are You Sure',
      name: 'are_you_sure',
      desc: '',
      args: [],
    );
  }

  /// `Set remainder`
  String get set_remainder {
    return Intl.message(
      'Set remainder',
      name: 'set_remainder',
      desc: '',
      args: [],
    );
  }

  /// `Technical support`
  String get technical_support {
    return Intl.message(
      'Technical support',
      name: 'technical_support',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message(
      'Edit',
      name: 'edit',
      desc: '',
      args: [],
    );
  }

  /// `Folder name`
  String get folder_name {
    return Intl.message(
      'Folder name',
      name: 'folder_name',
      desc: '',
      args: [],
    );
  }

  /// `I have selected the photos for my album and I wish to submit them for designing. Changes cannot be made to the selected photos after submitting for designing.`
  String get i_have_selected_the_photos_for_my_album_and_i {
    return Intl.message(
      'I have selected the photos for my album and I wish to submit them for designing. Changes cannot be made to the selected photos after submitting for designing.',
      name: 'i_have_selected_the_photos_for_my_album_and_i',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid mobile number`
  String get please_enter_valid_mobile_number {
    return Intl.message(
      'Please enter valid mobile number',
      name: 'please_enter_valid_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `Feel free to contact us`
  String get feel_free_to_contact_us {
    return Intl.message(
      'Feel free to contact us',
      name: 'feel_free_to_contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Session  Expired`
  String get session_expired {
    return Intl.message(
      'Session  Expired',
      name: 'session_expired',
      desc: '',
      args: [],
    );
  }

  /// `Login With Google`
  String get login_with_google {
    return Intl.message(
      'Login With Google',
      name: 'login_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Resend OTP`
  String get resend_otp {
    return Intl.message(
      'Resend OTP',
      name: 'resend_otp',
      desc: '',
      args: [],
    );
  }

  /// `Photo Selection`
  String get photo_selection {
    return Intl.message(
      'Photo Selection',
      name: 'photo_selection',
      desc: '',
      args: [],
    );
  }

  /// `Photomall`
  String get photomall {
    return Intl.message(
      'Photomall',
      name: 'photomall',
      desc: '',
      args: [],
    );
  }

  /// `Connection available`
  String get connection_available {
    return Intl.message(
      'Connection available',
      name: 'connection_available',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected_photos {
    return Intl.message(
      'Selected',
      name: 'selected_photos',
      desc: '',
      args: [],
    );
  }

  /// `Please wait`
  String get please_wait {
    return Intl.message(
      'Please wait',
      name: 'please_wait',
      desc: '',
      args: [],
    );
  }

  /// `E-Album`
  String get albums {
    return Intl.message(
      'E-Album',
      name: 'albums',
      desc: '',
      args: [],
    );
  }

  /// `Select event type`
  String get select_event_type {
    return Intl.message(
      'Select event type',
      name: 'select_event_type',
      desc: '',
      args: [],
    );
  }

  /// `Key must be 5 characters`
  String get key_must_be_5_characters {
    return Intl.message(
      'Key must be 5 characters',
      name: 'key_must_be_5_characters',
      desc: '',
      args: [],
    );
  }

  /// `Loading photos`
  String get loading_photos {
    return Intl.message(
      'Loading photos',
      name: 'loading_photos',
      desc: '',
      args: [],
    );
  }

  /// `Save`
  String get save {
    return Intl.message(
      'Save',
      name: 'save',
      desc: '',
      args: [],
    );
  }

  /// `Kindly restart the app if not connected`
  String get kindly_restart_the_app_if_not_connected {
    return Intl.message(
      'Kindly restart the app if not connected',
      name: 'kindly_restart_the_app_if_not_connected',
      desc: '',
      args: [],
    );
  }

  /// `User profile`
  String get user_profile {
    return Intl.message(
      'User profile',
      name: 'user_profile',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contact_us {
    return Intl.message(
      'Contact Us',
      name: 'contact_us',
      desc: '',
      args: [],
    );
  }

  /// `Login`
  String get login {
    return Intl.message(
      'Login',
      name: 'login',
      desc: '',
      args: [],
    );
  }

  /// `Photos still in waiting list`
  String get photos_still_in_waiting_list {
    return Intl.message(
      'Photos still in waiting list',
      name: 'photos_still_in_waiting_list',
      desc: '',
      args: [],
    );
  }

  /// `No photos available for photo selection`
  String get no_photos_available_for_photo_selection {
    return Intl.message(
      'No photos available for photo selection',
      name: 'no_photos_available_for_photo_selection',
      desc: '',
      args: [],
    );
  }

  /// `Select Source`
  String get select_source {
    return Intl.message(
      'Select Source',
      name: 'select_source',
      desc: '',
      args: [],
    );
  }

  /// `Event Details`
  String get event_details {
    return Intl.message(
      'Event Details',
      name: 'event_details',
      desc: '',
      args: [],
    );
  }

  /// `Don’t have an account register?`
  String get dont_have_an_account_register {
    return Intl.message(
      'Don’t have an account register?',
      name: 'dont_have_an_account_register',
      desc: '',
      args: [],
    );
  }

  /// `No events available`
  String get no_events_available {
    return Intl.message(
      'No events available',
      name: 'no_events_available',
      desc: '',
      args: [],
    );
  }

  /// `Waiting List`
  String get waiting_list_photos {
    return Intl.message(
      'Waiting List',
      name: 'waiting_list_photos',
      desc: '',
      args: [],
    );
  }

  /// `Camera`
  String get camera {
    return Intl.message(
      'Camera',
      name: 'camera',
      desc: '',
      args: [],
    );
  }

  /// `Delete Event`
  String get delete_event {
    return Intl.message(
      'Delete Event',
      name: 'delete_event',
      desc: '',
      args: [],
    );
  }

  /// `Please fill this field`
  String get please_fill_this_field {
    return Intl.message(
      'Please fill this field',
      name: 'please_fill_this_field',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account login`
  String get already_have_an_account_login {
    return Intl.message(
      'Already have an account login',
      name: 'already_have_an_account_login',
      desc: '',
      args: [],
    );
  }

  /// `Languages`
  String get languages {
    return Intl.message(
      'Languages',
      name: 'languages',
      desc: '',
      args: [],
    );
  }

  /// `Please wait preparing your album`
  String get please_wait_preparing_your_album {
    return Intl.message(
      'Please wait preparing your album',
      name: 'please_wait_preparing_your_album',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to log out? \nYour events will be removed from this device after logging out`
  String get are_you_sure_you_want_to_logout_after_logout_your {
    return Intl.message(
      'Are you sure you want to log out? \nYour events will be removed from this device after logging out',
      name: 'are_you_sure_you_want_to_logout_after_logout_your',
      desc: '',
      args: [],
    );
  }

  /// `Select Language`
  String get select_language {
    return Intl.message(
      'Select Language',
      name: 'select_language',
      desc: '',
      args: [],
    );
  }

  /// `Restore Events`
  String get restore_events {
    return Intl.message(
      'Restore Events',
      name: 'restore_events',
      desc: '',
      args: [],
    );
  }

  /// `Version Info`
  String get version_info {
    return Intl.message(
      'Version Info',
      name: 'version_info',
      desc: '',
      args: [],
    );
  }

  /// `Watch your magical moments as digital album here`
  String get watch_your_magical_moments_as_digital_album_here {
    return Intl.message(
      'Watch your magical moments as digital album here',
      name: 'watch_your_magical_moments_as_digital_album_here',
      desc: '',
      args: [],
    );
  }

  /// `Unable to move`
  String get unable_to_move {
    return Intl.message(
      'Unable to move',
      name: 'unable_to_move',
      desc: '',
      args: [],
    );
  }

  /// `Email address`
  String get email_address {
    return Intl.message(
      'Email address',
      name: 'email_address',
      desc: '',
      args: [],
    );
  }

  /// `Share App`
  String get share_app {
    return Intl.message(
      'Share App',
      name: 'share_app',
      desc: '',
      args: [],
    );
  }

  /// `Mobile number`
  String get mobile_number {
    return Intl.message(
      'Mobile number',
      name: 'mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `Event Booking`
  String get event_booking {
    return Intl.message(
      'Event Booking',
      name: 'event_booking',
      desc: '',
      args: [],
    );
  }

  /// `Register`
  String get register {
    return Intl.message(
      'Register',
      name: 'register',
      desc: '',
      args: [],
    );
  }

  /// `Date`
  String get date {
    return Intl.message(
      'Date',
      name: 'date',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid email address`
  String get please_enter_valid_email_address {
    return Intl.message(
      'Please enter valid email address',
      name: 'please_enter_valid_email_address',
      desc: '',
      args: [],
    );
  }

  /// `Videos for this event will be coming soon`
  String get videos_for_this_event_will_be_coming_soon {
    return Intl.message(
      'Videos for this event will be coming soon',
      name: 'videos_for_this_event_will_be_coming_soon',
      desc: '',
      args: [],
    );
  }

  /// `App Version`
  String get app_version {
    return Intl.message(
      'App Version',
      name: 'app_version',
      desc: '',
      args: [],
    );
  }

  /// `Event booked successfully`
  String get event_booked_successfully {
    return Intl.message(
      'Event booked successfully',
      name: 'event_booked_successfully',
      desc: '',
      args: [],
    );
  }

  /// `Email or Mobile number*`
  String get email_or_mobile_number {
    return Intl.message(
      'Email or Mobile number*',
      name: 'email_or_mobile_number',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message(
      'Language',
      name: 'language',
      desc: '',
      args: [],
    );
  }

  /// `Experience`
  String get experience {
    return Intl.message(
      'Experience',
      name: 'experience',
      desc: '',
      args: [],
    );
  }

  /// `Give a call`
  String get give_a_call {
    return Intl.message(
      'Give a call',
      name: 'give_a_call',
      desc: '',
      args: [],
    );
  }

  /// `If you delete an event, both complete and incomplete album for selection will also be deleted. You can restore it back from settings if you need.`
  String get if_you_delete_an_event_both_complete_and_incomplete_album {
    return Intl.message(
      'If you delete an event, both complete and incomplete album for selection will also be deleted. You can restore it back from settings if you need.',
      name: 'if_you_delete_an_event_both_complete_and_incomplete_album',
      desc: '',
      args: [],
    );
  }

  /// `Select all`
  String get select_all {
    return Intl.message(
      'Select all',
      name: 'select_all',
      desc: '',
      args: [],
    );
  }

  /// `We are happy to hear from you call us anytime`
  String get we_are_happy_to_hear_from_you_call_us_anytime {
    return Intl.message(
      'We are happy to hear from you call us anytime',
      name: 'we_are_happy_to_hear_from_you_call_us_anytime',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get profile_name {
    return Intl.message(
      'Name',
      name: 'profile_name',
      desc: '',
      args: [],
    );
  }

  /// `Download`
  String get download {
    return Intl.message(
      'Download',
      name: 'download',
      desc: '',
      args: [],
    );
  }

  /// `Later`
  String get later {
    return Intl.message(
      'Later',
      name: 'later',
      desc: '',
      args: [],
    );
  }

  /// `Warning`
  String get warning {
    return Intl.message(
      'Warning',
      name: 'warning',
      desc: '',
      args: [],
    );
  }

  /// `This album is for demo purpose only`
  String get this_album_is_for_demo_purpose_only {
    return Intl.message(
      'This album is for demo purpose only',
      name: 'this_album_is_for_demo_purpose_only',
      desc: '',
      args: [],
    );
  }

  /// `View on map`
  String get view_on_map {
    return Intl.message(
      'View on map',
      name: 'view_on_map',
      desc: '',
      args: [],
    );
  }

  /// `Info`
  String get info {
    return Intl.message(
      'Info',
      name: 'info',
      desc: '',
      args: [],
    );
  }

  /// `Move photos to album design`
  String get move_photos_to_album_design {
    return Intl.message(
      'Move photos to album design',
      name: 'move_photos_to_album_design',
      desc: '',
      args: [],
    );
  }

  /// `Photos count`
  String get photos_count {
    return Intl.message(
      'Photos count',
      name: 'photos_count',
      desc: '',
      args: [],
    );
  }

  /// `please type the verification code sent to `
  String get please_type_the_verification_code_sent_to_ {
    return Intl.message(
      'please type the verification code sent to ',
      name: 'please_type_the_verification_code_sent_to_',
      desc: '',
      args: [],
    );
  }

  /// `In order to keep using the application, you must update the application by clicking the "update" button.`
  String get kindly_update_to_the_latest_version {
    return Intl.message(
      'In order to keep using the application, you must update the application by clicking the "update" button.',
      name: 'kindly_update_to_the_latest_version',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message(
      'Settings',
      name: 'settings',
      desc: '',
      args: [],
    );
  }

  /// `click down and scan qr code to view event`
  String get click_down_and_scan_qr_coden_to_view_event {
    return Intl.message(
      'click down and scan qr code to view event',
      name: 'click_down_and_scan_qr_coden_to_view_event',
      desc: '',
      args: [],
    );
  }

  /// `Login to continue`
  String get log_in_to_continue {
    return Intl.message(
      'Login to continue',
      name: 'log_in_to_continue',
      desc: '',
      args: [],
    );
  }

  /// `Check your internet connection`
  String get check_your_internet_connection {
    return Intl.message(
      'Check your internet connection',
      name: 'check_your_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Invitation`
  String get invitation {
    return Intl.message(
      'Invitation',
      name: 'invitation',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for choosing us`
  String get thank_you_for_choosing_us {
    return Intl.message(
      'Thank you for choosing us',
      name: 'thank_you_for_choosing_us',
      desc: '',
      args: [],
    );
  }

  /// `No rejected photos available`
  String get no_rejected_photos_available {
    return Intl.message(
      'No rejected photos available',
      name: 'no_rejected_photos_available',
      desc: '',
      args: [],
    );
  }

  /// `Updated version is already installed`
  String get updated_version_is_already_installed {
    return Intl.message(
      'Updated version is already installed',
      name: 'updated_version_is_already_installed',
      desc: '',
      args: [],
    );
  }

  /// `No select photos available`
  String get no_selected_photos_available {
    return Intl.message(
      'No select photos available',
      name: 'no_selected_photos_available',
      desc: '',
      args: [],
    );
  }

  /// `No photos available in waiting list`
  String get no_photos_available_in_waiting_list {
    return Intl.message(
      'No photos available in waiting list',
      name: 'no_photos_available_in_waiting_list',
      desc: '',
      args: [],
    );
  }

  /// `Success`
  String get success {
    return Intl.message(
      'Success',
      name: 'success',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure that you want to close app?`
  String get are_you_sure_that_you_want_to_close_app {
    return Intl.message(
      'Are you sure that you want to close app?',
      name: 'are_you_sure_that_you_want_to_close_app',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message(
      'Name',
      name: 'name',
      desc: '',
      args: [],
    );
  }

  /// `Please select event date`
  String get please_select_event_date {
    return Intl.message(
      'Please select event date',
      name: 'please_select_event_date',
      desc: '',
      args: [],
    );
  }

  /// `No events available for you`
  String get no_events_available_for_you {
    return Intl.message(
      'No events available for you',
      name: 'no_events_available_for_you',
      desc: '',
      args: [],
    );
  }

  /// `Verification code`
  String get verification_code {
    return Intl.message(
      'Verification code',
      name: 'verification_code',
      desc: '',
      args: [],
    );
  }

  /// `Select date`
  String get select_date {
    return Intl.message(
      'Select date',
      name: 'select_date',
      desc: '',
      args: [],
    );
  }

  /// `No`
  String get no {
    return Intl.message(
      'No',
      name: 'no',
      desc: '',
      args: [],
    );
  }

  /// `Update the App to Continue.`
  String get you_are_using_outdated_app {
    return Intl.message(
      'Update the App to Continue.',
      name: 'you_are_using_outdated_app',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message(
      'Submit',
      name: 'submit',
      desc: '',
      args: [],
    );
  }

  /// `Update`
  String get update {
    return Intl.message(
      'Update',
      name: 'update',
      desc: '',
      args: [],
    );
  }

  /// `Add Event`
  String get add_event {
    return Intl.message(
      'Add Event',
      name: 'add_event',
      desc: '',
      args: [],
    );
  }

  /// `Enter event key to view event`
  String get enter_event_key_to_view_event {
    return Intl.message(
      'Enter event key to view event',
      name: 'enter_event_key_to_view_event',
      desc: '',
      args: [],
    );
  }

  /// `Delete`
  String get delete {
    return Intl.message(
      'Delete',
      name: 'delete',
      desc: '',
      args: [],
    );
  }

  /// `Select photo`
  String get select_photo {
    return Intl.message(
      'Select photo',
      name: 'select_photo',
      desc: '',
      args: [],
    );
  }

  /// `Please select event type`
  String get please_select_event_type {
    return Intl.message(
      'Please select event type',
      name: 'please_select_event_type',
      desc: '',
      args: [],
    );
  }

  /// `OTP must be 4 character.`
  String get otp_length_validation_error {
    return Intl.message(
      'OTP must be 4 character.',
      name: 'otp_length_validation_error',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected_photos {
    return Intl.message(
      'Rejected',
      name: 'rejected_photos',
      desc: '',
      args: [],
    );
  }

  /// `If you face any technical difficulties contact photomall`
  String get if_you_face_any_technical_difficulties_contact_photomall {
    return Intl.message(
      'If you face any technical difficulties contact photomall',
      name: 'if_you_face_any_technical_difficulties_contact_photomall',
      desc: '',
      args: [],
    );
  }

  /// `Select country`
  String get select_country {
    return Intl.message(
      'Select country',
      name: 'select_country',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get no_internet_connection {
    return Intl.message(
      'No internet connection',
      name: 'no_internet_connection',
      desc: '',
      args: [],
    );
  }

  /// `Event Key`
  String get event_key {
    return Intl.message(
      'Event Key',
      name: 'event_key',
      desc: '',
      args: [],
    );
  }

  /// `Select events`
  String get select_events {
    return Intl.message(
      'Select events',
      name: 'select_events',
      desc: '',
      args: [],
    );
  }

  /// `Or`
  String get or {
    return Intl.message(
      'Or',
      name: 'or',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restore {
    return Intl.message(
      'Restore',
      name: 'restore',
      desc: '',
      args: [],
    );
  }

  /// `Preparing your album`
  String get preparing_your_album {
    return Intl.message(
      'Preparing your album',
      name: 'preparing_your_album',
      desc: '',
      args: [],
    );
  }

  /// `Yes`
  String get yes {
    return Intl.message(
      'Yes',
      name: 'yes',
      desc: '',
      args: [],
    );
  }

  /// `Celebrate in Style – Book Us Today!`
  String get book_us_for_your_special_occasion {
    return Intl.message(
      'Celebrate in Style – Book Us Today!',
      name: 'book_us_for_your_special_occasion',
      desc: '',
      args: [],
    );
  }

  /// `Please select correct event date`
  String get please_select_correct_event_date {
    return Intl.message(
      'Please select correct event date',
      name: 'please_select_correct_event_date',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to delete an event from your phone storage?`
  String get are_you_sure_want_to_delete_an_event_from_your {
    return Intl.message(
      'Are you sure want to delete an event from your phone storage?',
      name: 'are_you_sure_want_to_delete_an_event_from_your',
      desc: '',
      args: [],
    );
  }

  /// `Home`
  String get home {
    return Intl.message(
      'Home',
      name: 'home',
      desc: '',
      args: [],
    );
  }

  /// ` * make sure photos in waiting count to zero to move`
  String get make_sure_photos_in_waiting_count_to_zero0_to_move {
    return Intl.message(
      ' * make sure photos in waiting count to zero to move',
      name: 'make_sure_photos_in_waiting_count_to_zero0_to_move',
      desc: '',
      args: [],
    );
  }

  /// `Register with Google`
  String get register_with_google {
    return Intl.message(
      'Register with Google',
      name: 'register_with_google',
      desc: '',
      args: [],
    );
  }

  /// `Update available`
  String get update_available {
    return Intl.message(
      'Update available',
      name: 'update_available',
      desc: '',
      args: [],
    );
  }

  /// `Set Profile Picture`
  String get set_profile_picture {
    return Intl.message(
      'Set Profile Picture',
      name: 'set_profile_picture',
      desc: '',
      args: [],
    );
  }

  /// `No internet connection`
  String get no_internet_connections {
    return Intl.message(
      'No internet connection',
      name: 'no_internet_connections',
      desc: '',
      args: [],
    );
  }

  /// `Select Source`
  String get selectSource {
    return Intl.message(
      'Select Source',
      name: 'selectSource',
      desc: '',
      args: [],
    );
  }

  /// `My Addresses`
  String get myAddresses {
    return Intl.message(
      'My Addresses',
      name: 'myAddresses',
      desc: '',
      args: [],
    );
  }

  /// `You have not add address yet`
  String get you_have_not_add_address_yet {
    return Intl.message(
      'You have not add address yet',
      name: 'you_have_not_add_address_yet',
      desc: '',
      args: [],
    );
  }

  /// `Add your name`
  String get add_your_name {
    return Intl.message(
      'Add your name',
      name: 'add_your_name',
      desc: '',
      args: [],
    );
  }

  /// `Wallet`
  String get wallet {
    return Intl.message(
      'Wallet',
      name: 'wallet',
      desc: '',
      args: [],
    );
  }

  /// `Choose`
  String get choose {
    return Intl.message(
      'Choose',
      name: 'choose',
      desc: '',
      args: [],
    );
  }

  /// `Add your email`
  String get add_your_email {
    return Intl.message(
      'Add your email',
      name: 'add_your_email',
      desc: '',
      args: [],
    );
  }

  /// `VERIFY EMAIL`
  String get verify_email {
    return Intl.message(
      'VERIFY EMAIL',
      name: 'verify_email',
      desc: '',
      args: [],
    );
  }

  /// `Bookings`
  String get orders {
    return Intl.message(
      'Bookings',
      name: 'orders',
      desc: '',
      args: [],
    );
  }

  /// `Add New`
  String get add_new {
    return Intl.message(
      'Add New',
      name: 'add_new',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure want to delete this address?`
  String get sure_to_delete_address {
    return Intl.message(
      'Are you sure want to delete this address?',
      name: 'sure_to_delete_address',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continue_text {
    return Intl.message(
      'Continue',
      name: 'continue_text',
      desc: '',
      args: [],
    );
  }

  /// `Undecided`
  String get undecided {
    return Intl.message(
      'Undecided',
      name: 'undecided',
      desc: '',
      args: [],
    );
  }

  /// `Shortage :`
  String get shortage {
    return Intl.message(
      'Shortage :',
      name: 'shortage',
      desc: '',
      args: [],
    );
  }

  /// `Book Now`
  String get bookNow {
    return Intl.message(
      'Book Now',
      name: 'bookNow',
      desc: '',
      args: [],
    );
  }

  /// `Profile`
  String get profile {
    return Intl.message(
      'Profile',
      name: 'profile',
      desc: '',
      args: [],
    );
  }

  /// `Remarks`
  String get remarks {
    return Intl.message(
      'Remarks',
      name: 'remarks',
      desc: '',
      args: [],
    );
  }

  /// `Contact Us`
  String get contactUs {
    return Intl.message(
      'Contact Us',
      name: 'contactUs',
      desc: '',
      args: [],
    );
  }

  /// `Media`
  String get medias {
    return Intl.message(
      'Media',
      name: 'medias',
      desc: '',
      args: [],
    );
  }

  /// `Sorry, The invitation can't be downloaded now`
  String get sorryInvitationCantBeDownloadNow {
    return Intl.message(
      'Sorry, The invitation can\'t be downloaded now',
      name: 'sorryInvitationCantBeDownloadNow',
      desc: '',
      args: [],
    );
  }

  /// `Archive`
  String get archive {
    return Intl.message(
      'Archive',
      name: 'archive',
      desc: '',
      args: [],
    );
  }

  /// `Excess`
  String get excess {
    return Intl.message(
      'Excess',
      name: 'excess',
      desc: '',
      args: [],
    );
  }

  /// `Satisfied`
  String get satisfied {
    return Intl.message(
      'Satisfied',
      name: 'satisfied',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected {
    return Intl.message(
      'Selected',
      name: 'selected',
      desc: '',
      args: [],
    );
  }

  /// `Minimum`
  String get minimum {
    return Intl.message(
      'Minimum',
      name: 'minimum',
      desc: '',
      args: [],
    );
  }

  /// `Maximum`
  String get maximum {
    return Intl.message(
      'Maximum',
      name: 'maximum',
      desc: '',
      args: [],
    );
  }

  /// `Move to album`
  String get moveToAlbum {
    return Intl.message(
      'Move to album',
      name: 'moveToAlbum',
      desc: '',
      args: [],
    );
  }

  /// `Album Design Confirmation`
  String get albumDesignConfirmation {
    return Intl.message(
      'Album Design Confirmation',
      name: 'albumDesignConfirmation',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to submit? Changes can not be made to the selected photos after submitting for the design.`
  String get areYouSureYouWantToSubmitChangesCanNot {
    return Intl.message(
      'Are you sure you want to submit? Changes can not be made to the selected photos after submitting for the design.',
      name: 'areYouSureYouWantToSubmitChangesCanNot',
      desc: '',
      args: [],
    );
  }

  /// `Selected Photos`
  String get selectedPhotos {
    return Intl.message(
      'Selected Photos',
      name: 'selectedPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Rejected Photos`
  String get rejectedPhotos {
    return Intl.message(
      'Rejected Photos',
      name: 'rejectedPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Undecided Photos`
  String get undecidedPhotos {
    return Intl.message(
      'Undecided Photos',
      name: 'undecidedPhotos',
      desc: '',
      args: [],
    );
  }

  /// `No Media Available`
  String get noMediaAvailable {
    return Intl.message(
      'No Media Available',
      name: 'noMediaAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Photo Selection is not available`
  String get photoSelectionNotAvailable {
    return Intl.message(
      'Photo Selection is not available',
      name: 'photoSelectionNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `No Photo Selection Available`
  String get noPhotoSelectionAvailable {
    return Intl.message(
      'No Photo Selection Available',
      name: 'noPhotoSelectionAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Not yet added`
  String get notYetAdded {
    return Intl.message(
      'Not yet added',
      name: 'notYetAdded',
      desc: '',
      args: [],
    );
  }

  /// `Phone`
  String get phone {
    return Intl.message(
      'Phone',
      name: 'phone',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get email {
    return Intl.message(
      'Email',
      name: 'email',
      desc: '',
      args: [],
    );
  }

  /// `Verify`
  String get verify {
    return Intl.message(
      'Verify',
      name: 'verify',
      desc: '',
      args: [],
    );
  }

  /// `ADD YOUR EMAIL`
  String get addYourEmail {
    return Intl.message(
      'ADD YOUR EMAIL',
      name: 'addYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `Archived Events`
  String get archivedEvents {
    return Intl.message(
      'Archived Events',
      name: 'archivedEvents',
      desc: '',
      args: [],
    );
  }

  /// `Help`
  String get help {
    return Intl.message(
      'Help',
      name: 'help',
      desc: '',
      args: [],
    );
  }

  /// `VERIFY EMAIL`
  String get verifyEmail {
    return Intl.message(
      'VERIFY EMAIL',
      name: 'verifyEmail',
      desc: '',
      args: [],
    );
  }

  /// `Change name`
  String get changeName {
    return Intl.message(
      'Change name',
      name: 'changeName',
      desc: '',
      args: [],
    );
  }

  /// `Add name`
  String get addName {
    return Intl.message(
      'Add name',
      name: 'addName',
      desc: '',
      args: [],
    );
  }

  /// `OTP has been sent to your account`
  String get otpHasBeenSentToYourAccount {
    return Intl.message(
      'OTP has been sent to your account',
      name: 'otpHasBeenSentToYourAccount',
      desc: '',
      args: [],
    );
  }

  /// `Language changed successfully.`
  String get languageChangedSuccessfully {
    return Intl.message(
      'Language changed successfully.',
      name: 'languageChangedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `App has cool features, Do checkout this awesome app!`
  String get appHasCoolFeaturesISuggestYouToCheckoutThis {
    return Intl.message(
      'App has cool features, Do checkout this awesome app!',
      name: 'appHasCoolFeaturesISuggestYouToCheckoutThis',
      desc: '',
      args: [],
    );
  }

  /// `recommends that you update to the latest version`
  String get recommendsThatYouUpdateToTheLatestVersion {
    return Intl.message(
      'recommends that you update to the latest version',
      name: 'recommendsThatYouUpdateToTheLatestVersion',
      desc: '',
      args: [],
    );
  }

  /// `Please wait`
  String get pleaseWait {
    return Intl.message(
      'Please wait',
      name: 'pleaseWait',
      desc: '',
      args: [],
    );
  }

  /// `No Event Available`
  String get noEventAvailable {
    return Intl.message(
      'No Event Available',
      name: 'noEventAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Oops Something went wrong`
  String get oopsSomethingWentWrong {
    return Intl.message(
      'Oops Something went wrong',
      name: 'oopsSomethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Not published`
  String get notPublished {
    return Intl.message(
      'Not published',
      name: 'notPublished',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Image not available`
  String get imageNotAvailable {
    return Intl.message(
      'Image not available',
      name: 'imageNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Invalid key`
  String get invalidKey {
    return Intl.message(
      'Invalid key',
      name: 'invalidKey',
      desc: '',
      args: [],
    );
  }

  /// `Thank you for your gracious presence at the function`
  String get thankYouForYourGraciousPresenceAtTheFunction {
    return Intl.message(
      'Thank you for your gracious presence at the function',
      name: 'thankYouForYourGraciousPresenceAtTheFunction',
      desc: '',
      args: [],
    );
  }

  /// `Information not available`
  String get informationNotAvailable {
    return Intl.message(
      'Information not available',
      name: 'informationNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Set reminder`
  String get setReminder {
    return Intl.message(
      'Set reminder',
      name: 'setReminder',
      desc: '',
      args: [],
    );
  }

  /// `Direction`
  String get direction {
    return Intl.message(
      'Direction',
      name: 'direction',
      desc: '',
      args: [],
    );
  }

  /// `Signed in successfully.`
  String get signedInSuccessfully {
    return Intl.message(
      'Signed in successfully.',
      name: 'signedInSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `SIGN OUT`
  String get signOut {
    return Intl.message(
      'SIGN OUT',
      name: 'signOut',
      desc: '',
      args: [],
    );
  }

  /// `enter name`
  String get enterName {
    return Intl.message(
      'enter name',
      name: 'enterName',
      desc: '',
      args: [],
    );
  }

  /// `please enter your name`
  String get pleaseEnterYourName {
    return Intl.message(
      'please enter your name',
      name: 'pleaseEnterYourName',
      desc: '',
      args: [],
    );
  }

  /// `Your offline`
  String get yourOffline {
    return Intl.message(
      'Your offline',
      name: 'yourOffline',
      desc: '',
      args: [],
    );
  }

  /// `Name Updated Successfully`
  String get nameUpdatedSuccessfully {
    return Intl.message(
      'Name Updated Successfully',
      name: 'nameUpdatedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Try again`
  String get tryAgain {
    return Intl.message(
      'Try again',
      name: 'tryAgain',
      desc: '',
      args: [],
    );
  }

  /// `Ok`
  String get ok {
    return Intl.message(
      'Ok',
      name: 'ok',
      desc: '',
      args: [],
    );
  }

  /// `Enter E-mail Address`
  String get enterEmailAddress {
    return Intl.message(
      'Enter E-mail Address',
      name: 'enterEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Please enter e-mail addresss`
  String get pleaseEnterEmailAddresss {
    return Intl.message(
      'Please enter e-mail addresss',
      name: 'pleaseEnterEmailAddresss',
      desc: '',
      args: [],
    );
  }

  /// `Please enter valid email address`
  String get pleaseEnterValidEmailAddress {
    return Intl.message(
      'Please enter valid email address',
      name: 'pleaseEnterValidEmailAddress',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP`
  String get enterOtp {
    return Intl.message(
      'Enter OTP',
      name: 'enterOtp',
      desc: '',
      args: [],
    );
  }

  /// `OTP Sent Successfully`
  String get otpSentSuccessfully {
    return Intl.message(
      'OTP Sent Successfully',
      name: 'otpSentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Take photo`
  String get takePhoto {
    return Intl.message(
      'Take photo',
      name: 'takePhoto',
      desc: '',
      args: [],
    );
  }

  /// `Choose from gallery`
  String get chooseFromGallery {
    return Intl.message(
      'Choose from gallery',
      name: 'chooseFromGallery',
      desc: '',
      args: [],
    );
  }

  /// `Set profile picture`
  String get setProfilePicture {
    return Intl.message(
      'Set profile picture',
      name: 'setProfilePicture',
      desc: '',
      args: [],
    );
  }

  /// `Scan Successfully`
  String get scanSuccessfully {
    return Intl.message(
      'Scan Successfully',
      name: 'scanSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Scan QR Code`
  String get scanQrCode {
    return Intl.message(
      'Scan QR Code',
      name: 'scanQrCode',
      desc: '',
      args: [],
    );
  }

  /// `Could not load this image`
  String get couldNotLoadThisImage {
    return Intl.message(
      'Could not load this image',
      name: 'couldNotLoadThisImage',
      desc: '',
      args: [],
    );
  }

  /// `Your booking is successful`
  String get yourBookingIsSuccessful {
    return Intl.message(
      'Your booking is successful',
      name: 'yourBookingIsSuccessful',
      desc: '',
      args: [],
    );
  }

  /// `Invitation View`
  String get invitationView {
    return Intl.message(
      'Invitation View',
      name: 'invitationView',
      desc: '',
      args: [],
    );
  }

  /// `Design Instruction For Designer`
  String get designInstructionForDesigner {
    return Intl.message(
      'Design Instruction For Designer',
      name: 'designInstructionForDesigner',
      desc: '',
      args: [],
    );
  }

  /// `No gallery available`
  String get noGalleryAvailable {
    return Intl.message(
      'No gallery available',
      name: 'noGalleryAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Photo Selection`
  String get photoSelection {
    return Intl.message(
      'Photo Selection',
      name: 'photoSelection',
      desc: '',
      args: [],
    );
  }

  /// `Event Booking`
  String get eventBooking {
    return Intl.message(
      'Event Booking',
      name: 'eventBooking',
      desc: '',
      args: [],
    );
  }

  /// `Add Event`
  String get addEvent {
    return Intl.message(
      'Add Event',
      name: 'addEvent',
      desc: '',
      args: [],
    );
  }

  /// `Already Submitted`
  String get alreadySubmitted {
    return Intl.message(
      'Already Submitted',
      name: 'alreadySubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Submitted`
  String get submitted {
    return Intl.message(
      'Submitted',
      name: 'submitted',
      desc: '',
      args: [],
    );
  }

  /// `photo selection has been unpublished`
  String get photoSelectionHasBeenUnpublished {
    return Intl.message(
      'photo selection has been unpublished',
      name: 'photoSelectionHasBeenUnpublished',
      desc: '',
      args: [],
    );
  }

  /// `Rate this image`
  String get rateThisImage {
    return Intl.message(
      'Rate this image',
      name: 'rateThisImage',
      desc: '',
      args: [],
    );
  }

  /// `Give your suggestions`
  String get giveYourSuggestions {
    return Intl.message(
      'Give your suggestions',
      name: 'giveYourSuggestions',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to exit an App`
  String get doYouWantToExitAnApp {
    return Intl.message(
      'Do you want to exit an App',
      name: 'doYouWantToExitAnApp',
      desc: '',
      args: [],
    );
  }

  /// `Close`
  String get close {
    return Intl.message(
      'Close',
      name: 'close',
      desc: '',
      args: [],
    );
  }

  /// `Saved`
  String get saved {
    return Intl.message(
      'Saved',
      name: 'saved',
      desc: '',
      args: [],
    );
  }

  /// `Unsaved Changes`
  String get unsavedChanges {
    return Intl.message(
      'Unsaved Changes',
      name: 'unsavedChanges',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to save changes?`
  String get areYouSureYouWantToSaveChanges {
    return Intl.message(
      'Are you sure you want to save changes?',
      name: 'areYouSureYouWantToSaveChanges',
      desc: '',
      args: [],
    );
  }

  /// `Discard`
  String get discard {
    return Intl.message(
      'Discard',
      name: 'discard',
      desc: '',
      args: [],
    );
  }

  /// `Save & Exit`
  String get saveExit {
    return Intl.message(
      'Save & Exit',
      name: 'saveExit',
      desc: '',
      args: [],
    );
  }

  /// `Save to Exit`
  String get saveToExit {
    return Intl.message(
      'Save to Exit',
      name: 'saveToExit',
      desc: '',
      args: [],
    );
  }

  /// `Unarchive`
  String get unarchive {
    return Intl.message(
      'Unarchive',
      name: 'unarchive',
      desc: '',
      args: [],
    );
  }

  /// `Space not available`
  String get spaceNotAvailable {
    return Intl.message(
      'Space not available',
      name: 'spaceNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to exit ?`
  String get areYouSureYouWantToExit {
    return Intl.message(
      'Are you sure you want to exit ?',
      name: 'areYouSureYouWantToExit',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get exit {
    return Intl.message(
      'Exit',
      name: 'exit',
      desc: '',
      args: [],
    );
  }

  /// `Album`
  String get album {
    return Intl.message(
      'Album',
      name: 'album',
      desc: '',
      args: [],
    );
  }

  /// `Video`
  String get video {
    return Intl.message(
      'Video',
      name: 'video',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP send to +`
  String get enterOtpSendTo {
    return Intl.message(
      'Enter OTP send to +',
      name: 'enterOtpSendTo',
      desc: '',
      args: [],
    );
  }

  /// `sec`
  String get sec {
    return Intl.message(
      'sec',
      name: 'sec',
      desc: '',
      args: [],
    );
  }

  /// `Please unarchive to open`
  String get pleaseUnarchiveToOpen {
    return Intl.message(
      'Please unarchive to open',
      name: 'pleaseUnarchiveToOpen',
      desc: '',
      args: [],
    );
  }

  /// `Barcode found!`
  String get barcodeFound {
    return Intl.message(
      'Barcode found!',
      name: 'barcodeFound',
      desc: '',
      args: [],
    );
  }

  /// `No barcode found!`
  String get noBarcodeFound {
    return Intl.message(
      'No barcode found!',
      name: 'noBarcodeFound',
      desc: '',
      args: [],
    );
  }

  /// `Enter OTP sent to `
  String get enterOtpSentTo {
    return Intl.message(
      'Enter OTP sent to ',
      name: 'enterOtpSentTo',
      desc: '',
      args: [],
    );
  }

  /// `From:`
  String get from {
    return Intl.message(
      'From:',
      name: 'from',
      desc: '',
      args: [],
    );
  }

  /// `To`
  String get to {
    return Intl.message(
      'To',
      name: 'to',
      desc: '',
      args: [],
    );
  }

  /// `At`
  String get at {
    return Intl.message(
      'At',
      name: 'at',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logOut {
    return Intl.message(
      'Log out',
      name: 'logOut',
      desc: '',
      args: [],
    );
  }

  /// `Photos`
  String get photos {
    return Intl.message(
      'Photos',
      name: 'photos',
      desc: '',
      args: [],
    );
  }

  /// `Add your name`
  String get addYourName {
    return Intl.message(
      'Add your name',
      name: 'addYourName',
      desc: '',
      args: [],
    );
  }

  /// `Packages`
  String get packages {
    return Intl.message(
      'Packages',
      name: 'packages',
      desc: '',
      args: [],
    );
  }

  /// `Scan this QR code to view the Event`
  String get scanTheQrCodeToViewTheEvent {
    return Intl.message(
      'Scan this QR code to view the Event',
      name: 'scanTheQrCodeToViewTheEvent',
      desc: '',
      args: [],
    );
  }

  /// `Close Camera`
  String get closeCamera {
    return Intl.message(
      'Close Camera',
      name: 'closeCamera',
      desc: '',
      args: [],
    );
  }

  /// `Rejected`
  String get rejected {
    return Intl.message(
      'Rejected',
      name: 'rejected',
      desc: '',
      args: [],
    );
  }

  /// `New to`
  String get newTo {
    return Intl.message(
      'New to',
      name: 'newTo',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get alreadyHaveAnAccount {
    return Intl.message(
      'Already have an account?',
      name: 'alreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `Studio's gallery with photos and videos`
  String get studiosGalleryWithPhotosAndVideos {
    return Intl.message(
      'Studio\'s gallery with photos and videos',
      name: 'studiosGalleryWithPhotosAndVideos',
      desc: '',
      args: [],
    );
  }

  /// `Event Details, Map, Calendar, Albums, Videos`
  String get eventDetailsMapCalendarAlbumsVideos {
    return Intl.message(
      'Event Details, Map, Calendar, Albums, Videos',
      name: 'eventDetailsMapCalendarAlbumsVideos',
      desc: '',
      args: [],
    );
  }

  /// `Customer booking Option`
  String get customerBookingOption {
    return Intl.message(
      'Customer booking Option',
      name: 'customerBookingOption',
      desc: '',
      args: [],
    );
  }

  /// `Username and password`
  String get usernameAndPassword {
    return Intl.message(
      'Username and password',
      name: 'usernameAndPassword',
      desc: '',
      args: [],
    );
  }

  /// `Event Packages`
  String get eventPackages {
    return Intl.message(
      'Event Packages',
      name: 'eventPackages',
      desc: '',
      args: [],
    );
  }

  /// `Studio Contact Details`
  String get studioContactDetails {
    return Intl.message(
      'Studio Contact Details',
      name: 'studioContactDetails',
      desc: '',
      args: [],
    );
  }

  /// `General App Settings`
  String get generalAppSettings {
    return Intl.message(
      'General App Settings',
      name: 'generalAppSettings',
      desc: '',
      args: [],
    );
  }

  /// `Profile page`
  String get profilePage {
    return Intl.message(
      'Profile page',
      name: 'profilePage',
      desc: '',
      args: [],
    );
  }

  /// `Event enquiry sent successfully`
  String get eventEnquirySentSuccessfully {
    return Intl.message(
      'Event enquiry sent successfully',
      name: 'eventEnquirySentSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Choose valid date`
  String get chooseValidDate {
    return Intl.message(
      'Choose valid date',
      name: 'chooseValidDate',
      desc: '',
      args: [],
    );
  }

  /// `Choose event type`
  String get chooseEventType {
    return Intl.message(
      'Choose event type',
      name: 'chooseEventType',
      desc: '',
      args: [],
    );
  }

  /// `No Detail available`
  String get noDetailAvailable {
    return Intl.message(
      'No Detail available',
      name: 'noDetailAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Internet connection required`
  String get internetConnectionRequired {
    return Intl.message(
      'Internet connection required',
      name: 'internetConnectionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Event not available`
  String get eventNotAvailable {
    return Intl.message(
      'Event not available',
      name: 'eventNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Map not opening`
  String get mapNotOpening {
    return Intl.message(
      'Map not opening',
      name: 'mapNotOpening',
      desc: '',
      args: [],
    );
  }

  /// `Permission denied`
  String get permissionDenied {
    return Intl.message(
      'Permission denied',
      name: 'permissionDenied',
      desc: '',
      args: [],
    );
  }

  /// `Invalid code`
  String get invalidCode {
    return Intl.message(
      'Invalid code',
      name: 'invalidCode',
      desc: '',
      args: [],
    );
  }

  /// `Event is unPublished`
  String get eventIsUnpublished {
    return Intl.message(
      'Event is unPublished',
      name: 'eventIsUnpublished',
      desc: '',
      args: [],
    );
  }

  /// `Event is invalid`
  String get eventIsInvalid {
    return Intl.message(
      'Event is invalid',
      name: 'eventIsInvalid',
      desc: '',
      args: [],
    );
  }

  /// `Archived Successfully`
  String get archivedSuccessfully {
    return Intl.message(
      'Archived Successfully',
      name: 'archivedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to archive`
  String get failedToArchive {
    return Intl.message(
      'Failed to archive',
      name: 'failedToArchive',
      desc: '',
      args: [],
    );
  }

  /// `try after some time`
  String get tryAfterSomeTime {
    return Intl.message(
      'try after some time',
      name: 'tryAfterSomeTime',
      desc: '',
      args: [],
    );
  }

  /// `Deleted successfully`
  String get deletedSuccessfully {
    return Intl.message(
      'Deleted successfully',
      name: 'deletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to delete`
  String get failedToDelete {
    return Intl.message(
      'Failed to delete',
      name: 'failedToDelete',
      desc: '',
      args: [],
    );
  }

  /// `Unarchived successfully`
  String get unarchivedSuccessfully {
    return Intl.message(
      'Unarchived successfully',
      name: 'unarchivedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `Failed to unarchived`
  String get failedToUnarchived {
    return Intl.message(
      'Failed to unarchived',
      name: 'failedToUnarchived',
      desc: '',
      args: [],
    );
  }

  /// `You can not view unpublished event`
  String get youCanNotViewUnpublishedEvent {
    return Intl.message(
      'You can not view unpublished event',
      name: 'youCanNotViewUnpublishedEvent',
      desc: '',
      args: [],
    );
  }

  /// `New`
  String get newKeyWord {
    return Intl.message(
      'New',
      name: 'newKeyWord',
      desc: '',
      args: [],
    );
  }

  /// `Use valid 10 digit mobile number`
  String get useValid10DigitMobileNumber {
    return Intl.message(
      'Use valid 10 digit mobile number',
      name: 'useValid10DigitMobileNumber',
      desc: '',
      args: [],
    );
  }

  /// `This event already submitted`
  String get thisEventAlreadySubmitted {
    return Intl.message(
      'This event already submitted',
      name: 'thisEventAlreadySubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Downloaded`
  String get downloaded {
    return Intl.message(
      'Downloaded',
      name: 'downloaded',
      desc: '',
      args: [],
    );
  }

  /// `Download failed`
  String get downloadFailed {
    return Intl.message(
      'Download failed',
      name: 'downloadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Storage full`
  String get storageFull {
    return Intl.message(
      'Storage full',
      name: 'storageFull',
      desc: '',
      args: [],
    );
  }

  /// `try after some times`
  String get tryAfterSomeTimes {
    return Intl.message(
      'try after some times',
      name: 'tryAfterSomeTimes',
      desc: '',
      args: [],
    );
  }

  /// `Previous decision rolled back`
  String get previousDecisionRolledBack {
    return Intl.message(
      'Previous decision rolled back',
      name: 'previousDecisionRolledBack',
      desc: '',
      args: [],
    );
  }

  /// `No more previous action`
  String get noMorePreviousAction {
    return Intl.message(
      'No more previous action',
      name: 'noMorePreviousAction',
      desc: '',
      args: [],
    );
  }

  /// `View all`
  String get viewAll {
    return Intl.message(
      'View all',
      name: 'viewAll',
      desc: '',
      args: [],
    );
  }

  /// `UNDO`
  String get undo {
    return Intl.message(
      'UNDO',
      name: 'undo',
      desc: '',
      args: [],
    );
  }

  /// `Only`
  String get only {
    return Intl.message(
      'Only',
      name: 'only',
      desc: '',
      args: [],
    );
  }

  /// `Show by Category`
  String get category {
    return Intl.message(
      'Show by Category',
      name: 'category',
      desc: '',
      args: [],
    );
  }

  /// `has shared Wedding Event album with you.Click the link`
  String get hasSharedWeddingEventAlbumWithYouclickTheLink {
    return Intl.message(
      'has shared Wedding Event album with you.Click the link',
      name: 'hasSharedWeddingEventAlbumWithYouclickTheLink',
      desc: '',
      args: [],
    );
  }

  /// `to view the album`
  String get toViewTheAlbum {
    return Intl.message(
      'to view the album',
      name: 'toViewTheAlbum',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to delete this event? This event will be permanently removed.`
  String get areYouSureYouWantToDeleteThisEventThis {
    return Intl.message(
      'Are you sure you want to delete this event? This event will be permanently removed.',
      name: 'areYouSureYouWantToDeleteThisEventThis',
      desc: '',
      args: [],
    );
  }

  /// `Photo Selection condition(s) not yet satisfied`
  String get photoSelectionConditionsNotYetSatisfied {
    return Intl.message(
      'Photo Selection condition(s) not yet satisfied',
      name: 'photoSelectionConditionsNotYetSatisfied',
      desc: '',
      args: [],
    );
  }

  /// `Archived`
  String get archived {
    return Intl.message(
      'Archived',
      name: 'archived',
      desc: '',
      args: [],
    );
  }

  /// `Share`
  String get share {
    return Intl.message(
      'Share',
      name: 'share',
      desc: '',
      args: [],
    );
  }

  /// `Just click on the button and share this event with your friends and family!`
  String get justClickOnTheButtonAndShareThisEventWith {
    return Intl.message(
      'Just click on the button and share this event with your friends and family!',
      name: 'justClickOnTheButtonAndShareThisEventWith',
      desc: '',
      args: [],
    );
  }

  /// `Note : The Photo Selection portion will not be shared`
  String get noteThePhotoSelectionPortionWillNotBeShared {
    return Intl.message(
      'Note : The Photo Selection portion will not be shared',
      name: 'noteThePhotoSelectionPortionWillNotBeShared',
      desc: '',
      args: [],
    );
  }

  /// `I have selected the photos for my album and I wish to submit them for designing. Changes cannot be made to the selected photos  after submitting.`
  String get iHaveSelectedThePhotosForMyAlbumAndI {
    return Intl.message(
      'I have selected the photos for my album and I wish to submit them for designing. Changes cannot be made to the selected photos  after submitting.',
      name: 'iHaveSelectedThePhotosForMyAlbumAndI',
      desc: '',
      args: [],
    );
  }

  /// `Set Priority`
  String get setPriority {
    return Intl.message(
      'Set Priority',
      name: 'setPriority',
      desc: '',
      args: [],
    );
  }

  /// `Unsafe Device`
  String get unsafeDevice {
    return Intl.message(
      'Unsafe Device',
      name: 'unsafeDevice',
      desc: '',
      args: [],
    );
  }

  /// `Device is rooted or may app running on emulator`
  String get deviceIsRootedOrMayAppRunningOnEmulator {
    return Intl.message(
      'Device is rooted or may app running on emulator',
      name: 'deviceIsRootedOrMayAppRunningOnEmulator',
      desc: '',
      args: [],
    );
  }

  /// `No photos Available`
  String get noPhotosAvailable {
    return Intl.message(
      'No photos Available',
      name: 'noPhotosAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Out of Service`
  String get outOfService {
    return Intl.message(
      'Out of Service',
      name: 'outOfService',
      desc: '',
      args: [],
    );
  }

  /// `Apologies for any inconvenience, but the service you are trying to access is presently unavailable. We are actively working to restore the service as quickly as possible. We regret any inconvenience this may cause.`
  String get apologiesForAnyInconvenienceButTheServiceYouAreTrying {
    return Intl.message(
      'Apologies for any inconvenience, but the service you are trying to access is presently unavailable. We are actively working to restore the service as quickly as possible. We regret any inconvenience this may cause.',
      name: 'apologiesForAnyInconvenienceButTheServiceYouAreTrying',
      desc: '',
      args: [],
    );
  }

  /// `Powered By`
  String get poweredBy {
    return Intl.message(
      'Powered By',
      name: 'poweredBy',
      desc: '',
      args: [],
    );
  }

  /// `View By Faces`
  String get viewByFaces {
    return Intl.message(
      'View By Faces',
      name: 'viewByFaces',
      desc: '',
      args: [],
    );
  }

  /// `Others`
  String get others {
    return Intl.message(
      'Others',
      name: 'others',
      desc: '',
      args: [],
    );
  }

  /// `Select By Faces`
  String get selectByFaces {
    return Intl.message(
      'Select By Faces',
      name: 'selectByFaces',
      desc: '',
      args: [],
    );
  }

  /// `Please disable developer mode to ensure that this app functions properly. To do so, go to Settings -> Developer Options and turn it off. Once you've made changes, please restart the application.`
  String get pleaseDisableDeveloperModeToEnsureThatThisAppFunctions {
    return Intl.message(
      'Please disable developer mode to ensure that this app functions properly. To do so, go to Settings -> Developer Options and turn it off. Once you\'ve made changes, please restart the application.',
      name: 'pleaseDisableDeveloperModeToEnsureThatThisAppFunctions',
      desc: '',
      args: [],
    );
  }

  /// `Turn Off Developer Mode`
  String get turnOffDeveloperMode {
    return Intl.message(
      'Turn Off Developer Mode',
      name: 'turnOffDeveloperMode',
      desc: '',
      args: [],
    );
  }

  /// `Hello! I am currently using your mobile app and would like to connect with you for a discussion.`
  String get helloIAmCurrentlyUsingYourMobileAppAndWould {
    return Intl.message(
      'Hello! I am currently using your mobile app and would like to connect with you for a discussion.',
      name: 'helloIAmCurrentlyUsingYourMobileAppAndWould',
      desc: '',
      args: [],
    );
  }

  /// `new test message`
  String get newTestMessage {
    return Intl.message(
      'new test message',
      name: 'newTestMessage',
      desc: '',
      args: [],
    );
  }

  /// `Disable screenshot`
  String get disableScreenshot {
    return Intl.message(
      'Disable screenshot',
      name: 'disableScreenshot',
      desc: '',
      args: [],
    );
  }

  /// `Enable screenshot`
  String get enableScreenshot {
    return Intl.message(
      'Enable screenshot',
      name: 'enableScreenshot',
      desc: '',
      args: [],
    );
  }

  /// `You have to login to use this AI Feature`
  String get You_have_to_login_to_use_thisAiFeature {
    return Intl.message(
      'You have to login to use this AI Feature',
      name: 'You_have_to_login_to_use_thisAiFeature',
      desc: '',
      args: [],
    );
  }

  /// `My Photos`
  String get myPhotos {
    return Intl.message(
      'My Photos',
      name: 'myPhotos',
      desc: '',
      args: [],
    );
  }

  /// `No matches found for your photo.`
  String get noMatchesFound {
    return Intl.message(
      'No matches found for your photo.',
      name: 'noMatchesFound',
      desc: '',
      args: [],
    );
  }

  /// `Profile photo has been uploaded.`
  String get profilePhotoUploaded {
    return Intl.message(
      'Profile photo has been uploaded.',
      name: 'profilePhotoUploaded',
      desc: '',
      args: [],
    );
  }

  /// `But still under process`
  String get butStillUnderProcess {
    return Intl.message(
      'But still under process',
      name: 'butStillUnderProcess',
      desc: '',
      args: [],
    );
  }

  /// `Please wait for the notification`
  String get pleaseWaitForNotification {
    return Intl.message(
      'Please wait for the notification',
      name: 'pleaseWaitForNotification',
      desc: '',
      args: [],
    );
  }

  /// `Click here to get your photos`
  String get clickHereToGetYourPhotos {
    return Intl.message(
      'Click here to get your photos',
      name: 'clickHereToGetYourPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Place your face in the camera`
  String get placeYourFaceInTheCamera {
    return Intl.message(
      'Place your face in the camera',
      name: 'placeYourFaceInTheCamera',
      desc: '',
      args: [],
    );
  }

  /// `Place your face at the center of the face indicator`
  String get placeYourFaceAtTheCenterOfTheFaceIndicator {
    return Intl.message(
      'Place your face at the center of the face indicator',
      name: 'placeYourFaceAtTheCenterOfTheFaceIndicator',
      desc: '',
      args: [],
    );
  }

  /// `Click here to upload your selfie`
  String get clickHereToUploadYourSelfie {
    return Intl.message(
      'Click here to upload your selfie',
      name: 'clickHereToUploadYourSelfie',
      desc: '',
      args: [],
    );
  }

  /// `Upload Profile Photo`
  String get uploadProfilePhoto {
    return Intl.message(
      'Upload Profile Photo',
      name: 'uploadProfilePhoto',
      desc: '',
      args: [],
    );
  }

  /// `You have to Upload Your Profile Photo to get your Photos`
  String get youHaveToUploadYourProfilePhotoToGetYourPhotos {
    return Intl.message(
      'You have to Upload Your Profile Photo to get your Photos',
      name: 'youHaveToUploadYourProfilePhotoToGetYourPhotos',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message(
      'Upload',
      name: 'upload',
      desc: '',
      args: [],
    );
  }

  /// `Retrieve`
  String get retrieve {
    return Intl.message(
      'Retrieve',
      name: 'retrieve',
      desc: '',
      args: [],
    );
  }

  /// `Enter E-mail address or Phone number`
  String get EnterEmailAddressOrPhoneNumber {
    return Intl.message(
      'Enter E-mail address or Phone number',
      name: 'EnterEmailAddressOrPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `This may be you ?`
  String get ThisMayBeYou {
    return Intl.message(
      'This may be you ?',
      name: 'ThisMayBeYou',
      desc: '',
      args: [],
    );
  }

  /// `You have reached`
  String get YouHaveReached {
    return Intl.message(
      'You have reached',
      name: 'YouHaveReached',
      desc: '',
      args: [],
    );
  }

  /// `You have exceeded`
  String get YouHaveExceeded {
    return Intl.message(
      'You have exceeded',
      name: 'YouHaveExceeded',
      desc: '',
      args: [],
    );
  }

  /// `You have selected`
  String get YouHaveSelected {
    return Intl.message(
      'You have selected',
      name: 'YouHaveSelected',
      desc: '',
      args: [],
    );
  }

  /// `photos`
  String get Photos {
    return Intl.message(
      'photos',
      name: 'Photos',
      desc: '',
      args: [],
    );
  }

  /// `out of`
  String get outOf {
    return Intl.message(
      'out of',
      name: 'outOf',
      desc: '',
      args: [],
    );
  }

  /// `Contact studio owner to get OTP`
  String get ContactStudioOwnerToGetOTP {
    return Intl.message(
      'Contact studio owner to get OTP',
      name: 'ContactStudioOwnerToGetOTP',
      desc: '',
      args: [],
    );
  }

  /// `Same Or Different Person`
  String get sameOrDifferentPerson {
    return Intl.message(
      'Same Or Different Person',
      name: 'sameOrDifferentPerson',
      desc: '',
      args: [],
    );
  }

  /// `Downloading`
  String get downloading {
    return Intl.message(
      'Downloading',
      name: 'downloading',
      desc: '',
      args: [],
    );
  }

  /// `Images`
  String get images {
    return Intl.message(
      'Images',
      name: 'images',
      desc: '',
      args: [],
    );
  }

  /// `Reviews`
  String get reviewsRatings {
    return Intl.message(
      'Reviews',
      name: 'reviewsRatings',
      desc: '',
      args: [],
    );
  }

  /// `Relatives`
  String get relatives {
    return Intl.message(
      'Relatives',
      name: 'relatives',
      desc: '',
      args: [],
    );
  }

  /// `Delete account`
  String get delete_account {
    return Intl.message(
      'Delete account',
      name: 'delete_account',
      desc: '',
      args: [],
    );
  }

  /// `Date of Birth`
  String get dob {
    return Intl.message(
      'Date of Birth',
      name: 'dob',
      desc: '',
      args: [],
    );
  }

  /// `Married on`
  String get married_on {
    return Intl.message(
      'Married on',
      name: 'married_on',
      desc: '',
      args: [],
    );
  }

  /// `Unmarried`
  String get unmarried {
    return Intl.message(
      'Unmarried',
      name: 'unmarried',
      desc: '',
      args: [],
    );
  }

  /// `Married`
  String get married {
    return Intl.message(
      'Married',
      name: 'married',
      desc: '',
      args: [],
    );
  }

  /// `Comment`
  String get comment {
    return Intl.message(
      'Comment',
      name: 'comment',
      desc: '',
      args: [],
    );
  }

  /// `Anniversary Date*`
  String get anni_date {
    return Intl.message(
      'Anniversary Date*',
      name: 'anni_date',
      desc: '',
      args: [],
    );
  }

  /// `Enter Anniversary Date`
  String get enter_anni_date {
    return Intl.message(
      'Enter Anniversary Date',
      name: 'enter_anni_date',
      desc: '',
      args: [],
    );
  }

  /// `Select Marital Status`
  String get select_marital_status {
    return Intl.message(
      'Select Marital Status',
      name: 'select_marital_status',
      desc: '',
      args: [],
    );
  }

  /// `Marital Status`
  String get marital_status {
    return Intl.message(
      'Marital Status',
      name: 'marital_status',
      desc: '',
      args: [],
    );
  }

  /// `Are You Married`
  String get are_you_married {
    return Intl.message(
      'Are You Married',
      name: 'are_you_married',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message(
      'Select',
      name: 'select',
      desc: '',
      args: [],
    );
  }

  /// `Reject all`
  String get reject_all {
    return Intl.message(
      'Reject all',
      name: 'reject_all',
      desc: '',
      args: [],
    );
  }

  /// `About Me`
  String get about_me {
    return Intl.message(
      'About Me',
      name: 'about_me',
      desc: '',
      args: [],
    );
  }

  /// `Send OTP`
  String get send_otp {
    return Intl.message(
      'Send OTP',
      name: 'send_otp',
      desc: '',
      args: [],
    );
  }

  /// `OTP Verification`
  String get otp_verification {
    return Intl.message(
      'OTP Verification',
      name: 'otp_verification',
      desc: '',
      args: [],
    );
  }

  /// `Please type the verification code sent to`
  String get otp_text {
    return Intl.message(
      'Please type the verification code sent to',
      name: 'otp_text',
      desc: '',
      args: [],
    );
  }

  /// `No Matches Found Yet`
  String get no_matches_found_yet {
    return Intl.message(
      'No Matches Found Yet',
      name: 'no_matches_found_yet',
      desc: '',
      args: [],
    );
  }

  /// `It looks like you don't have any matches right now. We'll notify you when there are photos to explore`
  String get itLooksLikeYouDonHaveAnyMatches {
    return Intl.message(
      'It looks like you don\'t have any matches right now. We\'ll notify you when there are photos to explore',
      name: 'itLooksLikeYouDonHaveAnyMatches',
      desc: '',
      args: [],
    );
  }

  /// `Check again`
  String get checkAgain {
    return Intl.message(
      'Check again',
      name: 'checkAgain',
      desc: '',
      args: [],
    );
  }

  /// `Download My Photos`
  String get downloadMyPhotos {
    return Intl.message(
      'Download My Photos',
      name: 'downloadMyPhotos',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'bn'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'gu'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'kn'),
      Locale.fromSubtags(languageCode: 'ml'),
      Locale.fromSubtags(languageCode: 'mr'),
      Locale.fromSubtags(languageCode: 'ms'),
      Locale.fromSubtags(languageCode: 'ta'),
      Locale.fromSubtags(languageCode: 'te'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
