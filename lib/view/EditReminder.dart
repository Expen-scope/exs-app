import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../const/AppBarC.dart';
import '../controller/ReminderController.dart';
import '../model/Reminder.dart';

class EditReminderScreen extends StatefulWidget {
  final ReminderModel reminder;

  EditReminderScreen({required this.reminder});

  @override
  _EditReminderScreenState createState() => _EditReminderScreenState();
}

class _EditReminderScreenState extends State<EditReminderScreen> {
  final ReminderController reminderController = Get.find();
  late TextEditingController nameController;
  late TextEditingController amountController;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.reminder.name);
    amountController =
        TextEditingController(text: widget.reminder.amount.toString());
    selectedDate = widget.reminder.reminderDate;
    selectedTime = TimeOfDay.fromDateTime(widget.reminder.reminderDate);
  }

  Future<void> updateReminder() async {
    if (nameController.text.isEmpty ||
        amountController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      Get.snackbar("Error", "Please fill all required fields");
      return;
    }

    DateTime finalDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    ReminderModel updatedReminder = ReminderModel(
      id: widget.reminder.id,
      name: nameController.text,
      amount: double.parse(amountController.text),
      reminderDate: finalDateTime,
    );

    await reminderController.updateReminder(updatedReminder);
    Get.back();
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  Future<void> pickTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime!,
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Edit Reminder"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Reminder Name"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Amount"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}"),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: pickDate,
                ),
              ],
            ),
            Row(
              children: [
                Text("Time: ${selectedTime!.format(context)}"),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: pickTime,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: updateReminder,
                child: const Text("Update Reminder"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
//trailing: Row(
//   mainAxisSize: MainAxisSize.min,
//   children: [
//     IconButton(
//       icon: const Icon(Icons.edit, color: Colors.blue),
//       onPressed: () => Get.to(() => EditReminderScreen(reminder: reminder)),
//     ),
//     IconButton(
//       icon: const Icon(Icons.delete, color: Color(0xFF264653)),
//       onPressed: () => reminderController.deleteReminder(reminder.id!),
//     ),
//   ],
// ),
