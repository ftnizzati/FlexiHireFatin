import 'package:flutter/material.dart';
import '../components/bottom_nav_bar.dart';
import 'job_model.dart';
import 'dummy_jobs.dart';
import '../user_role.dart';
import '../navigation_helper.dart';
import 'micro_shift.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  String searchQuery = '';
  int _selectedNavIndex = 0;

  // Filters
  String? selectedLocation;
  double? minPay;
  double? maxPay;
  DateTime? startDate;
  DateTime? endDate;

  List<String> get locations {
    final set = <String>{};
    for (final j in dummyJobs) {
      if (j.location.trim().isNotEmpty) set.add(j.location.trim());
    }
    final list = set.toList()..sort();
    return list;
  }

  String _fmt(DateTime? d) {
    if (d == null) return '—';
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
  }

  bool _matchesFilters(Job job) {
    final q = searchQuery.trim().toLowerCase();

    // 1) search by title/company
    final matchesSearch = q.isEmpty ||
        job.title.toLowerCase().contains(q) ||
        job.company.toLowerCase().contains(q);

    // 2) location
    final matchesLocation =
        selectedLocation == null || job.location == selectedLocation;
    // 3) min/max pay
    final matchesMinPay = minPay == null || job.payRate >= minPay!;
    final matchesMaxPay = maxPay == null || job.payRate <= maxPay!;
    // 4) date range (micro-shifts)
    bool matchesDate = true;
      if (startDate != null || endDate != null) {
        final s = startDate ?? DateTime.fromMillisecondsSinceEpoch(0);
        final e = endDate ?? DateTime(9999, 12, 31);

        // cover FULL day range
        final filterStart = DateTime(s.year, s.month, s.day, 0, 0, 0);
        final filterEnd = DateTime(e.year, e.month, e.day, 23, 59, 59);

        matchesDate = job.microShifts.any((shift) {
          return !(shift.end.isBefore(filterStart) ||
              shift.start.isAfter(filterEnd));
        });
      }


    return matchesSearch &&
        matchesLocation &&
        matchesMinPay &&
        matchesMaxPay &&
        matchesDate;
  }

  void _clearFilters() {
    setState(() {
      searchQuery = '';
      selectedLocation = null;
      minPay = null;
      maxPay = null;
      startDate = null;
      endDate = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredJobs = dummyJobs.where(_matchesFilters).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 251),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F1E3C),
        elevation: 0,
        title: const Text(
          'Discovery',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search jobs...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => searchQuery = value),
            ),
          ),

          // Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  value: selectedLocation,
                  isExpanded: true,
                  decoration: const InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    const DropdownMenuItem<String>(
                      value: null,
                      child: Text('All locations'),
                    ),
                    ...locations.map(
                      (loc) => DropdownMenuItem(value: loc, child: Text(loc)),
                    ),
                  ],
                  onChanged: (v) => setState(() => selectedLocation = v),
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Min Pay (RM/hr)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) =>
                            setState(() => minPay = double.tryParse(v.trim())),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Max Pay (RM/hr)',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (v) =>
                            setState(() => maxPay = double.tryParse(v.trim())),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.date_range),
                        label: Text(
                          (startDate == null && endDate == null)
                              ? 'Select date range (micro-shifts)'
                              : '${_fmt(startDate)} → ${_fmt(endDate)}',
                        ),
                        onPressed: () async {
                          final picked = await showDateRangePicker(
                            context: context,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                            initialDateRange:
                                (startDate != null && endDate != null)
                                    ? DateTimeRange(
                                        start: startDate!, end: endDate!)
                                    : null,
                          );

                          if (picked == null) return;

                          setState(() {
                            startDate = picked.start;
                            endDate = picked.end;
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      tooltip: 'Clear filters',
                      icon: const Icon(Icons.clear),
                      onPressed: _clearFilters,
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // List
          Expanded(
            child: filteredJobs.isEmpty
                ? const Center(
                    child: Text(
                      'No jobs found',
                      style: TextStyle(color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredJobs.length,
                    itemBuilder: (context, index) {
                      final job = filteredJobs[index];
                      return _JobCard(job: job);
                    },
                  ),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: _selectedNavIndex,
        role: currentUserRole,
        onTap: (index) {
          setState(() => _selectedNavIndex = index);
          NavigationHelper.navigate(context, index, currentUserRole);
        },
        onMiddleButtonPressed: () {
          NavigationHelper.handleFab(context);
        },
      ),
    );
  }
}

class _JobCard extends StatelessWidget {
  final Job job;

  const _JobCard({required this.job});

  Future<void> _applyWithMicroShift(BuildContext context) async {
    final shifts = job.microShifts;

    if (shifts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No micro-shifts available for this job.')),
      );
      return;
    }

    MicroShift? selectedShift = shifts.first;

    final result = await showDialog<MicroShift>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select a micro-shift'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return SizedBox(
                width: double.maxFinite,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: shifts.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final s = shifts[i];
                    return RadioListTile<MicroShift>(
                      value: s,
                      groupValue: selectedShift,
                      title: Text(s.toDisplay()),
                      onChanged: (v) => setState(() => selectedShift = v),
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, selectedShift),
              child: const Text('Apply'),
            ),
          ],
        );
      },
    );

    if (result == null) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Applied for ${result.toDisplay()}')),
    );
  }


  @override
  Widget build(BuildContext context) {
    final shifts = job.microShifts;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              job.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(job.company),
            const SizedBox(height: 2),
            Text('RM ${job.payRate}/hour'),
            const SizedBox(height: 2),
            Text(job.location),

            const SizedBox(height: 10),
            const Text(
              'Micro-shifts available',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 6),

            if (shifts.isEmpty)
              const Text(
                'No micro-shifts set.',
                style: TextStyle(color: Colors.grey),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: shifts.map((s) {
                return Chip(
                  label: Text(s.toDisplay()),
                  visualDensity: VisualDensity.compact,
                );
              }).toList(),
              ),

            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => _applyWithMicroShift(context),
                child: const Text('Apply'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
