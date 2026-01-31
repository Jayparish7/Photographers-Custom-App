import 'dart:io';
import 'package:http/http.dart';
import 'package:photomall_flutter/prepare_release/app_details_model.dart';
import 'package:process_run/shell.dart';

void main() async {
  stdout.write("Enter UUID: ");
  var uuid = stdin.readLineSync();
  stdout.write('\n');
  String appApplicationCode = '';
  stdout.write('Enter application code: ');
  appApplicationCode = stdin.readLineSync()!;
  stdout.write('\n');
  if (appApplicationCode.isNotEmpty) {
    await release1(uuid!.trim(), appApplicationCode);
  } else {
    stdout.write('Please enter application code');
  }
  //await _setSampleAppConfig();
  //release('', '');
  // int? pendingReleases = await _ApiHelper().requestUpdateRelease(
  //     "86a200b3-efd9-4587-bf2a-ad5b5da08c4d", 'ldvrd6x6', 75, false);
}

void main1() {
  String code = "1a67su3j1";
  if (!Directory('logos/$code').existsSync()) {
    _showLog('not exists');
    Directory('logos/$code').createSync();
    Shell().run('''
    cp -a android/app/src/main/res/mipmap-hdpi/. logos/$code/mipmap-hdpi/ 
    cp -a android/app/src/main/res/mipmap-mdpi/. logos/$code/mipmap-mdpi/ 
    cp -a android/app/src/main/res/mipmap-xhdpi/. logos/$code/mipmap-xhdpi/ 
    cp -a android/app/src/main/res/mipmap-xxhdpi/. logos/$code/mipmap-xxhdpi/ 
    cp -a android/app/src/main/res/mipmap-xxxhdpi/. logos/$code/mipmap-xxxhdpi/ 

  ''');
  } else {
    _showLog('exists');
  }
}

/*_setSampleAppConfig() async {
  await prepareBundle1("", "", AppDetailsModel.fromJson(jsonDecode(res10)));
}*/

Future<void> release1(String uuid, String applicationCode) async {
  if (!Directory('logos/$applicationCode').existsSync()) {
    AppDetailsModel? model =
        await _ApiHelper().requestAppDetails(uuid, applicationCode);
    if (model != null) {
      _showLog('not exists');
      Directory('logos/$applicationCode').createSync();
      await prepareBundle1(uuid, applicationCode, model);
    }
  } else {
    stdout.write('Given application code is already exists in project');
  }
}

Future<void> prepareBundle1(
    String uuid, String appApplicationCode, AppDetailsModel model) async {
  try {
    //model.data!.appName = 'MittaiMart';
    // model.data!.appVersion = 2;
    // model.data!.keyPassword = 'joveemartldvrd6x6';

    //var file = File('build/app/outputs/bundle/release/app-release.aab');
    if (model.data!.appName!.contains('&')) {
      model.data!.appName = model.data!.appName!.replaceAll('&', '&amp;');
      _showLog('APPNAME :: ${model.data!.appName}');
    }

    await Shell().run('''
    #flutter pub global deactivate rename
    #flutter pub global activate rename
    #flutter pub global run rename --appname "${model.data!.appName}" --target android
    #flutter pub global run rename --bundleId ${model.data!.playStoreAppId} --target android
    
    cp -a android/app/src/main/res/mipmap-hdpi/. logos/${model.data!.applicationCode}/mipmap-hdpi/ 
    cp -a android/app/src/main/res/mipmap-mdpi/. logos/${model.data!.applicationCode}/mipmap-mdpi/ 
    cp -a android/app/src/main/res/mipmap-xhdpi/. logos/${model.data!.applicationCode}/mipmap-xhdpi/ 
    cp -a android/app/src/main/res/mipmap-xxhdpi/. logos/${model.data!.applicationCode}/mipmap-xxhdpi/ 
    cp -a android/app/src/main/res/mipmap-xxxhdpi/. logos/${model.data!.applicationCode}/mipmap-xxxhdpi/ 
    
    rm -f android/app/src/main/res/drawable/notification_large_icon.png
    rm -f assets/images/splash_logo.png
    
    cp -a logos/${model.data!.applicationCode}/mipmap-mdpi/ic_launcher_logo.png android/app/src/main/res/drawable/notification_large_icon.png
    
    cp -a logos/${model.data!.applicationCode}/mipmap-xxxhdpi/ic_launcher_foreground.png assets/images/splash_logo.png
    
    cp lib/prepare_release/app_icon.xml android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_logo.xml
    cp lib/prepare_release/app_icon.xml android/app/src/main/res/mipmap-anydpi-v26/ic_launcher_logo_round.xml
    
    cp lib/prepare_release/strings.xml android/app/src/main/res/values/strings.xml
    sed -i 's/APP_NAME/${model.data!.appName}/g' android/app/src/main/res/values/strings.xml
    sed -i 's/RANDOM_URL/${model.data!.randomUrl}/g' android/app/src/main/res/values/strings.xml
    sed -i 's/APP_LINK_PATH_PREFIX/${model.data!.domain}/g' android/app/src/main/res/values/strings.xml
    
    cp lib/prepare_release/colors.xml android/app/src/main/res/values/colors.xml
    sed -i 's/APP_ICON_BACKGROUND_COLOR/${model.data!.appIconBackground}/g' android/app/src/main/res/values/colors.xml
    
    cp lib/prepare_release/store_id_config_template.dart lib/core/constants/studio_config_constants.dart
    sed -i 's/STORE_ID/${model.data!.applicationCode}/g' lib/core/constants/studio_config_constants.dart
    sed -i 's/VERSION_CODE/${model.data!.appVersion}/g' lib/core/constants/studio_config_constants.dart
    sed -i 's/APP_NAME/${model.data!.appName}/g' lib/core/constants/studio_config_constants.dart
    sed -i 's/COLOR_CODE/${model.data!.appIconBackground}/g' lib/core/constants/studio_config_constants.dart
    
    cp -a firebase_projects/${model.data!.firebaseProjectId}.json android/app/google-services.json
    
    cp lib/prepare_release/key.properties android/key.properties
    sed -i "s|STORE_PASSWORD|${model.data!.storePassword}|g" android/key.properties
    sed -i "s|KEY_PASSWORD|${model.data!.keyPassword}|g" android/key.properties
    sed -i "s|KEY_ALIAS|${model.data!.keyAliasName}|g" android/key.properties
    sed -i "s|APPLICATION_CODE|${model.data!.applicationCode}|g" android/key.properties
    
   ''');

    //return;
    //var appId = 'com.vmksmittai.apps.buyer';
    _showLog('upload :: STEP 1 ${model.data!.appName}');
    stdout.write('$appApplicationCode added to project');
  } on Exception catch (e, s) {
    _showLog('EXCEPTION :: ${e.toString()} :: $s');
  }
}

