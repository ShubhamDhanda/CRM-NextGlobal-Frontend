import 'package:crm/services/google_services.dart';
import 'package:googleapis/calendar/v3.dart';
import 'package:googleapis/drive/v3.dart' as drive;

class GoogleCalendar{
  late GoogleAPIClient? httpClient;
  late CalendarApi calendarAPI;
  late drive.DriveApi driveApi;

  Future<List<Event>> getGoogleEventsData() async {
    final List<Event> appointments = <Event>[];
    try{
      httpClient = await GoogleServices().getCredentials();
      calendarAPI = CalendarApi(httpClient!);
      final Events calEvents = await calendarAPI.events.list(
        "primary",
        timeMin: DateTime(DateTime.now().year-1, DateTime.now().month, DateTime.now().day)
      );

      if (calEvents?.items != null) {
        for (int i = 0; i < calEvents.items!.length; i++) {
          final Event event = calEvents.items![i];
          if (event.start == null) {
            continue;
          }
          appointments.add(event);
        }
      }
    } catch(err) {
      print(err);
    }
    return appointments;
  }

  Future<String?> createEvent(String title, String project, String comments, String description, DateTime startTime, DateTime endTime, List<String> attendees) async {
    try{
      String? res = "unconfirmed";
      Event event = Event();
      event.guestsCanSeeOtherGuests = true;
      event.reminders = EventReminders(useDefault: true);

      event.summary = "${title} : ${project} : ${comments}";
      event.description = description;

      List<EventAttendee> list = [];
      attendees.forEach((element) {
        EventAttendee att = EventAttendee(email: element);
        list.add(att);
      });
      event.attendees = list;

      EventDateTime start = EventDateTime(); //Setting start time
      start.dateTime = startTime;
      start.timeZone = startTime.timeZoneName;
      event.start = start;

      EventDateTime end = EventDateTime(); //setting end time
      end.timeZone = endTime.timeZoneName;
      end.dateTime = endTime;
      event.end = end;

      ConferenceData conferenceData = ConferenceData();
      CreateConferenceRequest conferenceRequest = CreateConferenceRequest();
      conferenceRequest.requestId = "${startTime.millisecondsSinceEpoch}-${endTime.millisecondsSinceEpoch}";
      conferenceData.createRequest = conferenceRequest;
      event.conferenceData = conferenceData;

      httpClient = await GoogleServices().getCredentials();
      calendarAPI = CalendarApi(httpClient!);
      Event value = await calendarAPI.events
          .insert(event, "primary", sendNotifications: true, sendUpdates: "all", conferenceDataVersion: 1);

      print("Event Status - ${value.status}");
      if (value.status == "confirmed") {
        print('Event added to Google Calendar');
      } else {
        print("Unable to add event to Google Calendar");
      }
      res = value.status;

      return res;
    } catch(err){
      print("Error - $err");
    }
    return "unconfirmed";
  }
  // Future<void> listGoogleDriveFiles() async {
  //   httpClient = await GoogleServices().getCredentials();
  //
  //   driveApi = drive.DriveApi(httpClient!);
  //   // q: "mimeType = 'application/vnd.google-apps.folder'";
  //   var f = await driveApi.files.list(spaces: 'drive',
  //     includeItemsFromAllDrives: true,
  //     driveId: "0APYPWGSmZLhfUk9PVA",
  //     corpora: "drive",
  //     // supportsAllDrives: true,s
  //     // q: "not 'me' in owners",s
  //     supportsTeamDrives: true,
  //       // orderBy: "createdTime",
  //       // q: "mimeType = 'application/vnd.google-apps.folder'",
  //       // q: "'TODO' in CRM",
  //   );
  //   dynamic response = await driveApi.files.get("1cuhA05QnAHgTASeD0P935tKzHCMBzra8",downloadOptions: drive.DownloadOptions.fullMedia);
  //
  //   List<int> dataStore = [];
  //   response.stream.listen((data) {
  //     print("DataReceived: ${data.length}");
  //     dataStore.insertAll(dataStore.length, data);
  //   }, onDone: () async {
  //     Directory tempDir = await getTemporaryDirectory(); //Get temp folder using Path Provider
  //     String tempPath = tempDir.path;   //Get path to that location
  //     File file = File('$tempPath/test.txt'); //Create a dummy file
  //
  //     await file.writeAsBytes(dataStore); //Write to that file from the datastore you created from the Media stream
  //     OpenFile.open('$tempPath/test.txt');
  //     String content = file.readAsStringSync(); // Read String from the file
  //     print(content); //Finally you have your text
  //     print("Task Done");
  //   }, onError: (error) {
  //     print("Some Error");
  //   });
  //
  //
  //   // print(utf8.decodeStream(response.stream).asStream());
  //   // final Stream<List<int>> mediaStream =
  //   // Future.value([104, 105]).asStream().asBroadcastStream();
  //   // var media = new drive.Media(mediaStream, 2);
  //   // var driveFile = new drive.File();
  //   // driveFile.name = "hello_world.txt";
  //   // print(media.stream);
  //   //         get(,downloadOptions: drive.DownloadOptions.fullMedia);
  //       // .list();
  //     //
  //   //   f.files?.forEach((e) {
  //   //     print(e.name);
  //   //     print(e.id);
  //   //   });
  //   // if (await launch("https://www.googleapis.com/drive/v3/files/1cuhA05QnAHgTASeD0P935tKzHCMBzra8?alt=media")) {
  //   //   await canLaunch("https://www.googleapis.com/drive/v3/files/1cuhA05QnAHgTASeD0P935tKzHCMBzra8?alt=media");
  //   // } else {
  //   //   throw 'Could not launch';
  //   // }
  //
  //   // if(f.files!=null)f.files?.forEach((f) {
  //   //   print(f);
  //   // });
  //
  //   //
  //   // final Stream<List<int>> mediaStream =
  //   // Future.value([104, 105]).asStream().asBroadcastStream();
  //   // var media = new drive.Media(mediaStream, 2);
  //   // var driveFile = new drive.File();
  //   // driveFile.name = "hello_world.txt";
  //   // final result = await driveApi.files.create(driveFile, uploadMedia: media);
  //   // print("Upload result: $result");
  //   // print("Result ${f.toJson()}");
  // }

}