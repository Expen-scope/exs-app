import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../const/AppBarC.dart';
import '../const/Constants.dart';
import '../controller/IcomesContorller.dart';
import '../model/Incomes.dart';

class AddIncomes extends StatelessWidget {
  AddIncomes({super.key});

  static String id = 'addIncomes';
  final IncomesController controller = Get.find<IncomesController>();
  final TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Appbarofpage(TextPage: "Add Incomes"),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: hight(context) * .028),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: hight(context) * .02),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: TextField(
                controller: valueController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Enter Income Value",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: hight(context) * .03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: hight(context) * .007),
              child: Obx(() => DropdownButtonFormField<String>(
                    value: controller
                        .selectedIncomeType.value, // القيمة الافتراضية
                    items: controller.incomeTypes
                        .map((type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ))
                        .toList(), // تأكد من تحويل map إلى قائمة
                    onChanged: (value) {
                      controller.selectedIncomeType.value = value!;
                    },
                    decoration: InputDecoration(
                      labelText: "Select Income Type",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  )),
            ),
            SizedBox(height: hight(context) * .03),
            Padding(
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
                  onPressed: () async {
                    if (valueController.text.isNotEmpty) {
                      final value =
                          double.tryParse(valueController.text) ?? 0.0;

                      Income newIncome = Income(
                          value: value, type: controller.selectedType.value);
                      await controller.addIncome(
                          newIncome.value, newIncome.type);

                      Get.back();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50),
                    backgroundColor: Color(0xFF507da0),
                    shadowColor: Colors.transparent,
                  ),
                  child: const Text(
                    "Add",
                    style: TextStyle(fontSize: 18, color: Colors.white),
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
