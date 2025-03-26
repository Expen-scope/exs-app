// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../const/AppBarC.dart';
// import '../controller/ReminderController.dart';
// import '../model/Reminder.dart';
//
// class EditReminderScreen extends StatefulWidget {
//   final ReminderModel reminder;
//
//   EditReminderScreen({required this.reminder});
//
//   @override
//   _EditReminderScreenState createState() => _EditReminderScreenState();
// }
//
// class _EditReminderScreenState extends State<EditReminderScreen> {
//   final ReminderController reminderController = Get.find();
//   late TextEditingController nameController;
//   late TextEditingController amountController;
//   late TextEditingController collectedController;
//   late TextEditingController priceController;
//   late TextEditingController DiscriptionController;
//
//   DateTime? selectedDate;
//   TimeOfDay? selectedTime;
//
//   @override
//   void initState() {
//     super.initState();
//     nameController = TextEditingController(text: widget.reminder.title);
//     DiscriptionController =TextEditingController(text: widget.descri)
//     priceController =
//         TextEditingController(text: widget.reminder.price.toString());
//     selectedDate = widget.reminder.time;
//     selectedTime = TimeOfDay.fromDateTime(widget.reminder.time);
//     collectedController =
//         TextEditingController(text: widget.reminder.collectedoprice.toString());
//   }
//
//   Future<void> updateReminder() async {
//     if (nameController.text.isEmpty ||
//         priceController.text.isEmpty ||
//         selectedDate == null ||
//         selectedTime == null) {
//       Get.snackbar("Error", "Please fill all required fields");
//       return;
//     }
//
//     DateTime finalDateTime = DateTime(
//       selectedDate!.year,
//       selectedDate!.month,
//       selectedDate!.day,
//       selectedTime!.hour,
//       selectedTime!.minute,
//     );
//
//     ReminderModel updatedReminder = ReminderModel(
//       id: widget.reminder.id,
//       title: nameController.text,
//       price: double.parse(priceController.text),
//       collectedoprice: double.parse(collectedController.text),
//       time: finalDateTime, description: '',
//     );
//
//     bool success = await reminderController.updateReminder(updatedReminder);
//     if (success) {
//       Get.back();
//     }
//   }
//
//   Future<void> pickDate() async {
//     DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate!,
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       setState(() => selectedDate = picked);
//     }
//   }
//
//   Future<void> pickTime() async {
//     TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: selectedTime!,
//     );
//     if (picked != null) {
//       setState(() => selectedTime = picked);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Appbarofpage(TextPage: "Edit Reminder"),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             TextField(
//               controller: nameController,
//               decoration: const InputDecoration(labelText: "Reminder Name"),
//             ),
//             TextField(
//               controller: amountController,
//               keyboardType: TextInputType.number,
//               decoration: const InputDecoration(labelText: "Amount"),
//             ),
//             const SizedBox(height: 20),
//             TextField(
//               controller: collectedController,
//               keyboardType: TextInputType.number,
//               decoration: InputDecoration(labelText: "المبلغ المحصل"),
//             ),
//             const SizedBox(height: 20),
//             Row(
//               children: [
//                 Text("Date: ${DateFormat('yyyy-MM-dd').format(selectedDate!)}"),
//                 IconButton(
//                   icon: const Icon(Icons.calendar_today),
//                   onPressed: pickDate,
//                 ),
//               ],
//             ),
//             Row(
//               children: [
//                 Text("Time: ${selectedTime!.format(context)}"),
//                 IconButton(
//                   icon: const Icon(Icons.access_time),
//                   onPressed: pickTime,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 30),
//             Center(
//               child: ElevatedButton(
//                 onPressed: updateReminder,
//                 child: const Text("Update Reminder"),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// //trailing: Row(
// //   mainAxisSize: MainAxisSize.min,
// //   children: [
// //     IconButton(
// //       icon: const Icon(Icons.edit, color: Colors.blue),
// //       onPressed: () => Get.to(() => EditReminderScreen(reminder: reminder)),
// //     ),
// //     IconButton(
// //       icon: const Icon(Icons.delete, color: Color(0xFF264653)),
// //       onPressed: () => reminderController.deleteReminder(reminder.id!),
// //     ),
// //   ],
// // ),