class _ApiHelper {
  String staging = 'stage.photomall.in';
  String production = 'photomall.in';

  Future<AppDetailsModel?> requestAppDetails(
      String uuid, String applicationCode) async {
    String url = 'https://$production/app-config/$uuid/$applicationCode';
    //return appDetailsModelFromJson(res13);
    var response = await get(Uri.parse(url));
    if (response.statusCode == 200) {
      _showLog(response.body);
      AppDetailsModel appDetailsModel =
          appDetailsModelFromJson(response.body.replaceAll('\n', '\\n'));
      if (_ableToSetConfig(appDetailsModel)) {
        return appDetailsModel;
      } else {
        return null;
      }
    } else {
      _showLog('Error => ${response.body}');
      return null;
    }
  }

  _ableToSetConfig(AppDetailsModel appDetailsModel) {
    if (appDetailsModel.data!.applicationCode.isNullOrEmpty() ||
        appDetailsModel.data!.appName.isNullOrEmpty() ||
        appDetailsModel.data!.playStoreAppId.isNullOrEmpty() ||
        // appDetailsModel.data!.truecallerKey.isNullOrEmpty() ||
        appDetailsModel.data!.keyAliasName.isNullOrEmpty() ||
        appDetailsModel.data!.storePassword.isNullOrEmpty() ||
        appDetailsModel.data!.keyPassword.isNullOrEmpty() ||
        appDetailsModel.data!.appVersion.isNullOrEmpty() ||
        appDetailsModel.data!.domain.isNullOrEmpty() ||
        appDetailsModel.data!.randomUrl.isNullOrEmpty() ||
        appDetailsModel.data!.firebaseProjectId.isNullOrEmpty() ||
        appDetailsModel.data!.appIconBackground.isNullOrEmpty()) {
      var nullValues = [];
      if (appDetailsModel.data!.applicationCode.isNullOrEmpty())
        nullValues.add('applicationCode');
      if (appDetailsModel.data!.appName.isNullOrEmpty())
        nullValues.add('appName');
      if (appDetailsModel.data!.playStoreAppId.isNullOrEmpty())
        nullValues.add('playStoreAppId');
      //   if (appDetailsModel.data!.truecallerKey.isNullOrEmpty())
      nullValues.add('truecallerKey');
      if (appDetailsModel.data!.keyAliasName.isNullOrEmpty())
        nullValues.add('keyAliasName');
      if (appDetailsModel.data!.storePassword.isNullOrEmpty())
        nullValues.add('storePassword');
      if (appDetailsModel.data!.keyPassword.isNullOrEmpty())
        nullValues.add('keyPassword');
      if (appDetailsModel.data!.appVersion.isNullOrEmpty())
        nullValues.add('appVersion');
      if (appDetailsModel.data!.domain.isNullOrEmpty())
        nullValues.add('domain');
      if (appDetailsModel.data!.randomUrl.isNullOrEmpty())
        nullValues.add('randomUrl');
      if (appDetailsModel.data!.firebaseProjectId.isNullOrEmpty())
        nullValues.add('firebaseProjectId');
      if (appDetailsModel.data!.appIconBackground.isNullOrEmpty())
        nullValues.add('appIconBackground');
      stdout.write(
          'Fill values in admin api and try again : ${nullValues.join(',')}');
      return false;
    } else {
      return true;
    }
  }
}

