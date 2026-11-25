import 'package:flutter/material.dart';
import 'room_list.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  DateTime? _checkInDate;
  DateTime? _checkOutDate;

  double _adults = 2;
  double _children = 0;

  final Map<String, bool> _extras = {
    'Breakfast': true,
    'Airport Pickup': false,
    'Spa Access': false,
  };

  String _roomView = 'Sea View';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  Future<void> _pickDate({
    required bool isCheckIn,
    required FormFieldState<DateTime> fieldState,
  }) async {
    final now = DateTime.now();
    final initial = isCheckIn
        ? (_checkInDate ?? now)
        : (_checkOutDate ?? (_checkInDate ?? now).add(const Duration(days: 1)));

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: DateTime(now.year + 2),
    );

    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
      fieldState.didChange(picked);
    }
  }

  void _submitBooking() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Reservation details verified!')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const RoomListPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reservation Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hotel Banner Header
              Container(
                height: 130,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Color(0xFF004D40), Color(0xFF00897B)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                padding: const EdgeInsets.all(20),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Borneo Haven Resort',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Kuching Waterfront • Luxury Suites & Villas',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Guest & Stay Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00695C),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Guest Name Field
                      TextFormField(
                        key: const Key('guestName'),
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Guest Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Guest name is required';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 12),

                      // Email Field
                      TextFormField(
                        key: const Key('guestEmail'),
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Email is required';
                          }
                          final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Enter a valid email';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Check-in Date Picker FormField
                      FormField<DateTime>(
                        key: const Key('checkInField'),
                        initialValue: _checkInDate,
                        validator: (_) {
                          if (_checkInDate == null) {
                            return 'Check-in date is required';
                          }
                          return null;
                        },
                        builder: (fieldState) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              key: const Key('checkInButton'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade400),
                              ),
                              leading: const Icon(Icons.calendar_today),
                              title: const Text('Check-in Date'),
                              subtitle: Text(_formatDate(_checkInDate)),
                              onTap: () => _pickDate(
                                isCheckIn: true,
                                fieldState: fieldState,
                              ),
                            ),
                            if (fieldState.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: 12, top: 4),
                                child: Text(
                                  fieldState.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Check-out Date Picker FormField
                      FormField<DateTime>(
                        key: const Key('checkOutField'),
                        initialValue: _checkOutDate,
                        validator: (_) {
                          if (_checkOutDate == null) {
                            return 'Check-out date is required';
                          }
                          if (_checkInDate != null &&
                              !_checkOutDate!.isAfter(_checkInDate!)) {
                            return 'Check-out must be after check-in';
                          }
                          return null;
                        },
                        builder: (fieldState) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ListTile(
                              key: const Key('checkOutButton'),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                                side: BorderSide(color: Colors.grey.shade400),
                              ),
                              leading: const Icon(Icons.event_available),
                              title: const Text('Check-out Date'),
                              subtitle: Text(_formatDate(_checkOutDate)),
                              onTap: () => _pickDate(
                                isCheckIn: false,
                                fieldState: fieldState,
                              ),
                            ),
                            if (fieldState.hasError)
                              Padding(
                                padding: const EdgeInsets.only(left: 12, top: 4),
                                child: Text(
                                  fieldState.errorText!,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Sliders for Adults & Children
                      Text(
                        'Adults: ${_adults.round()}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Slider(
                        key: const Key('adultsSlider'),
                        value: _adults,
                        min: 1,
                        max: 6,
                        divisions: 5,
                        label: _adults.round().toString(),
                        onChanged: (val) => setState(() => _adults = val),
                      ),
                      Text(
                        'Children: ${_children.round()}',
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      Slider(
                        key: const Key('childrenSlider'),
                        value: _children,
                        min: 0,
                        max: 4,
                        divisions: 4,
                        label: _children.round().toString(),
                        onChanged: (val) => setState(() => _children = val),
                      ),
                      const Divider(height: 24),

                      // Checkboxes for Extras
                      const Text(
                        'Extras',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00695C),
                        ),
                      ),
                      ..._extras.keys.map((extra) {
                        return CheckboxListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text(extra),
                          value: _extras[extra],
                          onChanged: (val) {
                            setState(() => _extras[extra] = val ?? false);
                          },
                        );
                      }),
                      const Divider(height: 24),

                      // Radio Buttons for Room View
                      const Text(
                        'Room View',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF00695C),
                        ),
                      ),
                      RadioListTile<String>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('City View'),
                        value: 'City View',
                        groupValue: _roomView,
                        onChanged: (val) => setState(() => _roomView = val!),
                      ),
                      RadioListTile<String>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Sea View'),
                        value: 'Sea View',
                        groupValue: _roomView,
                        onChanged: (val) => setState(() => _roomView = val!),
                      ),
                      const SizedBox(height: 16),

                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: FilledButton.icon(
                          key: const Key('bookNowButton'),
                          onPressed: _submitBooking,
                          icon: const Icon(Icons.arrow_forward),
                          label: const Text('Book Now'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}