const Doctor = require('../models/Doctor');

exports.getAllDoctors = async (req, res) => {
  try {
    const { specialization, category } = req.query;
    const filter = {};
    
    if (specialization) filter.specialization = new RegExp(specialization, 'i');
    if (category) filter.category = category;

    const doctors = await Doctor.find(filter).sort({ rating: -1 });
    res.json({ doctors });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

exports.getDoctorById = async (req, res) => {
  try {
    const doctor = await Doctor.findById(req.params.id);
    if (!doctor) {
      return res.status(404).json({ message: 'Doctor not found' });
    }
    res.json(doctor);
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};

exports.createDoctor = async (req, res) => {
  try {
    const doctor = new Doctor(req.body);
    await doctor.save();
    res.status(201).json({ message: 'Doctor created successfully', doctor });
  } catch (error) {
    res.status(500).json({ message: 'Server error', error: error.message });
  }
};