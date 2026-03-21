import 'package:flutter/material.dart';
import '../services/admin_api_service.dart';
import '../widgets/admin_form_dialog.dart';

const _primary = Color(0xFFD35400);
const _surface = Color(0xFF3D2B24);

class ManageOffersScreen extends StatefulWidget {
  final AdminApiService api;
  const ManageOffersScreen({super.key, required this.api});
  @override
  State<ManageOffersScreen> createState() => _ManageOffersScreenState();
}

class _ManageOffersScreenState extends State<ManageOffersScreen> {
  List<Map<String, dynamic>> _offers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _offers = await widget.api.getOffers(); } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Text('Offers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Offer'),
            style: ElevatedButton.styleFrom(backgroundColor: _primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ]),
        const SizedBox(height: 16),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _primary))
              : _offers.isEmpty
                  ? const Center(child: Text('No offers', style: TextStyle(color: Colors.white54)))
                  : SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(_surface),
                        columns: const [
                          DataColumn(label: Text('Title', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Venue', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Discount', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Valid To', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: _offers.map((o) => DataRow(cells: [
                          DataCell(Text(o['title'] ?? '', style: const TextStyle(color: Colors.white))),
                          DataCell(Text(o['venue_name'] ?? '', style: const TextStyle(color: Colors.white70))),
                          DataCell(Text('${o['discount_percent'] ?? 0}%', style: const TextStyle(color: Colors.white70))),
                          DataCell(Text(o['valid_to'] ?? '', style: const TextStyle(color: Colors.white70))),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                            onPressed: () async { await widget.api.deleteOffer(o['id']); _load(); },
                          )),
                        ])).toList(),
                      ),
                    ),
        ),
      ],
    );
  }

  void _showAddDialog() {
    final title = TextEditingController();
    final venueName = TextEditingController();
    final discount = TextEditingController();
    final description = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AdminFormDialog(
        title: 'Add Offer',
        fields: [
          TextField(controller: title, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Offer Title')),
          const SizedBox(height: 10),
          TextField(controller: venueName, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Venue Name')),
          const SizedBox(height: 10),
          TextField(controller: discount, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Discount %'), keyboardType: TextInputType.number),
          const SizedBox(height: 10),
          TextField(controller: description, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Description'), maxLines: 2),
        ],
        onSave: () async {
          await widget.api.addOffer({
            'title': title.text, 'venue_name': venueName.text,
            'discount_percent': int.tryParse(discount.text) ?? 0, 'description': description.text,
            'valid_from': DateTime.now().toIso8601String(),
            'valid_to': DateTime.now().add(const Duration(days: 30)).toIso8601String(),
          });
          _load();
        },
      ),
    );
  }
}
