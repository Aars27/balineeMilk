import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'DistributionController.dart';
import 'DistributionModal.dart';


class MilkDistributionScreen extends StatefulWidget {
  const MilkDistributionScreen({super.key});

  @override
  State<MilkDistributionScreen> createState() => _MilkDistributionScreenState();
}

class _MilkDistributionScreenState extends State<MilkDistributionScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MilkController>(context, listen: false).loadDistribution();
    });
  }


  Widget build(BuildContext context) {
    final controller = context.watch<MilkController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.loadDistribution();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // =============================
              //      MILK INTAKE SECTION
              // =============================
              _buildSectionHeader("MCC Milk Intake", Icons.local_drink),
              _buildMilkIntakeForm(context, controller),
              const SizedBox(height: 25),

              // =============================
              //        RETURN SECTION
              // =============================
              _buildSectionHeader("Return to MCC", Icons.assignment_return),
              _buildReturnForm(context, controller),
              const SizedBox(height: 25),

              // =============================
              //   DISTRIBUTION LIST SECTION
              // =============================
              _buildSectionHeader("Today's Distribution", Icons.calendar_today),

              if (controller.loading)
                const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    )),

              if (!controller.loading &&
                  controller.distributionList.isEmpty)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "No distribution assigned.",
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                ),

              if (!controller.loading &&
                  controller.distributionList.isNotEmpty)
                _buildDistributionList(controller.todayDistribution)
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------
  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepOrange, size: 22),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------
  Widget _buildMilkIntakeForm(
      BuildContext context, MilkController controller) {
    return Column(
      children: [
        TextFormField(
          decoration: InputDecoration(
            hintText: 'Enter Challan Number',
            labelText: 'Challan Number',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: controller.updateChallanNo,
        ),
        const SizedBox(height: 12),

        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter Milk Quantity (Liters)',
            labelText: 'Milk Quantity',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: controller.updateMilkQty,
        ),
        const SizedBox(height: 16),

        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              final msg = await controller.submitIntake(context);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('submitintake')),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDCB35),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              "Record MCC Intake",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  Widget _buildReturnForm(
      BuildContext context, MilkController controller) {
    return Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            hintText: 'Enter Return Quantity',
            labelText: 'Return Quantity (Liters)',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: controller.updateReturnQty,
        ),
        const SizedBox(height: 16),

        SizedBox(
          width: 200,
          child: ElevatedButton(
            onPressed: () async {
              final msg = await controller.submitReturn(context);

              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('msgsubmitreturn')),
                );
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFDCB35),
              padding: const EdgeInsets.symmetric(vertical: 15),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text(
              "Record Return",
              style: TextStyle(color: Colors.white, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------
  Widget _buildDistributionList(List<DistributionEntry> entries) {
    return Column(
      children: entries.map((e) => _buildTile(e)).toList(),
    );
  }

  Widget _buildTile(DistributionEntry e) {
    return GestureDetector(
      onTap: (){
        _showDeliveryDialog(context,e);

      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange.shade700,
              child: Text(
                e.initials,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      e.name,
                      style:
                      const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    Text(e.time,
                        style: const TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        _tag(e.role, Colors.pink.shade100, Colors.pink),
                        const SizedBox(width: 6),
                        _tag(e.quantityPerDay, Colors.green.shade100,
                            Colors.green.shade700),
                      ],
                    )
                  ],
                )),

            Column(
              children: [
                Icon(Icons.call, color: Colors.orange.shade800),
                const SizedBox(height: 10),
                if (e.isDelivered) _deliveredTag(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _tag(String t, Color bg, Color tc) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration:
      BoxDecoration(color: bg, borderRadius: BorderRadius.circular(4)),
      child: Text(
        t,
        style: TextStyle(
            color: tc, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }

  Widget _deliveredTag() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Text(
        "Delivered",
        style: TextStyle(
            color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }




  void _showDeliveryDialog(BuildContext context, DistributionEntry entry) {
    final controller = context.read<MilkController>();

    final qtyCtrl = TextEditingController();
    String payment = "cash";

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: 20,
            right: 20,
            top: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ---------- HEADER ----------
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.orange.shade700,
                    child: Text(
                      entry.initials,
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        entry.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        entry.role,
                        style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // ---------- QTY INPUT ----------
              Text(
                "Delivered Quantity (Ltrs)",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: qtyCtrl,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Enter Quantity",
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // ---------- PAYMENT MODE ----------
              Text(
                "Payment Mode",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField(
                value: payment,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                items: const [
                  DropdownMenuItem(value: "cash", child: Text("Cash")),
                  DropdownMenuItem(value: "upi", child: Text("UPI")),
                ],
                onChanged: (value) {
                  payment = value.toString();
                },
              ),

              const SizedBox(height: 25),

              // ---------- BUTTONS ----------
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        side: BorderSide(color: Colors.grey.shade400),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (qtyCtrl.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please enter delivered quantity"),
                            ),
                          );
                          return;
                        }

                        controller.updateDeliveryQty(qtyCtrl.text);
                        controller.updatePaymentMode(payment);

                        // Get real location here
                        controller.updateLocation("26.85", "80.95");

                        String msg = await controller.submitDelivery(
                          context: context,
                          orderId: entry.orderId,
                        );

                        if (context.mounted) Navigator.pop(context);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(content: Text(msg)));

                        if (payment == "upi") {
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.shade700,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 15, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }








}
