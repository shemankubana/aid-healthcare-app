const express = require('express');
const router = express.Router();
const { createAppointment, getUserAppointments } = require('../controllers/appointmentController');
const auth = require('../middleware/auth');

router.post('/', auth, createAppointment);
router.get('/user', auth, getUserAppointments);

module.exports = router;