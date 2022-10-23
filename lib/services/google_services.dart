import 'dart:convert';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/drive/v3.dart';
import 'package:http/io_client.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleServices {
  late GoogleAPIClient httpClient;
  final GoogleSignIn _googleSignIn = GoogleSignIn(
      scopes: <String>[CalendarApi.calendarScope, DriveApi.driveScope]);

  Future<GoogleAPIClient?> getCredentials() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      print(googleUser);
      httpClient = GoogleAPIClient(await googleUser!.authHeaders);
      return httpClient;
    } catch (err) {
      print(err);
      return null;
    }
  }

  void logout() async {
    try {
      await _googleSignIn.signOut();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.clear();
    } catch (err) {
      print(err);
    }
  }
}

class GoogleAPIClient extends IOClient {
  Map<String, String> _headers;

  GoogleAPIClient(this._headers) : super();

  @override
  Future<IOStreamedResponse> send(BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<Response> head(Uri url, {Map<String, String>? headers}) =>
      super.head(url, headers: headers!..addAll(_headers));
}
