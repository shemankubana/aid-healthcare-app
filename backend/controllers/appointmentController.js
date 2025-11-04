const Appointment = require('../models/Appointment');

exports.createAppointment = async (req, res) => {
  try {
    const appointmentData = {
      ...req.body,
      user: req.userId,
      doctor: req.body.doctorId
    };
    
    const appointment = new Appointment(appointmentData);
    await appointment.save();
    
    const populatedAppointment = await Appointment.findById(appointment._id)
      .populate('doctor')
      .populate('user', '-password');
    
    res.status(201).json({
      message: 'Appointment booked successfully',
      appointment: populatedAppointment
    });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

exports.getUserAppointments = async (req, res) => {
  try {
    const appointments = await Appointment.find({ user: req.userId })
      .populate('doctor')
      .sort({ date: -1 });
    
    res.json({ appointments });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};