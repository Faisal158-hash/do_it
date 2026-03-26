import 'package:do_it/modules/products/Confirm_order_page.dart';
import 'package:flutter/material.dart';
import 'package:do_it/modules/products/product_model.dart';

class ProductCardPage extends StatelessWidget {
  final Product product;
  final String categoryId;
  final Function(Product) onAddToCart;

  const ProductCardPage({
    super.key,
    required this.product,
    required this.categoryId,
    required this.onAddToCart,
  });
  /// Navigate to the View Details page
  void openViewDetailsPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ConfirmOrderPage(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Card(
        elevation: 3,
        shadowColor: colors.shadow.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(22),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => openViewDetailsPage(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// PRODUCT IMAGE
              SizedBox(
                height: 210,
                width: double.infinity,
                child: Image.network(
                  product.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      const Center(child: Icon(Icons.image_not_supported)),
                ),
              ),

              /// PRODUCT INFO
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// NAME (English)
                    Text(
                      product.nameEn,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 4),

                    /// NAME (Urdu)
                    Text(
                      product.nameUr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colors.onSurfaceVariant,
                      ),
                    ),

                    const SizedBox(height: 10),

                    /// PRICE
                    Text(
                      "Rs ${product.price}",
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 16),

                    /// VIEW DETAILS BUTTON
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 13),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => openViewDetailsPage(context),
                        child: const Text("View Details"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}