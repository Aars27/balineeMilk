import 'dart:convert';
import 'dart:io';
import 'package:balineemilk/Core/Constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Components/Savetoken/SaveToken.dart';


class SpeedometerDialog extends StatefulWidget {
  const SpeedometerDialog({super.key});

  @override
  State<SpeedometerDialog> createState() => _SpeedometerDialogState();
}

class _SpeedometerDialogState extends State<SpeedometerDialog> {
  bool isStartDone = false; // Step switching

  File? startImage;
  File? endImage;

  final startMeter = TextEditingController();
  final endMeter = TextEditingController();

  bool loading = false;

  // ------------ PICK CAMERA IMAGE -------------
  Future<void> pickStartImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => startImage = File(photo.path));
    }
  }

  Future<void> pickEndImage() async {
    final photo = await ImagePicker().pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() => endImage = File(photo.path));
    }
  }

  // ------------ UPLOAD API -------------
  Future<void> upload(String type) async {
    setState(() => loading = true);

    // Load token through TokenHelper
    String? token = await TokenHelper().getToken();  // <-- Updated

    if (token == null || token.isEmpty) {
      setState(() => loading = false);
      context.go('/loginpage');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(" Please login again")),
      );
      return;
    }

    var req = http.MultipartRequest(
      "POST",
      Uri.parse("https://balinee.pmmsapp.com/api/upload-speedometer"),
    );

    // Authorization Header
    req.headers["Authorization"] = "Bearer $token";
    req.fields['meter_no'] = type == "start" ? startMeter.text : endMeter.text;
    req.fields['type'] = type;

    req.files.add(await http.MultipartFile.fromPath(
      "image",
      type == "start" ? startImage!.path : endImage!.path,
    ));

    var res = await req.send();
    var body = await res.stream.bytesToString();

    final decode = json.decode(body);
    final msg = decode["message"] ?? "Success";

    print(body);

    setState(() => loading = false);

    if (type == "start") {
      setState(() => isStartDone = true);
    } else {
      Navigator.pop(context);
    }

    Fluttertoast.showToast(
      msg: msg,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }


  // ------------ PIN INPUT WIDGET ------------
  Widget _pinField(TextEditingController ctrl) {
    return Pinput(
      length: 5,
      controller: ctrl,
      keyboardType: TextInputType.number,
      defaultPinTheme: PinTheme(
        height: 55,
        width: 50,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.grey.shade400),
        ),
      ),
      focusedPinTheme: PinTheme(
        height: 55,
        width: 50,
        textStyle: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary, width: 2),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---------------- START SECTION ----------------
            if (!isStartDone) ...[
              Center(
                child: Text("Start Meter Reading",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),

              Text("Enter 5 Digit Meter Reading"),
              const SizedBox(height: 5),
              _pinField(startMeter),

              const SizedBox(height: 20),
              Text("Capture Start Meter Image"),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: pickStartImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: startImage == null
                      ? const Icon(Icons.camera_alt,
                      size: 60, color: Colors.red)
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(startImage!, fit: BoxFit.cover),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : () => upload("start"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit Start Meter",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],

            // ---------------- END SECTION ----------------
            if (isStartDone) ...[
              Center(
                child: Text("End Meter Reading",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 15),

              Text("Enter End Meter Reading"),
              const SizedBox(height: 5),
              _pinField(endMeter),

              const SizedBox(height: 20),
              Text("Capture End Meter Image"),
              const SizedBox(height: 10),

              GestureDetector(
                onTap: pickEndImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  alignment: Alignment.center,
                  child: endImage == null
                      ? const Icon(Icons.camera_alt,
                      size: 60, color: Colors.red)
                      : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(endImage!, fit: BoxFit.cover),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: loading ? null : () => upload("end"),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  child: loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Submit End Meter",
                      style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
