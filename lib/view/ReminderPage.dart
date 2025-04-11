import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../const/AppBarC.dart';
import '../controller/ReminderController.dart';
import '../model/Reminder.dart';
import 'AddReminder.dart';
import 'EditReminderScreen.dart';

class Reminders extends StatelessWidget {
  static String id = "Reminders";
  final ReminderController reminderController = Get.find<ReminderController>();

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return Scaffold(
      appBar: Appbarofpage(TextPage: "Reminders"),
      body: RefreshIndicator(
        onRefresh: () async {},
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
                child: InkWell(
                  onTap: () async {
                    await Get.to(
                      () => EditReminderScreen(reminder: reminder),
                      fullscreenDialog: true,
                    );
                  },
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          reminder.name ?? 'No Title',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2e495e),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Amount: ${currencyFormat.format(reminder.price)}',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          'Collected: ${currencyFormat.format(reminder.collectedoprice)}',
                          style: TextStyle(fontSize: 16, color: Colors.black54),
                        ),
                        Text(
                          'Due in: ${remainingDuration.inDays} days, '
                          '${remainingDuration.inHours.remainder(24)} hours',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        Text(
                          'At: ${DateFormat('yyyy-MM-dd HH:mm').format(reminder.time)}',
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.edit,
                                color: Color(0xFF2e495e),
                              ),
                              onPressed: () async {
                                await Get.to(
                                  () => EditReminderScreen(reminder: reminder),
                                  fullscreenDialog: true,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: Color(0xFF264653)),
                              onPressed: () async {
                                bool success = await reminderController
                                    .deleteReminder(reminder.id!);
                                if (success) {
                                  Get.snackbar("Success",
                                      "Reminder deleted successfully",
                                      snackPosition: SnackPosition.BOTTOM);
                                } else {
                                  Get.snackbar(
                                      "Error", "Failed to delete reminder",
                                      snackPosition: SnackPosition.BOTTOM);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
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
        },
        tooltip: 'Add Reminder',
        backgroundColor: const Color(0xFF507da0),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
