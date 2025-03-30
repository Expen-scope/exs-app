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
  final TextEditingController nameController = TextEditingController();
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
            _buildTextField(nameController, "Name", TextInputType.text),
            SizedBox(height: hight(context) * .03),
            _buildTextField(
                valueController, "Enter Income Value", TextInputType.number),
            SizedBox(height: hight(context) * .03),
            _buildCategoryDropdown(),
            SizedBox(height: hight(context) * .03),
            _buildAddButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller, String label, TextInputType type) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: hight(Get.context!) * .007),
        child: TextField(
          controller: controller,
          keyboardType: type,
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ));
  }

  Widget _buildCategoryDropdown() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: hight(Get.context!) * .007),
      child: Obx(() => DropdownButtonFormField<String>(
            value: controller.selectedCategory.value,
            items: controller.incomeCategories
                .map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    ))
                .toList(),
            onChanged: (value) => controller.selectedCategory.value = value!,
            decoration: InputDecoration(
              labelText: "Select Category",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          )),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Padding(
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
            if (_validateInputs()) {
              Income income = Income(
                id: 0,
                name: nameController.text,
                price: double.parse(valueController.text),
                category: controller.selectedCategory.value,
                time: DateTime.now().toString(),
              );
              try {
                await controller.addIncome(income);
                await controller.fetchIncomes();
                Navigator.pop(context);
              } catch (e) {
                Get.snackbar('Error', 'Failed to add income');
              }
            }
          },
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(50),
            backgroundColor: const Color(0xFF507da0),
            shadowColor: Colors.transparent,
          ),
          child: const Text(
            "Add",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
    );
  }

  bool _validateInputs() {
    if (nameController.text.isEmpty ||
        valueController.text.isEmpty ||
        controller.selectedCategory.value.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return false;
    }
    if (double.tryParse(valueController.text) == null) {
      Get.snackbar("Error", "Invalid price value");
      return false;
    }
    return true;
  }
}
