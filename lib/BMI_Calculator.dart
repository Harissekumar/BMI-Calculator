import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BMI extends StatefulWidget {
  const BMI({super.key});

  @override
  State<BMI> createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  TextEditingController x = TextEditingController();
  TextEditingController y = TextEditingController();
  TextEditingController z = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text("BMI Calculator", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade400, Colors.deepPurple.shade800],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildTextField(x, "Height (cm)"),
              SizedBox(height: 15),
              buildTextField(y, "Weight (kg)"),
              SizedBox(height: 15),
              buildTextField(z, "BMI", isReadOnly: true),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateBMI,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  textStyle: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text("Calculate"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(TextEditingController controller, String hintText, {bool isReadOnly = false}) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      readOnly: isReadOnly,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: Colors.white70, fontSize: 16),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
      ),
    );
  }

  void calculateBMI() {
    double height = double.tryParse(x.text) ?? 0;
    double weight = double.tryParse(y.text) ?? 0;

    if (height == 0 || weight == 0) {
      showErrorDialog("Invalid input. Please enter valid numbers.");
      return;
    }

    double heightMeters = height / 100;
    double bmi = weight / (heightMeters * heightMeters);
    z.text = bmi.toStringAsFixed(2);

    String status;
    Color color;
    IconData icon;

    if (bmi < 16) {
      status = "Underweight";
      color = Colors.redAccent;
      icon = Icons.warning_amber_rounded;
    } else if (bmi < 18.5) {
      status = "Normal Weight";
      color = Colors.green;
      icon = Icons.check_circle;
    } else if (bmi < 25) {
      status = "Overweight";
      color = Colors.blue;
      icon = Icons.info;
    } else if (bmi < 30) {
      status = "Obese";
      color = Colors.pinkAccent;
      icon = Icons.warning_amber_rounded;
    } else {
      status = "Severely Obese";
      color = Colors.deepOrange;
      icon = Icons.dangerous;
    }

    showResultDialog(status, bmi.toStringAsFixed(2), color, icon);
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Error", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
        content: Text(message, style: TextStyle(fontSize: 16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("OK")),
        ],
      ),
    );
  }

  void showResultDialog(String status, String bmi, Color color, IconData icon) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: Colors.white,
        title: Column(
          children: [
            Icon(icon, size: 50, color: color),
            SizedBox(height: 10),
            Text(status, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
        content: Text("Your BMI is $bmi", style: TextStyle(fontSize: 18)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("OK", style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
