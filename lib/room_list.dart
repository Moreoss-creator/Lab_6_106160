import 'package:flutter/material.dart';

class RoomItem {
  final String name;
  final String subtitle;
  final String bedInfo;
  final String price;
  final IconData icon;

  const RoomItem({
    required this.name,
    required this.subtitle,
    required this.bedInfo,
    required this.price,
    required this.icon,
  });
}

class RoomListPage extends StatefulWidget {
  const RoomListPage({super.key});

  @override
  State<RoomListPage> createState() => _RoomListPageState();
}

class _RoomListPageState extends State<RoomListPage> {
  int? _currentlyExpandedIndex = 1; // Double Bed Room expanded initially

  final List<RoomItem> _rooms = const [
    RoomItem(
      name: 'King Room',
      subtitle: 'King bed, complimentary breakfast, lounge access',
      bedInfo: '1 Extra-Large King Bed • 42 sqm',
      price: 'RM 480 / night',
      icon: Icons.king_bed,
    ),
    RoomItem(
      name: 'Double Bed Room',
      subtitle: 'Two single beds, panoramic view, private balcony',
      bedInfo: '2 Single Beds • 36 sqm',
      price: 'RM 360 / night',
      icon: Icons.single_bed,
    ),
    RoomItem(
      name: 'Family Room',
      subtitle: 'Two connecting bedrooms, living area, kitchenette',
      bedInfo: '1 King Bed + 2 Twin Beds • 68 sqm',
      price: 'RM 690 / night',
      icon: Icons.family_restroom,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Your Room')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _rooms.length,
        itemBuilder: (context, index) {
          final room = _rooms[index];
          final isExpanded = _currentlyExpandedIndex == index;

          return Card(
            key: ValueKey('room_card_${index}_$isExpanded'),
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ExpansionTile(
              initiallyExpanded: isExpanded,
              onExpansionChanged: (expanded) {
                setState(() {
                  _currentlyExpandedIndex = expanded ? index : null;
                });
              },
              leading: CircleAvatar(
                backgroundColor: const Color(0xFFE0F2F1),
                child: Icon(room.icon, color: const Color(0xFF00695C)),
              ),
              title: Text(
                room.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF004D40),
                ),
              ),
              subtitle: Text(
                room.subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFE0F2F1),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bed Information: ${room.bedInfo}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF004D40),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(room.subtitle),
                      const SizedBox(height: 6),
                      Text(
                        'Rate: ${room.price}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 14),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${room.name} Reserved Successfully!',
                                ),
                              ),
                            );
                          },
                          child: const Text('Select'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}