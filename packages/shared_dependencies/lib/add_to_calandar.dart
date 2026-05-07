import 'package:add_2_calendar/add_2_calendar.dart';

class AddToCalendar {
  static Future<bool> addEventToCalendar(
      {required String title,
      required DateTime startDate,
      required DateTime endDate,
      String? description,
      String? location}) async {
    final Event event = Event(
      title: title,
      description: description,
      location: location,
      startDate: startDate,
      endDate: endDate,
    );

    final isSaved = await Add2Calendar.addEvent2Cal(event);
    return isSaved;
  }
}
