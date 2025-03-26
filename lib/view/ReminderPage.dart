import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../const/AppBarC.dart';
import '../controller/ReminderController.dart';
import '../model/Reminder.dart';
import 'AddReminder.dart';

class Reminders extends StatelessWidget {
  static String id = "Reminders";
  final ReminderController reminderController = Get.find<ReminderController>();

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: Appbarofpage(TextPage: "Reminders"),
      body: RefreshIndicator(
        onRefresh: () => reminderController.fetchReminders(),
        child: Obx(() {
          if (reminderController.reminders.isEmpty) {
            return const Center(
              child: Text(
                'No reminders added yet!',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
            );
          }

          return ReorderableListView.builder(
            itemCount: reminderController.reminders.length,
            onReorder: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              final item = reminderController.reminders[oldIndex];
              reminderController.reminders.removeAt(oldIndex);
              reminderController.reminders.insert(newIndex, item);
            },
            itemBuilder: (context, index) {
              final reminder = reminderController.reminders[index];
              final remainingDuration =
                  reminder.time.difference(DateTime.now());
              final remainingMinutes = remainingDuration.inMinutes % 60;
              final remainingSeconds = remainingDuration.inSeconds % 60;

              return Card(
                key: ValueKey(reminder.id),
                elevation: 5,
                color: Colors.grey[200],
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  contentPadding: EdgeInsets.all(15),
                  title: Text(
                    reminder.name ?? 'No Title',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    // ${reminderController.reminders.first.name}"
                    'Amount: ${currencyFormat.format(reminder.price)}\n'
                    'Due in: ${remainingDuration.inDays} days, '
                    '${remainingDuration.inHours.remainder(24)} hours\n'
                    'At: ${DateFormat('yyyy-MM-dd HH:mm').format(reminder.time)}',
                    style: TextStyle(fontSize: 14),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFF264653)),
                    onPressed: () =>
                        reminderController.deleteReminder(reminder.id!),
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => AddReminderScreen());
          reminderController.fetchReminders();
        },
        tooltip: 'Add Reminder',
        backgroundColor: const Color(0xFF507da0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
//
// import '../const/AppBarC.dart';
// import '../const/sh/sharedreminder.dart';
// import '../controller/ReminderController.dart';
// import '../model/Reminder.dart';
// import 'AddReminder.dart';
//
// class Reminders extends StatelessWidget {
//   static String id = "Reminders";
//   final SharedPreferencesServiceReminder sharedPreferencesServiceReminder = Get.put(SharedPreferencesServiceReminder());
//
//   @override
//   Widget build(BuildContext context) {
//     final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');
//     return Scaffold(
//       appBar: Appbarofpage(TextPage: "Reminders"),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await fetchReminders();
//         },
//         child: FutureBuilder<List<Map<String, dynamic>>>(
//           future: sharedPreferencesServiceReminder.getTReminder(), // جلب التذكيرات من SharedPreferences
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(
//                 child: Text(
//                   'No reminders added yet!',
//                   style: TextStyle(color: Colors.grey, fontSize: 18),
//                 ),
//               );
//             }
//
//             var reminders = snapshot.data!;
//             return ReorderableListView.builder(
//               itemCount: reminders.length,
//               onReorder: (oldIndex, newIndex) {
//                 if (newIndex > oldIndex) newIndex--;
//                 final item = reminders[oldIndex];
//                 reminders.removeAt(oldIndex);
//                 reminders.insert(newIndex, item);
//               },
//               itemBuilder: (context, index) {
//                 final reminder = reminders[index];
//                 DateTime reminderTime = DateTime.parse(reminder['time']);
//                 final remainingDuration = reminderTime.difference(DateTime.now());
//                 final remainingMinutes = remainingDuration.inMinutes % 60;
//                 final remainingSeconds = remainingDuration.inSeconds % 60;
//                 return Card(
//                   key: ValueKey(reminder['title']),
//                   elevation: 5,
//                   color: Colors.grey[200],
//                   margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12)),
//                   child: ListTile(
//                     contentPadding: EdgeInsets.all(15),
//                     title: Text(
//                       reminder['title'] ?? 'No Title',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                     subtitle: Text(
//                       '${reminder['description'] ?? ''}\n'
//                           'Amount: ${currencyFormat.format(reminder['price'])}\n'
//                           'Due in: ${remainingDuration.inDays} days, '
//                           '${remainingDuration.inHours.remainder(24)} hours\n'
//                           'At: ${DateFormat('yyyy-MM-dd HH:mm').format(reminderTime)}',
//                       style: TextStyle(fontSize: 14),
//                     ),
//                     trailing: IconButton(
//                       icon: const Icon(Icons.delete, color: Color(0xFF264653)),
//                       onPressed: () async {
//                         // إزالة التذكير من SharedPreferences
//                         await sharedPreferencesServiceReminder.removeTodo(index);
//                       },
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           await Get.to(() => AddReminderScreen());
//         },
//         tooltip: 'Add Reminder',
//         backgroundColor: const Color(0xFF507da0),
//         child: const Icon(Icons.add, color: Colors.white),
//       ),
//     );
//   }
// }
