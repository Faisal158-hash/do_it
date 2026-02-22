import 'package:do_it/common/app_header.dart';
import 'package:do_it/common/app_footer.dart';
import 'package:do_it/common/temperature_widget.dart';
import 'package:do_it/common/date_time_widget.dart';
import 'package:flutter/material.dart';
import 'package:do_it/modules/orders/orders_controller.dart';
import 'package:get/get.dart';

class OrderPage extends StatefulWidget {
  final String productId;

  const OrderPage({super.key, required this.productId});

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  final controller = OrderController();
  int quantity = 1;
  final _formKey = GlobalKey<FormState>();
  final RxBool isLoading = false.obs;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;
    final contentWidth = isMobile ? width * 0.95 : 500.0;

    return Scaffold(
      appBar: const AppHeaderView(
        pageTitle: 'Orders',
        cartCount: 0,
        ordersCount: 0,
      ),
      bottomNavigationBar: const AppFooter(),
      backgroundColor: const Color(0xFFF5F5F5),
      body: Stack(
        children: [
          Center(
            child: Container(
              width: contentWidth,
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),

                      /// Name Field
                      _modernField(
                        controller: controller.nameController,
                        label: "Name",
                        icon: Icons.person_outline,
                        validator: (val) =>
                            val == null || val.isEmpty ? "Enter name" : null,
                      ),

                      const SizedBox(height: 12),

                      /// Phone Field
                      _modernField(
                        controller: controller.phoneController,
                        label: "Phone",
                        icon: Icons.phone_outlined,
                        keyboard: TextInputType.phone,
                        validator: (val) {
                          if (val == null || val.isEmpty) return "Enter phone";
                          if (val.length < 10) return "Invalid phone number";
                          return null;
                        },
                      ),

                      const SizedBox(height: 12),

                      /// Address Field
                      _modernField(
                        controller: controller.addressController,
                        label: "Address",
                        icon: Icons.location_on_outlined,
                        validator: (val) =>
                            val == null || val.isEmpty ? "Enter address" : null,
                      ),

                      const SizedBox(height: 20),

                      /// Quantity Selector
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Quantity",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      if (quantity > 1) setState(() => quantity--);
                                    },
                                    icon: const Icon(Icons.remove_circle_outline,
                                        color: Colors.green),
                                  ),
                                  Text(
                                    quantity.toString(),
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                  IconButton(
                                    onPressed: () => setState(() => quantity++),
                                    icon: const Icon(Icons.add_circle_outline,
                                        color: Colors.green),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// Place Order Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: Obx(
                          () => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2E7D32),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 6,
                              shadowColor: Colors.green.withOpacity(.5),
                            ),
                            onPressed: isLoading.value
                                ? null
                                : () async {
                                    if (!_formKey.currentState!.validate()) {
                                      return;
                                    }
                                    isLoading.value = true;
                                    final success = await controller.placeOrder(
                                        widget.productId, quantity);
                                    isLoading.value = false;

                                    if (!context.mounted) return;

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(success
                                            ? "Order placed successfully"
                                            : "Fill all fields"),
                                        backgroundColor:
                                            success ? Colors.green : Colors.red,
                                      ),
                                    );

                                    if (success) Navigator.pop(context);
                                  },
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 300),
                              child: isLoading.value
                                  ? const SizedBox(
                                      height: 22,
                                      width: 22,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Text(
                                      "Place Order",
                                      style: TextStyle(fontSize: 16),
                                    ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 120),
                    ],
                  ),
                ),
              ),
            ),
          ),

          /// Temperature Widget
          Positioned(bottom: 60, right: 20, child: TemperatureWidget()),

          /// Date & Time Widget
          const Positioned(bottom: 20, right: 20, child: DateTimeWidget()),
        ],
      ),
    );
  }

  /// ⭐ Modern Text Field
  Widget _modernField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboard = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.green),
        filled: true,
        fillColor: Colors.white.withOpacity(.9),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFF2E7D32), width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
    );
  }
}