library api_urls_constants;

import 'package:photomall_flutter/core/constants/studio_config_constants.dart';

///Api constants
const studioId = studioIdConfig; //"stage";
/// Production Api Url
const baseUrl = 'https://api.photomall.in/v20/studios/';

/// Locale Api Url
//const baseUrl = 'http://192.168.1.22/api/v16/studio-user/$studioId/';
const storageUrl = "https://jvtpm.sgp1  .digitaloceanspaces.com/";
const deviceRegisterUrl = 'app-register'; //device register
const screenShotRequestUrl = 'enable-screenshot';
const refreshTokenUrl = "refresh-token"; //when 401
const contactUsUrl = "contact-us"; //studio contact us
const addEventUrl = "photomall-events/add"; //download event using key
const addDemoEventUrl =
    "photomall-events/demo"; //common gallery for studio if they were not create themselves
const photoSelectionListUrl =
    "albums/pre-designed"; //only after login; list of all photo selection albums
const photoSelectionDemoUrl =
    "albums/predesigned-demo"; //common album for user if they were not logged in or if no album list available
const updateEventUrl =
    "photomall-events/show"; //event detail with update // changed to event show
const eventIndexUrl =
    "photomall-events/index"; //all events(user add events and event created for particular user)
const albumsImageUrl = "albums/image";
const loginUrl = "login-with-otp";
const logoutUrl = "logout"; //logout
const registerUrl = "register"; //register new user
const countriesUrl =
    "country-codes"; //get all country codes for register screen
const appUpdateUrl = 'app-update-status'; //check whether app need to update
const oneTimePasswordUrl = "otp"; //one time password request
const existingEventsUrl = "photomall-events/exist"; //popup for event download
const albumUpdateUrl = 'albums/update'; //event detail with update
const photoSelectionEditUrl = "albums/pre-designed/edit";
const photoSelectionConfirmUrl = "albums/confirm";
const photomallEventsUrl = "users/photomall-events/index";
const deviceEventsUrl = "device/events";
const eventTypesUrl = 'event-types'; //type of event list
const afterLoginBookMeUrl = 'photomall-events/store';
const beforeLoginBookMeUrl = "photomall-events/store";
const userShowUrl = "users/show";
const userEditUrl = "users/edit";

//new constants
const userEventIndex = "user_event_index";
const photoSelectionApiLastUpdatedAt = 'photo-selection-events';
const slackNotifications = "slack-notify";
const audioJvtFileIndex = "jvt-files/index";

const tempImageUrl = "ns-files/index";
const userProfileUrl = 'users/show';
const updateFcmTokenUrl = 'device-apps/update';
const getAndroidNotificationsUrl = 'android-notifications';
const androidNotificationsUpdateUrl = 'android-notifications/update';
const userProfileUpdateUrl = 'users/update';
const applicationConfigurationUrl = 'transporter';
const photoSelectionUpdate = 'photo-selection-images/update';
const addEmailUrl = 'email-addresses/store';
const deleteUserEmail = "email-addresses/destroy";
const deleteEventUrl = 'userable-events/delete';
const archiveUrl = 'userable-events/update';
const verifyOtpForEmailUrl = 'email-addresses/verify';
const resendOtpUrl = "resend-otp";
const filesStoreUrl = "jvt-files/store";
const eventImageStatusUrl = "event-image-statuses/index";
const photoSelectionsUpdateUrl = "photoselections/update";
const jvtFilesIndex = "jvt-files/index";
const chatNotifierURL = "chat-notify";
const imageServerStatus = "jvt-files/status";
const notificationReceived = "android-data-notifications/update";
const myPhotosUrl = "my-photos";
const folderStatus = "folder-statuses/show";
const deletionUrl = "deletions/delete";
const deletionStoreUrl = "deletions/store";
const doubtImageUrl = "my-photos/doubt-image";
const matchPersonUrl = "my-photos/match-person";
const printStoreUrl = "prints/store";
const printUsersUrl = "prints/users";
const myPhotosImagesUrl = "my-photos/images";
const userPersonsStoreUrl = "user-persons/store";
const userPersonsDeleteUrl = "user-persons/delete";
const userPersonsPhotos = "user-persons/photos";
const userPersonsImages = "user-persons/images";
const multiFaceImagesUrl = "user-persons/index";
const multiFaceImagesDeleteUrl = "jvt-file-connectors/delete";
const profileImageUpdateUrl = "jvt-file-connectors/update";
const userAbleEventsStoreUrl = "userable-events/store";
const unAuthUserEventsStoreUrl = "events/uu/store";
const unAuthUserEventsProfileStoreUrl = "uu/jvt-files/store";
const unAuthUserEventsMyPhotosUrl = "events/uu/my-photos";
const unAuthUserDeleteUrl = "events/uu/people/delete";

