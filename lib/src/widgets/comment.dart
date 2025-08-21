import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/src/widgets/loading_container.dart';
import '../models/item_models.dart';

class Comment extends StatelessWidget {
  final int itemId;
  final int depth;
  final Map<int, Future<ItemModel?>> itemMap;

  Comment({required this.itemId, required this.itemMap, required this.depth});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: itemMap[itemId],
      builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
        if (!snapshot.hasData) {
          return LoadingContainer();
        }

        final item = snapshot.data;
        final children = <Widget>[
          Card(
            margin: EdgeInsets.only(
                left: depth * 20.0, top: 8.0, bottom: 8.0, right: 16.0),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Comment Header with Username and Timestamp
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      item!.by.isNotEmpty ? item.by : 'Deleted',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: item.by.isEmpty ? Colors.grey : Colors.black,
                      ),
                    ),
                    subtitle: item.by.isNotEmpty
                        ? Text("Posted by ${item.by}")
                        : null,
                  ),
                  Divider(),
                  // Comment Text
                  Text(
                    buildItem(item), // Use the buildItem function here
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  // Action Buttons (Optional)
                ],
              ),
            ),
          ),
        ];

        // Recursively add child comments
        snapshot.data?.kids.forEach((kidId) {
          children.add(Comment(itemId: kidId, itemMap: itemMap, depth: depth + 1));
        });

        return Column(
          children: children,
        );
      },
    );
  }

  // Function to clean up HTML text
  String buildItem(ItemModel item) {
    String cleandText = item.text
        .replaceAll('&#x27;', "'") // Single quote
        .replaceAll('&#39;', "'")  // Apostrophe
        .replaceAll('&lt;', '<')   // Less than symbol
        .replaceAll('&gt;', '>')   // Greater than symbol
        .replaceAll('&amp;', '&')  // Ampersand
        .replaceAll('&quot;', '"') // Double quote
        .replaceAll('&apos;', "'"); // Apostrophe

    // Only replace opening <p> tags with a new line (\n)
    cleandText = cleandText.replaceAll(RegExp(r'<p[^>]*>'), '\n').trim();

    // Remove any other stray HTML tags
    cleandText = cleandText.replaceAll(RegExp(r'<[^>]*>'), '').trim();

    return cleandText;
  }
}
