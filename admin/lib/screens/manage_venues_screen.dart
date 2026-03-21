import 'package:flutter/material.dart';
import '../services/admin_api_service.dart';
import '../widgets/admin_form_dialog.dart';

const _primary = Color(0xFFD35400);
const _surface = Color(0xFF3D2B24);

class ManageVenuesScreen extends StatefulWidget {
  final AdminApiService api;
  const ManageVenuesScreen({super.key, required this.api});
  @override
  State<ManageVenuesScreen> createState() => _ManageVenuesScreenState();
}

class _ManageVenuesScreenState extends State<ManageVenuesScreen> {
  List<Map<String, dynamic>> _venues = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _venues = await widget.api.getVenues(); } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Venues', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
            const Spacer(),
            ElevatedButton.icon(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Add Venue'),
              style: ElevatedButton.styleFrom(backgroundColor: _primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _primary))
              : _venues.isEmpty
                  ? const Center(child: Text('No venues', style: TextStyle(color: Colors.white54)))
                  : SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(_surface),
                        columns: const [
                          DataColumn(label: Text('Name', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Category', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Rating', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Address', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: _venues.map((v) => DataRow(cells: [
                          DataCell(Text(v['name'] ?? '', style: const TextStyle(color: Colors.white))),
                          DataCell(Text(v['category'] ?? '', style: const TextStyle(color: Colors.white70))),
                          DataCell(Text('${v['rating'] ?? 0}', style: const TextStyle(color: Colors.white70))),
                          DataCell(Text(v['address'] ?? '', style: const TextStyle(color: Colors.white70))),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                            onPressed: () async {
                              await widget.api.deleteVenue(v['id']);
                              _load();
                            },
                          )),
                        ])).toList(),
                      ),
                    ),
        ),
      ],
    );
  }

  void _showAddDialog() {
    final name = TextEditingController();
    final category = TextEditingController();
    final rating = TextEditingController();
    final address = TextEditingController();
    final phone = TextEditingController();
    final website = TextEditingController();
    final description = TextEditingController();
    final starLevel = TextEditingController(text: '3');

    showDialog(
      context: context,
      builder: (_) => AdminFormDialog(
        title: 'Add Venue',
        fields: [
          TextField(controller: name, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Name')),
          const SizedBox(height: 10),
          TextField(controller: category, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Category')),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: TextField(controller: rating, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Rating'), keyboardType: TextInputType.number)),
            const SizedBox(width: 10),
            Expanded(child: TextField(controller: starLevel, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Star Level'), keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 10),
          TextField(controller: address, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Address')),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: TextField(controller: phone, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Phone'))),
            const SizedBox(width: 10),
            Expanded(child: TextField(controller: website, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Website'))),
          ]),
          const SizedBox(height: 10),
          TextField(controller: description, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Description'), maxLines: 2),
        ],
        onSave: () async {
          await widget.api.addVenue({
            'name': name.text, 'category': category.text,
            'rating': double.tryParse(rating.text) ?? 0, 'address': address.text,
            'phone': phone.text, 'website': website.text, 'description': description.text,
            'star_level': int.tryParse(starLevel.text) ?? 3, 'images': [],
          });
          _load();
        },
      ),
    );
  }
}
