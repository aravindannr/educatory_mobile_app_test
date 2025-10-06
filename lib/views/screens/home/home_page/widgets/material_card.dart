import 'package:educatory_mobile_application/providers/home_provider.dart';
import 'package:educatory_mobile_application/views/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MaterialCard extends StatelessWidget {
  final String title;
  final String seller;
  final String price;
  final String oldPrice;
  final double rating;
  final int reviews;
  final String badge;
  final String imageUrl;

  const MaterialCard({
    super.key,
    required this.title,
    required this.seller,
    required this.price,
    required this.oldPrice,
    required this.rating,
    required this.reviews,
    required this.badge,
    required this.imageUrl,
  });

  double _extractPrice(String priceStr) {
    final numericString = priceStr.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(numericString) ?? 0.0;
  }

  String _formatPrice(double amount) {
    final currencyMatch = RegExp(r'[^\d.]').firstMatch(price);
    final currency = currencyMatch?.group(0) ?? '₹';
    return '$currency${amount.toStringAsFixed(2)}';
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HomeProvider>(context);
    final count = provider.getItemCount(title);
    final isExpanded = provider.isCardExpanded(title);

    final pricePerUnit = _extractPrice(price);
    final totalPrice = pricePerUnit * count;

    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    imageUrl,
                    width: 70,
                    height: 70,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            seller,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Spacer(),
                          Container(
                            height: 32,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE9D5FF),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: count > 0
                                ? Row(
                                    children: [
                                      IconButton(
                                        onPressed: () =>
                                            provider.removeFromCart(title),
                                        icon: const Icon(
                                          Icons.remove,
                                          size: 14,
                                        ),
                                        padding: EdgeInsets.zero,
                                      ),
                                      Text(
                                        '$count',
                                        style: GoogleFonts.inter(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () =>
                                            provider.addToCart(title),
                                        icon: const Icon(Icons.add, size: 14),
                                        padding: EdgeInsets.zero,
                                      ),
                                    ],
                                  )
                                : ElevatedButton(
                                    onPressed: () => provider.addToCart(title),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE9D5FF),
                                      foregroundColor: const Color(0xFFE7D5FF),
                                      elevation: 0,
                                      minimumSize: const Size(40, 20),
                                      fixedSize: const Size(56, 20),
                                      padding: EdgeInsets.zero,
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                    ),
                                    child: Text(
                                      'Add',
                                      style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: Color(0xFF1E293B),
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                      Divider(color: Color(0xFFE2E8F0), thickness: 1),
                      Row(
                        children: [
                          Text(
                            price,
                            style: GoogleFonts.inter(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            oldPrice,
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              color: Color(0xFF0F172A),
                            ),
                          ),
                          const Spacer(),
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '$rating ($reviews)',
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: badge == 'Top Choice' || badge == 'Top Rated'
                              ? const Color(0xFFE9D5FF)
                              : const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: badge == 'Top Choice' || badge == 'Top Rated'
                                ? const Color(0xFF7C3AED)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isExpanded
              ? Container(
                  key: ValueKey(title),
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3E8FF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Your cart details",
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF8932EB),
                        ),
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              imageUrl,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              title,
                              style: GoogleFonts.inter(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF0F172A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF60B246),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            "$count Item${count > 1 ? 's' : ''} | ${_formatPrice(totalPrice)}",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: SizedBox(
                              height: 50,
                              child: OutlinedButton(
                                onPressed: () => provider.collapseCard(title),
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(
                                    color: Color(0xFF7C3AED),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                  ),
                                ),
                                child: Text(
                                  "Close",
                                  style: GoogleFonts.inter(
                                    color: const Color(0xFF7C3AED),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),

                          Expanded(
                            child: CustomButton(
                              onPressed: null,
                              buttonActionText: "Checkout",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
