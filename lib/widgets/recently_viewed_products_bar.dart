import 'package:flutter/material.dart';

class RecentlyViewedProductsBar extends StatelessWidget {
  final List<String> productNames;
  const RecentlyViewedProductsBar({Key? key, required this.productNames}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text('Recently Viewed', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: productNames.length,
            itemBuilder: (context, i) => Card(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: Container(
                width: 100,
                alignment: Alignment.center,
                child: Text(productNames[i], textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