extension on String? {
  isNullOrEmpty() {
    if (this == null) return true;
    if (this!.isEmpty) return true;
    return false;
  }
}

var res = '''
{"data":{"application_code":"1dzcrVKp","app_name":"Demo Store","play_store_app_id":"com.joveemart.demostore.apps.buyer","firebase_app_id":"1:1036510068424:android:4dbb5ff9f679eba2b52ffd","key_alias_name":"demostore","store_password":"joveemart1dzcrVKp","key_password":"joveemart1dzcrVKp","release_mode":2,"app_version":4,"app_version_id":76}}
''';

_showLog(String message) {
  //print(message);
}

var res7 =
    '''{ "data": { "application_code": "2ysuq7w3", "app_name": "PTML Studio", "play_store_app_id": "in.photomall.app.madurai.ptmlstudio", "firebase_project_id": "259227810926", "truecaller_key": "gZKNB956a332ced0c40f6b5723cdf98f64ff7", "key_alias_name": "demostudio", "store_password": "photomalldemostudio2ysuq7w3", "key_password": "photomalldemostudio2ysuq7w3", "release_mode": 2, "app_version": "240", "app_version_id": 3181, "domain": "demostudio.yaljo.in", "random_url": "demo", "app_icon_background": "05144f", "play_console_api_credential": { "type": "service_account", "auth_uri": "https://accounts.google.com/o/oauth2/auth", "client_id": "109258884363442684493", "token_uri": "https://oauth2.googleapis.com/token", "project_id": "api-7755554659922227092-840063", "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCZuXbzg0lD7qSv\nMLrJKm9V3gE5AsVs2YmKEhbqCgbdw69pefK99sDD5Ojdho5liDIxONqR2XEniOyt\n0bWRxgYi6cee9C1+n/RtD0kE8Ehlu+SnQj990+Wc0u1Mx4xQQsjSm4HDLwzz/icJ\nWM+TbmoC07hnhlRzUZ8xghP8nkjeocaDjT+mYVyUqqY6rJwOJ6L9SD7WKOGb1qwU\nFtyBq4lhpiL8NOTUW9FyIfwBlk1hHtUM2bWZTrwpfXgrEsQN6aunXbzZIM2yu9rU\nN8+JOwuVrt5xMr2j7rM45B2L48ThhSeiVx+06UVOWDtpef498vlb/yby2002uVfX\nqgjgyneVAgMBAAECggEAAZ0V16JjO2vRFJVouIaSAZzPLXnznQCIbP6HeTBxCnAs\nxLIrgX0cqZrkKyew7WN7q/dQK3XnEYaHEFaZIBrQh4hKQcc+hicaHBT1NQv+EyBz\nJBBSB93hwuxx4juC2sGubB3P6GNhQu2LQBHwOiZPfGv3zaOIjLB7APM/9JoZmdwS\njwddihkFu8btKM4df0P1PNIu7Z4vxZxfrV7FXvJ/GVWSP6mlBK2VKd0XZ+bAhApX\nhqm5Q+ciCBz0SEcKsX1Ao0ihzhLKx51hjFYu3ji4VfZoJAu4XT5gGjuh93I21gZJ\nRv+tHnRvYyVw8w08bXz0ogAI4qEU/6qdQivjLbKNsQKBgQDJRYyjkTYVcKQqkSS+\ny/iQ3gyeFVPd2GTT/xGnafykL52+34VmLx9gqOFf3iGwRr/c6Y2f1vYbbOnl7hZ7\n27DXPAFGzLi1JfiHumUqcpYxhBke9RE2ofwJJ7SaD/pgeMeGYaWupqP29QOpWVL6\ngcIGXjiVyAzhSvFHL9xeTd8eyQKBgQDDhivHNeTEwbJMcsBy348h/kaKJ11jh6ME\ninJ4oghZY9yU4Wxj+Jvzh9kwnyg5gIwol8mt95KEydGmWnnVip+Y3WYageJlUsiU\ng9jytqC14JzOfn7Ho5pkuweD06rgG3OLCApB7qwt8XaO9K21FCn+QGDHTfVXahrQ\nAsnXYll8bQKBgQCUZKnHYuWsMwtmsvKTlZEjRgOpffICi2vzfYjHlPYHG3BDbUtO\nRons2zanVwAhllgZCT04zuVO3SMqOjrrgNNGLWCHkaLRNDij4YJ7JFamFU3sLCVP\n0WggW9zlBcjE3efFpTLhrM0Q5B6Z+liah5bE2S0BCaitZnKz2I6yHNnXOQKBgQCj\ne3LtTT2r2j0HuMb7Bbv6803tw/5M8yM178DI5spOW7Ya8eUcLcnPtR2/jsQmWDpY\n0pl6EU/8IXdfPbUy/IZ3XV86+LDggXhe3WMvhc4YZOcXrSK6MCwu30boTbpJSgqx\nDBbvi+2BOK0l2KXJi0OVaCTDYIasAXbLyBkWMxCZfQKBgBEzKQQo2JVHhzoQQ9Jv\n7E/qxG+M7o22A1/IPgBaCJfpJ1mrO0JusDuwmhn2amHgN+GsaWmtmQ4WKkrMzzjT\n4d2J3VwmTPqXRYY57PAnXhBuSor3xVRd6DY2C7ajm6T0qEHTU+6vgoEU8wxOmpNW\n/RS8SUDi16w30hTEKRimX/8i\n-----END PRIVATE KEY-----\n", "client_email": "photomall@api-7755554659922227092-840063.iam.gserviceaccount.com", "private_key_id": "3bfff2ceee69b24ada2aadddfe604ad1091bb16b", "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/photomall%40api-7755554659922227092-840063.iam.gserviceaccount.com", "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs" } } }''';

