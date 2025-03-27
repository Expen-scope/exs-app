// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../const/AppBarC.dart';
// import '../controller/GoalController.dart';
// import '../model/Goal.dart';
//
// class EditGoalScreen extends StatefulWidget {
//   final GoalModel goal;
//
//   const EditGoalScreen({Key? key, required this.goal}) : super(key: key);
//
//   @override
//   _EditGoalScreenState createState() => _EditGoalScreenState();
// }
//
// class _EditGoalScreenState extends State<EditGoalScreen> {
//   final GoalController goalController = Get.find();
//   final TextEditingController collectedController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     collectedController.text = widget.goal.collectedmoney!.toStringAsFixed(2);
//   }
//
//   void updateGoal() {
//     double? collected =
//         double.tryParse(collectedController.text) ?? widget.goal.collectedmoney;
//     GoalModel updatedGoal = widget.goal.copyWith(collectedmoney: collected);
//     goalController.updateGoal(widget.goal.id, updatedGoal);
//     Get.back();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: Appbarofpage(TextPage: "Edit"),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Text("Goal: ${widget.goal.name}",
//                 style:
//                     const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//             const SizedBox(height: 20),
//             TextField(
//               controller: collectedController,
//               decoration: const InputDecoration(
//                 labelText: "Saved Amount",
//                 border: OutlineInputBorder(),
//               ),
//               keyboardType: TextInputType.number,
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: updateGoal,
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: const Color(0xFF507da0),
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
//               ),
//               child: const Text(
//                 "Update Goal",
//                 style: TextStyle(fontSize: 16, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
