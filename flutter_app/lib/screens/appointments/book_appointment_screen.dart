import 'package:flutter/material.dart';
import '../../constants/app_constants.dart';
import '../../models/doctor.dart';
import '../../models/appointment.dart';
import '../../services/api_service.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Doctor doctor;

  const BookAppointmentScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime _selectedDate = DateTime.now();
  String _selectedTime = '9:00';
  String _selectedTimeSlot = 'morning';
  final _symptomsController = TextEditingController();
  bool _isLoading = false;

  Future<void> _bookAppointment() async {
    if (_symptomsController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please describe your symptoms')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final appointment = Appointment(
      doctorId: widget.doctor.id,
      userId: 'current_user', // Get from auth
      date: _selectedDate,
      time: _selectedTime,
      timeSlot: _selectedTimeSlot,
      symptoms: _symptomsController.text,
      amount: 5100.0,
    );

    final result = await ApiService.bookAppointment(appointment);

    setState(() => _isLoading = false);

    if (result['success']) {
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Success'),
          content: const Text('Appointment booked successfully!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Booking failed')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Book Appointment', style: TextStyle(color: AppColors.black)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Date and Time', style: AppTextStyles.heading3.copyWith(fontSize: 18)),
            const SizedBox(height: 16),
            
            // Time Slot Selection
            Row(
              children: [
                Expanded(
                  child: _buildTimeSlotCard('Morning', 'morning', Icons.wb_sunny),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildTimeSlotCard('Evening', 'evening', Icons.nights_stay),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Date Picker
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            
            Text('Available Times', style: AppTextStyles.heading3.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            
            // Time Selection
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: ['4:30', '5:00', '5:30', '6:00', '6:30', '7:00', '7:30', '8:00', '8:30', '9:00']
                  .map((time) => _buildTimeChip(time))
                  .toList(),
            ),
            
            const SizedBox(height: 24),
            
            Text('Write your Problem', style: AppTextStyles.heading3.copyWith(fontSize: 18)),
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _symptomsController,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Describe your symptoms...',
                  border: OutlineInputBorder(borderSide: BorderSide.none),
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _bookAppointment,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: AppColors.white)
                    : const Text('Confirm Appointment', style: TextStyle(fontSize: 18, color: AppColors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlotCard(String label, String slot, IconData icon) {
    final isSelected = _selectedTimeSlot == slot;
    return GestureDetector(
      onTap: () => setState(() => _selectedTimeSlot = slot),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: isSelected ? AppColors.white : AppColors.black),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(color: isSelected ? AppColors.white : AppColors.black),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeChip(String time) {
    final isSelected = _selectedTime == time;
    return GestureDetector(
      onTap: () => setState(() => _selectedTime = time),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : AppColors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          time,
          style: TextStyle(color: isSelected ? AppColors.white : AppColors.black),
        ),
      ),
    );
  }
}