var res6 = '''
{
    "data": {
        "application_code": "2ysuq7w3",
        "app_name": "PTML Studio",
        "play_store_app_id": "in.photomall.app.madurai.ptmlstudio",
        "firebase_project_id": "259227810926",
        "truecaller_key": "gZKNB956a332ced0c40f6b5723cdf98f64ff7",
        "key_alias_name": "demostudio",
        "store_password": "photomalldemostudio2ysuq7w3",
        "key_password": "photomalldemostudio2ysuq7w3",
        "release_mode": 2,
        "app_version": "239",
        "app_version_id": 3181,
        "domain": "demostudio.yaljo.in",
        "random_url": "demo",
        "app_icon_background": "05144f",
        "play_console_api_credential": {
            "type": "service_account",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "client_id": "109258884363442684493",
            "token_uri": "https://oauth2.googleapis.com/token",
            "project_id": "api-7755554659922227092-840063",
            "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCZuXbzg0lD7qSv\nMLrJKm9V3gE5AsVs2YmKEhbqCgbdw69pefK99sDD5Ojdho5liDIxONqR2XEniOyt\n0bWRxgYi6cee9C1+n/RtD0kE8Ehlu+SnQj990+Wc0u1Mx4xQQsjSm4HDLwzz/icJ\nWM+TbmoC07hnhlRzUZ8xghP8nkjeocaDjT+mYVyUqqY6rJwOJ6L9SD7WKOGb1qwU\nFtyBq4lhpiL8NOTUW9FyIfwBlk1hHtUM2bWZTrwpfXgrEsQN6aunXbzZIM2yu9rU\nN8+JOwuVrt5xMr2j7rM45B2L48ThhSeiVx+06UVOWDtpef498vlb/yby2002uVfX\nqgjgyneVAgMBAAECggEAAZ0V16JjO2vRFJVouIaSAZzPLXnznQCIbP6HeTBxCnAs\nxLIrgX0cqZrkKyew7WN7q/dQK3XnEYaHEFaZIBrQh4hKQcc+hicaHBT1NQv+EyBz\nJBBSB93hwuxx4juC2sGubB3P6GNhQu2LQBHwOiZPfGv3zaOIjLB7APM/9JoZmdwS\njwddihkFu8btKM4df0P1PNIu7Z4vxZxfrV7FXvJ/GVWSP6mlBK2VKd0XZ+bAhApX\nhqm5Q+ciCBz0SEcKsX1Ao0ihzhLKx51hjFYu3ji4VfZoJAu4XT5gGjuh93I21gZJ\nRv+tHnRvYyVw8w08bXz0ogAI4qEU/6qdQivjLbKNsQKBgQDJRYyjkTYVcKQqkSS+\ny/iQ3gyeFVPd2GTT/xGnafykL52+34VmLx9gqOFf3iGwRr/c6Y2f1vYbbOnl7hZ7\n27DXPAFGzLi1JfiHumUqcpYxhBke9RE2ofwJJ7SaD/pgeMeGYaWupqP29QOpWVL6\ngcIGXjiVyAzhSvFHL9xeTd8eyQKBgQDDhivHNeTEwbJMcsBy348h/kaKJ11jh6ME\ninJ4oghZY9yU4Wxj+Jvzh9kwnyg5gIwol8mt95KEydGmWnnVip+Y3WYageJlUsiU\ng9jytqC14JzOfn7Ho5pkuweD06rgG3OLCApB7qwt8XaO9K21FCn+QGDHTfVXahrQ\nAsnXYll8bQKBgQCUZKnHYuWsMwtmsvKTlZEjRgOpffICi2vzfYjHlPYHG3BDbUtO\nRons2zanVwAhllgZCT04zuVO3SMqOjrrgNNGLWCHkaLRNDij4YJ7JFamFU3sLCVP\n0WggW9zlBcjE3efFpTLhrM0Q5B6Z+liah5bE2S0BCaitZnKz2I6yHNnXOQKBgQCj\ne3LtTT2r2j0HuMb7Bbv6803tw/5M8yM178DI5spOW7Ya8eUcLcnPtR2/jsQmWDpY\n0pl6EU/8IXdfPbUy/IZ3XV86+LDggXhe3WMvhc4YZOcXrSK6MCwu30boTbpJSgqx\nDBbvi+2BOK0l2KXJi0OVaCTDYIasAXbLyBkWMxCZfQKBgBEzKQQo2JVHhzoQQ9Jv\n7E/qxG+M7o22A1/IPgBaCJfpJ1mrO0JusDuwmhn2amHgN+GsaWmtmQ4WKkrMzzjT\n4d2J3VwmTPqXRYY57PAnXhBuSor3xVRd6DY2C7ajm6T0qEHTU+6vgoEU8wxOmpNW\n/RS8SUDi16w30hTEKRimX/8i\n-----END PRIVATE KEY-----\n",
            "client_email": "photomall@api-7755554659922227092-840063.iam.gserviceaccount.com",
            "private_key_id": "3bfff2ceee69b24ada2aadddfe604ad1091bb16b",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/photomall%40api-7755554659922227092-840063.iam.gserviceaccount.com",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs"
        }
    }
}
''';

