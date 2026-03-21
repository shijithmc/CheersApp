import 'package:flutter/material.dart';
import '../services/admin_api_service.dart';
import '../widgets/admin_form_dialog.dart';

const _primary = Color(0xFFD35400);
const _surface = Color(0xFF3D2B24);

class ManageEventsScreen extends StatefulWidget {
  final AdminApiService api;
  const ManageEventsScreen({super.key, required this.api});
  @override
  State<ManageEventsScreen> createState() => _ManageEventsScreenState();
}

class _ManageEventsScreenState extends State<ManageEventsScreen> {
  List<Map<String, dynamic>> _events = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _events = await widget.api.getEvents(); } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Text('Events', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Add Event'),
            style: ElevatedButton.styleFrom(backgroundColor: _primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ]),
        const SizedBox(height: 16),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _primary))
              : _events.isEmpty
                  ? const Center(child: Text('No events', style: TextStyle(color: Colors.white54)))
                  : SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(_surface),
                        columns: const [
                          DataColumn(label: Text('Title', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Status', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Date', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Organizer', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: _events.map((e) => DataRow(cells: [
                          DataCell(Text(e['title'] ?? '', style: const TextStyle(color: Colors.white))),
                          DataCell(Text(e['event_status'] ?? '', style: const TextStyle(color: Colors.white70))),
                          DataCell(Text(e['event_date'] ?? '', style: const TextStyle(color: Colors.white70))),
                          DataCell(Text(e['organizer'] ?? '', style: const TextStyle(color: Colors.white70))),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                            onPressed: () async { await widget.api.deleteEvent(e['id']); _load(); },
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
    final organizer = TextEditingController();
    final description = TextEditingController();
    final image = TextEditingController();
    String status = 'new';

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (ctx, setDialogState) => AdminFormDialog(
          title: 'Add Event',
          fields: [
            TextField(controller: title, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Title')),
            const SizedBox(height: 10),
            TextField(controller: organizer, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Organizer')),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: status,
              items: ['live', 'new', 'join', 'coming', 'offers']
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.toUpperCase()))).toList(),
              onChanged: (v) => setDialogState(() => status = v ?? 'new'),
              decoration: adminInputDecor('Status'),
              dropdownColor: const Color(0xFF3D2B24),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 10),
            TextField(controller: image, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Image URL')),
            const SizedBox(height: 10),
            TextField(controller: description, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Description'), maxLines: 2),
          ],
          onSave: () async {
            await widget.api.addEvent({
              'title': title.text, 'organizer': organizer.text,
              'event_status': status, 'image': image.text, 'description': description.text,
              'event_date': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
            });
            _load();
          },
        ),
      ),
    );
  }
}
