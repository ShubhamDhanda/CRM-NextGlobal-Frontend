import 'package:crm/services/google_services.dart';
import 'package:googleapis/calendar/v3.dart';

class GoogleCalendar{
  late GoogleAPIClient? httpClient;
  late CalendarApi calendarAPI;

  Future<List<Event>> getGoogleEventsData() async {
    final List<Event> appointments = <Event>[];
    try{
      httpClient = await GoogleServices().getCredentials();
      calendarAPI = CalendarApi(httpClient!);
      final Events calEvents = await calendarAPI.events.list(
        "primary",
        timeMin: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
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
}