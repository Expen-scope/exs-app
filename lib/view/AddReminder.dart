import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../const/AppBarC.dart';
import '../const/Constants.dart';
import '../controller/ReminderController.dart';
import '../model/Reminder.dart';
import 'ReminderPage.dart';

class AddReminderScreen extends StatefulWidget {
  @override
  _AddReminderScreenState createState() => _AddReminderScreenState();
}

class _AddReminderScreenState extends State<AddReminderScreen> {
  final ReminderController reminderController = Get.find();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController collectedController = TextEditingController();
  bool isLoading = false;

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  Future<void> saveReminder() async {
    setState(() => isLoading = true);

    if (nameController.text.isEmpty ||
        priceController.text.isEmpty ||
        collectedController.text.isEmpty ||
        selectedDate == null ||
        selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please fill all fields are required'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    try {
      double.parse(priceController.text);
      double.parse(collectedController.text);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Price and collected amount must be valid numbers'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
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
      name: nameController.text,
      price: double.parse(priceController.text),
      collectedoprice: double.parse(collectedController.text),
      time: finalDateTime,
      id: null,
    );

    bool success = await reminderController.addReminder(newReminder);
    if (success) {
      await Future.delayed(Duration(milliseconds: 300));
      if (mounted) {
        Navigator.pop(context);
        reminderController.fetchReminders();
      }
    }
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
    setState(() => isLoading = false);
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
      appBar: Appbarofpage(TextPage: "Add Reminder"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: hight(context) * .02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Reminder Name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: TextField(
                controller: priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Amount",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: TextField(
                controller: collectedController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "المبلغ المحصل",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .03),
            Row(
              children: [
                Text(
                    "the date: ${selectedDate != null ? DateFormat('yyyy-MM-dd').format(selectedDate!) : ''}"),
                IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: pickDate,
                ),
              ],
            ),
            Row(
              children: [
                Text(
                    "Time: ${selectedTime != null ? selectedTime!.format(context) : ''}"),
                IconButton(
                  icon: const Icon(Icons.access_time),
                  onPressed: pickTime,
                ),
              ],
            ),
            const SizedBox(height: 30),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: hight(context) * .1),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF507da0), Color(0xFF507da0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50),
                      backgroundColor: Color(0xFF507da0),
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: saveReminder,
                    child: Text(
                      "Add",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