var res5 = '''
{"data":{"application_code":"2ysuq7w3","app_name":"PTML Studio","play_store_app_id":"in.photomall.app.madurai.ptmlstudio","firebase_project_id":"259227810926","truecaller_key":"gZKNB956a332ced0c40f6b5723cdf98f64ff7","key_alias_name":"demostudio","store_password":"photomalldemostudio2ysuq7w3","key_password":"photomalldemostudio2ysuq7w3","release_mode":2,"app_version":"240","app_version_id":3181,"domain":"demostudio.yaljo.in","random_url":"demo","app_icon_background":"05144f","play_console_api_credential":{"type":"service_account","auth_uri":"https:\/\/accounts.google.com\/o\/oauth2\/auth","client_id":"109258884363442684493","token_uri":"https:\/\/oauth2.googleapis.com\/token","project_id":"api-7755554659922227092-840063","private_key":"-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCZuXbzg0lD7qSv\nMLrJKm9V3gE5AsVs2YmKEhbqCgbdw69pefK99sDD5Ojdho5liDIxONqR2XEniOyt\n0bWRxgYi6cee9C1+n\/RtD0kE8Ehlu+SnQj990+Wc0u1Mx4xQQsjSm4HDLwzz\/icJ\nWM+TbmoC07hnhlRzUZ8xghP8nkjeocaDjT+mYVyUqqY6rJwOJ6L9SD7WKOGb1qwU\nFtyBq4lhpiL8NOTUW9FyIfwBlk1hHtUM2bWZTrwpfXgrEsQN6aunXbzZIM2yu9rU\nN8+JOwuVrt5xMr2j7rM45B2L48ThhSeiVx+06UVOWDtpef498vlb\/yby2002uVfX\nqgjgyneVAgMBAAECggEAAZ0V16JjO2vRFJVouIaSAZzPLXnznQCIbP6HeTBxCnAs\nxLIrgX0cqZrkKyew7WN7q\/dQK3XnEYaHEFaZIBrQh4hKQcc+hicaHBT1NQv+EyBz\nJBBSB93hwuxx4juC2sGubB3P6GNhQu2LQBHwOiZPfGv3zaOIjLB7APM\/9JoZmdwS\njwddihkFu8btKM4df0P1PNIu7Z4vxZxfrV7FXvJ\/GVWSP6mlBK2VKd0XZ+bAhApX\nhqm5Q+ciCBz0SEcKsX1Ao0ihzhLKx51hjFYu3ji4VfZoJAu4XT5gGjuh93I21gZJ\nRv+tHnRvYyVw8w08bXz0ogAI4qEU\/6qdQivjLbKNsQKBgQDJRYyjkTYVcKQqkSS+\ny\/iQ3gyeFVPd2GTT\/xGnafykL52+34VmLx9gqOFf3iGwRr\/c6Y2f1vYbbOnl7hZ7\n27DXPAFGzLi1JfiHumUqcpYxhBke9RE2ofwJJ7SaD\/pgeMeGYaWupqP29QOpWVL6\ngcIGXjiVyAzhSvFHL9xeTd8eyQKBgQDDhivHNeTEwbJMcsBy348h\/kaKJ11jh6ME\ninJ4oghZY9yU4Wxj+Jvzh9kwnyg5gIwol8mt95KEydGmWnnVip+Y3WYageJlUsiU\ng9jytqC14JzOfn7Ho5pkuweD06rgG3OLCApB7qwt8XaO9K21FCn+QGDHTfVXahrQ\nAsnXYll8bQKBgQCUZKnHYuWsMwtmsvKTlZEjRgOpffICi2vzfYjHlPYHG3BDbUtO\nRons2zanVwAhllgZCT04zuVO3SMqOjrrgNNGLWCHkaLRNDij4YJ7JFamFU3sLCVP\n0WggW9zlBcjE3efFpTLhrM0Q5B6Z+liah5bE2S0BCaitZnKz2I6yHNnXOQKBgQCj\ne3LtTT2r2j0HuMb7Bbv6803tw\/5M8yM178DI5spOW7Ya8eUcLcnPtR2\/jsQmWDpY\n0pl6EU\/8IXdfPbUy\/IZ3XV86+LDggXhe3WMvhc4YZOcXrSK6MCwu30boTbpJSgqx\nDBbvi+2BOK0l2KXJi0OVaCTDYIasAXbLyBkWMxCZfQKBgBEzKQQo2JVHhzoQQ9Jv\n7E\/qxG+M7o22A1\/IPgBaCJfpJ1mrO0JusDuwmhn2amHgN+GsaWmtmQ4WKkrMzzjT\n4d2J3VwmTPqXRYY57PAnXhBuSor3xVRd6DY2C7ajm6T0qEHTU+6vgoEU8wxOmpNW\n\/RS8SUDi16w30hTEKRimX\/8i\n-----END PRIVATE KEY-----\n","client_email":"photomall@api-7755554659922227092-840063.iam.gserviceaccount.com","private_key_id":"3bfff2ceee69b24ada2aadddfe604ad1091bb16b","client_x509_cert_url":"https:\/\/www.googleapis.com\/robot\/v1\/metadata\/x509\/photomall%40api-7755554659922227092-840063.iam.gserviceaccount.com","auth_provider_x509_cert_url":"https:\/\/www.googleapis.com\/oauth2\/v1\/certs"}}}
''';

