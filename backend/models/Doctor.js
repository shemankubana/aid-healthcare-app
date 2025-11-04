const mongoose = require('mongoose');

const doctorSchema = new mongoose.Schema({
  name: { type: String, required: true },
  specialization: { type: String, required: true },
  hospital: { type: String, required: true },
  rating: { type: Number, default: 4.5 },
  reviewCount: { type: Number, default: 0 },
  yearsExperience: { type: Number, default: 0 },
  patientCount: { type: Number, default: 0 },
  profileImage: { type: String },
  about: { type: String },
  workingDays: [{ type: String }],
  workingHours: { type: String, default: 'Mon - Sat (08:30 AM - 5:00 PM)' },
  communicationMethods: [{ type: String }],
  category: { type: String, enum: ['Public', 'Private', 'Community', 'Specialty'], default: 'Public' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Doctor', doctorSchema);