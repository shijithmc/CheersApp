import 'package:flutter/material.dart';
import '../services/admin_api_service.dart';
import '../widgets/admin_form_dialog.dart';

const _primary = Color(0xFFD35400);
const _surface = Color(0xFF3D2B24);

class ManageJobsScreen extends StatefulWidget {
  final AdminApiService api;
  const ManageJobsScreen({super.key, required this.api});
  @override
  State<ManageJobsScreen> createState() => _ManageJobsScreenState();
}

class _ManageJobsScreenState extends State<ManageJobsScreen> {
  List<Map<String, dynamic>> _jobs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try { _jobs = await widget.api.getJobs(); } catch (_) {}
    setState(() => _loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(children: [
          const Text('Jobs', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _showAddDialog,
            icon: const Icon(Icons.add, size: 18),
            label: const Text('Post Job'),
            style: ElevatedButton.styleFrom(backgroundColor: _primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
          ),
        ]),
        const SizedBox(height: 16),
        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator(color: _primary))
              : _jobs.isEmpty
                  ? const Center(child: Text('No jobs', style: TextStyle(color: Colors.white54)))
                  : SingleChildScrollView(
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(_surface),
                        columns: const [
                          DataColumn(label: Text('Title', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Company', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Salary', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Shift', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                          DataColumn(label: Text('Actions', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                        ],
                        rows: _jobs.map((j) => DataRow(cells: [
                          DataCell(Text(j['title'] ?? '', style: const TextStyle(color: Colors.white))),
                          DataCell(Text(j['company_name'] ?? '', style: const TextStyle(color: Colors.white70))),
                          DataCell(Text('₹${j['salary_min'] ?? 0} - ₹${j['salary_max'] ?? 0}', style: const TextStyle(color: Colors.white70))),
                          DataCell(Text(j['shift'] ?? '', style: const TextStyle(color: Colors.white70))),
                          DataCell(IconButton(
                            icon: const Icon(Icons.delete, color: Colors.redAccent, size: 20),
                            onPressed: () async { await widget.api.deleteJob(j['id']); _load(); },
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
    final company = TextEditingController();
    final salaryMin = TextEditingController();
    final salaryMax = TextEditingController();
    final shift = TextEditingController();
    final location = TextEditingController();
    final description = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AdminFormDialog(
        title: 'Post Job',
        fields: [
          TextField(controller: title, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Job Title')),
          const SizedBox(height: 10),
          TextField(controller: company, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Company Name')),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: TextField(controller: salaryMin, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Min Salary'), keyboardType: TextInputType.number)),
            const SizedBox(width: 10),
            Expanded(child: TextField(controller: salaryMax, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Max Salary'), keyboardType: TextInputType.number)),
          ]),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: TextField(controller: shift, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Shift'))),
            const SizedBox(width: 10),
            Expanded(child: TextField(controller: location, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Location'))),
          ]),
          const SizedBox(height: 10),
          TextField(controller: description, style: const TextStyle(color: Colors.white), decoration: adminInputDecor('Description'), maxLines: 2),
        ],
        onSave: () async {
          await widget.api.addJob({
            'title': title.text, 'company_name': company.text,
            'salary_min': int.tryParse(salaryMin.text) ?? 0,
            'salary_max': int.tryParse(salaryMax.text) ?? 0,
            'shift': shift.text, 'location': location.text, 'description': description.text,
          });
          _load();
        },
      ),
    );
  }
}