var res4 = '''
{
    "data": {
        "application_code": "1gt7alje",
        "app_name": "Dream Studio",
        "play_store_app_id": "in.photomall.app.dreamstudio",
        "firebase_project_id": "259227810926",
        "truecaller_key": "abcdefghgZKNB956a332ced0c40f6b5723cdf98f64ff7",
        "key_alias_name": "dreamstudio",
        "store_password": "photomalldreamstudio2ysuq7w3",
        "key_password": "photomalldreamstudio2ysuq7w3",
        "release_mode": 2,
        "app_version": "240",
        "app_version_id": 2539,
        "domain": "dreamstudio.yaljo.in",
        "random_url": "dres",
        "app_icon_background": "000000",
        "play_console_api_credential": {
            "type": "service_account",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "client_id": "109258884363442684493",
            "token_uri": "https://oauth2.googleapis.com/token",
            "project_id": "api-7755554659922227092-840063",
            "private_key": "-----BEGIN PRIVATE KEY-----MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCZuXbzg0lD7qSvMLrJKm9V3gE5AsVs2YmKEhbqCgbdw69pefK99sDD5Ojdho5liDIxONqR2XEniOyt0bWRxgYi6cee9C1+n/RtD0kE8Ehlu+SnQj990+Wc0u1Mx4xQQsjSm4HDLwzz/icJWM+TbmoC07hnhlRzUZ8xghP8nkjeocaDjT+mYVyUqqY6rJwOJ6L9SD7WKOGb1qwUFtyBq4lhpiL8NOTUW9FyIfwBlk1hHtUM2bWZTrwpfXgrEsQN6aunXbzZIM2yu9rUN8+JOwuVrt5xMr2j7rM45B2L48ThhSeiVx+06UVOWDtpef498vlb/yby2002uVfXqgjgyneVAgMBAAECggEAAZ0V16JjO2vRFJVouIaSAZzPLXnznQCIbP6HeTBxCnAsxLIrgX0cqZrkKyew7WN7q/dQK3XnEYaHEFaZIBrQh4hKQcc+hicaHBT1NQv+EyBzJBBSB93hwuxx4juC2sGubB3P6GNhQu2LQBHwOiZPfGv3zaOIjLB7APM/9JoZmdwSjwddihkFu8btKM4df0P1PNIu7Z4vxZxfrV7FXvJ/GVWSP6mlBK2VKd0XZ+bAhApXhqm5Q+ciCBz0SEcKsX1Ao0ihzhLKx51hjFYu3ji4VfZoJAu4XT5gGjuh93I21gZJRv+tHnRvYyVw8w08bXz0ogAI4qEU/6qdQivjLbKNsQKBgQDJRYyjkTYVcKQqkSS+y/iQ3gyeFVPd2GTT/xGnafykL52+34VmLx9gqOFf3iGwRr/c6Y2f1vYbbOnl7hZ727DXPAFGzLi1JfiHumUqcpYxhBke9RE2ofwJJ7SaD/pgeMeGYaWupqP29QOpWVL6gcIGXjiVyAzhSvFHL9xeTd8eyQKBgQDDhivHNeTEwbJMcsBy348h/kaKJ11jh6MEinJ4oghZY9yU4Wxj+Jvzh9kwnyg5gIwol8mt95KEydGmWnnVip+Y3WYageJlUsiUg9jytqC14JzOfn7Ho5pkuweD06rgG3OLCApB7qwt8XaO9K21FCn+QGDHTfVXahrQAsnXYll8bQKBgQCUZKnHYuWsMwtmsvKTlZEjRgOpffICi2vzfYjHlPYHG3BDbUtORons2zanVwAhllgZCT04zuVO3SMqOjrrgNNGLWCHkaLRNDij4YJ7JFamFU3sLCVP0WggW9zlBcjE3efFpTLhrM0Q5B6Z+liah5bE2S0BCaitZnKz2I6yHNnXOQKBgQCje3LtTT2r2j0HuMb7Bbv6803tw/5M8yM178DI5spOW7Ya8eUcLcnPtR2/jsQmWDpY0pl6EU/8IXdfPbUy/IZ3XV86+LDggXhe3WMvhc4YZOcXrSK6MCwu30boTbpJSgqxDBbvi+2BOK0l2KXJi0OVaCTDYIasAXbLyBkWMxCZfQKBgBEzKQQo2JVHhzoQQ9Jv7E/qxG+M7o22A1/IPgBaCJfpJ1mrO0JusDuwmhn2amHgN+GsaWmtmQ4WKkrMzzjT4d2J3VwmTPqXRYY57PAnXhBuSor3xVRd6DY2C7ajm6T0qEHTU+6vgoEU8wxOmpNW/RS8SUDi16w30hTEKRimX/8i-----END PRIVATE KEY-----",
            "client_email": "photomall@api-7755554659922227092-840063.iam.gserviceaccount.com",
            "private_key_id": "3bfff2ceee69b24ada2aadddfe604ad1091bb16b",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/photomall%40api-7755554659922227092-840063.iam.gserviceaccount.com",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs"
        }
    }
}
''';

