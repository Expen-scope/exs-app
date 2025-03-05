import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../const/AppBarC.dart';
import '../controller/ReminderController.dart';
import '../model/Reminder.dart';

class AddReminderScreen extends StatefulWidget {
  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final ReminderController reminderController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> saveReminder() async {
    if (nameController.text.isEmpty ||
        amountController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      Get.snackbar("خطأ", "يرجى ملء جميع الحقول");
      return;
    }

    DateTime finalDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    ReminderModel newReminder = ReminderModel(
      id: null, // سيتم إنشاؤه في السيرفر
      name: nameController.text,
      amount: double.parse(amountController.text),
      reminderDate: finalDateTime,
    );

    await reminderController.addReminder(newReminder);
    Get.back();
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
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
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() => selectedTime = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "إضافة تذكير جديد"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "اسم التذكير"),
            ),
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "المبلغ"),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text(
                    "التاريخ: ${selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : 'لم يتم التحديد'}"),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: pickDate,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                    "الوقت: ${selectedTime != null ? selectedTime!.format(context) : 'لم يتم التحديد'}"),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: pickTime,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: saveReminder,
                child: const Text("حفظ التذكير"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
