const express = require('express');
const router = express.Router();
const { getAllDoctors, getDoctorById, createDoctor } = require('../controllers/doctorController');
const auth = require('../middleware/auth');

router.get('/', auth, getAllDoctors);
router.get('/:id', auth, getDoctorById);
router.post('/', createDoctor);

module.exports = router;