var res3 = '''
{
    "data": {
        "application_code": "2ysuq7w3",
        "app_name": "PTML Studio",
        "play_store_app_id": "in.photomall.app.madurai.ptmlstudio",
        "firebase_project_id": "259227810926",
        "truecaller_key": "gZKNB956a332ced0c40f6b5723cdf98f64ff7",
        "key_alias_name": "demostudio",
        "store_password": "photomalldemostudio2ysuq7w3",
        "key_password": "photomalldemostudio2ysuq7w3",
        "release_mode": 2,
        "app_version": "240",
        "app_version_id": 2539,
        "domain": "demostudio.yaljo.in",
        "random_url": "demo",
        "app_icon_background": "05144f",
        "play_console_api_credential": {
            "type": "service_account",
            "auth_uri": "https://accounts.google.com/o/oauth2/auth",
            "client_id": "109258884363442684493",
            "token_uri": "https://oauth2.googleapis.com/token",
            "project_id": "api-7755554659922227092-840063",
            "private_key": "-----BEGIN PRIVATE KEY-----MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCZuXbzg0lD7qSvMLrJKm9V3gE5AsVs2YmKEhbqCgbdw69pefK99sDD5Ojdho5liDIxONqR2XEniOyt0bWRxgYi6cee9C1+n/RtD0kE8Ehlu+SnQj990+Wc0u1Mx4xQQsjSm4HDLwzz/icJWM+TbmoC07hnhlRzUZ8xghP8nkjeocaDjT+mYVyUqqY6rJwOJ6L9SD7WKOGb1qwUFtyBq4lhpiL8NOTUW9FyIfwBlk1hHtUM2bWZTrwpfXgrEsQN6aunXbzZIM2yu9rUN8+JOwuVrt5xMr2j7rM45B2L48ThhSeiVx+06UVOWDtpef498vlb/yby2002uVfXqgjgyneVAgMBAAECggEAAZ0V16JjO2vRFJVouIaSAZzPLXnznQCIbP6HeTBxCnAsxLIrgX0cqZrkKyew7WN7q/dQK3XnEYaHEFaZIBrQh4hKQcc+hicaHBT1NQv+EyBzJBBSB93hwuxx4juC2sGubB3P6GNhQu2LQBHwOiZPfGv3zaOIjLB7APM/9JoZmdwSjwddihkFu8btKM4df0P1PNIu7Z4vxZxfrV7FXvJ/GVWSP6mlBK2VKd0XZ+bAhApXhqm5Q+ciCBz0SEcKsX1Ao0ihzhLKx51hjFYu3ji4VfZoJAu4XT5gGjuh93I21gZJRv+tHnRvYyVw8w08bXz0ogAI4qEU/6qdQivjLbKNsQKBgQDJRYyjkTYVcKQqkSS+y/iQ3gyeFVPd2GTT/xGnafykL52+34VmLx9gqOFf3iGwRr/c6Y2f1vYbbOnl7hZ727DXPAFGzLi1JfiHumUqcpYxhBke9RE2ofwJJ7SaD/pgeMeGYaWupqP29QOpWVL6gcIGXjiVyAzhSvFHL9xeTd8eyQKBgQDDhivHNeTEwbJMcsBy348h/kaKJ11jh6MEinJ4oghZY9yU4Wxj+Jvzh9kwnyg5gIwol8mt95KEydGmWnnVip+Y3WYageJlUsiUg9jytqC14JzOfn7Ho5pkuweD06rgG3OLCApB7qwt8XaO9K21FCn+QGDHTfVXahrQAsnXYll8bQKBgQCUZKnHYuWsMwtmsvKTlZEjRgOpffICi2vzfYjHlPYHG3BDbUtORons2zanVwAhllgZCT04zuVO3SMqOjrrgNNGLWCHkaLRNDij4YJ7JFamFU3sLCVP0WggW9zlBcjE3efFpTLhrM0Q5B6Z+liah5bE2S0BCaitZnKz2I6yHNnXOQKBgQCje3LtTT2r2j0HuMb7Bbv6803tw/5M8yM178DI5spOW7Ya8eUcLcnPtR2/jsQmWDpY0pl6EU/8IXdfPbUy/IZ3XV86+LDggXhe3WMvhc4YZOcXrSK6MCwu30boTbpJSgqxDBbvi+2BOK0l2KXJi0OVaCTDYIasAXbLyBkWMxCZfQKBgBEzKQQo2JVHhzoQQ9Jv7E/qxG+M7o22A1/IPgBaCJfpJ1mrO0JusDuwmhn2amHgN+GsaWmtmQ4WKkrMzzjT4d2J3VwmTPqXRYY57PAnXhBuSor3xVRd6DY2C7ajm6T0qEHTU+6vgoEU8wxOmpNW/RS8SUDi16w30hTEKRimX/8i-----END PRIVATE KEY-----",
            "client_email": "photomall@api-7755554659922227092-840063.iam.gserviceaccount.com",
            "private_key_id": "3bfff2ceee69b24ada2aadddfe604ad1091bb16b",
            "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/photomall%40api-7755554659922227092-840063.iam.gserviceaccount.com",
            "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs"
        }
    }
}
''';

