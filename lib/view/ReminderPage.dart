import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../const/AppBarC.dart';
import '../controller/ReminderController.dart';
import 'AddReminder.dart';

class Reminders extends StatelessWidget {
  static String id = "Reminders";
  final ReminderController reminderController = Get.put(ReminderController());

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: Appbarofpage(TextPage: "Reminders"),
      body: Obx(() {
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
            final item = reminderController.reminders.removeAt(oldIndex);
            reminderController.reminders.insert(newIndex, item);
          },
          itemBuilder: (context, index) {
            final reminder = reminderController.reminders[index];
            final remainingDuration = reminder.time.difference(DateTime.now());
            final remainingMinutes = remainingDuration.inMinutes % 60;
            final remainingSeconds = remainingDuration.inSeconds % 60;

            return Card(
              key: ValueKey(reminder.id),
              elevation: 5,
              color: Colors.grey[200],
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(15),
                title: Text(
                  reminder.name,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Amount: ${currencyFormat.format(reminder.price)}\n'
                  'Due in: ${remainingDuration.inDays} days, '
                  '${remainingMinutes} minutes, '
                  '${remainingSeconds} seconds\n'
                  'At: ${DateFormat('yyyy-MM-dd HH:mm').format(reminder.time)}',
                  style: const TextStyle(color: Colors.black, fontSize: 14),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddReminderScreen()),
        tooltip: 'Add Reminder',
        backgroundColor: const Color(0xFF507da0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