var res1 = '''
{
   "data": {
       "application_code": "stage",
       "app_name": "Mg Photography",
       "play_store_app_id": "in.amythicreations.app",
       "firebase_app_id": "",
       "firebase_project_id":"259227810926",
       "truecaller_key": "",
       "key_alias_name": "photomallamythicreationsx5pk3l8v",
       "store_password": "photomallamythicreationsx5pk3l8v",
       "key_password": "photomallamythicreationsx5pk3l8v",
       "release_mode": 2,
       "app_version": "179",
       "app_version_id": 161,
       "hosted_domain": null,
       "random_url": "1iz"
   }
}
''';

var res2 = '''
{
   "data": {
       "application_code": "x5pk3l8v",
       "app_name": null,
       "play_store_app_id": "in.amythicreations.app",
       "firebase_app_id": "",
       "truecaller_key": "",
       "key_alias_name": "photomallamythicreationsx5pk3l8v",
       "store_password": "photomallamythicreationsx5pk3l8v",
       "key_password": "photomallamythicreationsx5pk3l8v",
       "release_mode": 2,
       "app_version": "179",
       "app_version_id": 161,
       "hosted_domain": null,
       "random_url": "1iz"
   }
}
''';

var bigArtRes = '''
  {
   "data": {
       "application_code": "5i3zicfu",
       "app_name": "BigArt Furnitures",
       "play_store_app_id": "com.bigartfurnitures.apps.buyer",
       "key_alias_name": "bigartfurniture",
       "store_password": "joveemart5i3zicfu",
       "key_password": "joveemart5i3zicfu",
       "release_mode": 2,
       "app_version": 1,
       "app_version_id": 73
   }
}
  ''';

var res10 = '''
{"data":{"application_code":"6xsr5p1e","app_name":"SkyHigh Photography","play_store_app_id":"in.photomall.app.skyhigh","firebase_project_id":"259227810926","truecaller_key":"TawjP59f09c9312e143a5b42be2f6f0590cdd","key_alias_name":"skyhigh","store_password":"photomallskyhigh6xsr5p1e","key_password":"photomallskyhigh6xsr5p1e","release_mode":2,"app_version":"21","app_version_id":12633,"domain":"skyhighhub.com","random_url":"skyh","app_icon_background":"ffffff"}}
''';

var res13 = '''
{
    "data": {
        "application_code": "0gbsc98c",
        "app_name": "Amythi",
        "play_store_app_id": "in.photomall.photo.album.Amythi",
        "firebase_project_id": "259227810926",
        "truecaller_key": "259227810926",
        "key_alias_name": "photomallamythicreationsx5pk3l8q",
        "store_password": "photomallamythicreationsx5pk3l8q",
        "key_password": "photomallamythicreationsx5pk3l8q",
        "release_mode": 1,
        "app_version": "105",
        "domain": "Amythi",
        "random_url": "Amythi",
        "app_icon_background": "000000"
    }
}
''';
