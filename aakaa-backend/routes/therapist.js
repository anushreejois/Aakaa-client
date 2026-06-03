import express from 'express';
import auth from '../middleware/auth.js';
import Therapist from '../models/Therapist.js';
import SessionBooking from '../models/SessionBooking.js';
import User from '../models/User.js';
import Notification from '../models/Notification.js';

const router = express.Router();

// @route   GET /api/therapist/profile
// @desc    Get current logged-in therapist profile (availability/specialties)
// @access  Private
router.get('/profile', auth, async (req, res) => {
  try {
    const therapist = await Therapist.findOne({ userId: req.userId }).populate('userId', 'fullName email avatarUrl');
    if (!therapist) {
      return res.status(404).json({
        status: 'error',
        message: 'Therapist profile not found.'
      });
    }

    res.json({
      status: 'success',
      therapist
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error retrieving therapist profile.',
      error: err.message
    });
  }
});

// @route   PUT /api/therapist/profile
// @desc    Update therapist profile details (name, bio, specialties, rates)
// @access  Private
router.put('/profile', auth, async (req, res) => {
  try {
    const { fullName, avatarUrl, bio, experienceYears, specialties, videoRate, audioRate, chatRate } = req.body;

    let therapist = await Therapist.findOne({ userId: req.userId });
    if (!therapist) {
      return res.status(404).json({
        status: 'error',
        message: 'Therapist profile not found.'
      });
    }

    // Update User core fields if fullName or avatarUrl provided
    if (fullName || avatarUrl) {
      const user = await User.findById(req.userId);
      if (user) {
        if (fullName) user.fullName = fullName;
        if (avatarUrl) user.avatarUrl = avatarUrl;
        await user.save();
      }
    }

    // Update Therapist fields
    if (bio !== undefined) therapist.bio = bio;
    if (experienceYears !== undefined) therapist.experienceYears = experienceYears;
    if (specialties !== undefined) therapist.specialties = specialties;
    if (videoRate !== undefined) therapist.videoRate = videoRate;
    if (audioRate !== undefined) therapist.audioRate = audioRate;
    if (chatRate !== undefined) therapist.chatRate = chatRate;

    await therapist.save();

    // Re-query to return populated fields
    const updatedTherapist = await Therapist.findOne({ userId: req.userId }).populate('userId', 'fullName email avatarUrl');

    res.json({
      status: 'success',
      message: 'Therapist profile updated successfully.',
      therapist: updatedTherapist
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error updating therapist profile.',
      error: err.message
    });
  }
});

// @route   PUT /api/therapist/availability
// @desc    Update therapist availability schedule
// @access  Private
router.put('/availability', auth, async (req, res) => {
  try {
    const { sessionDuration, activeDays, timeSlots } = req.body;

    let therapist = await Therapist.findOne({ userId: req.userId });
    if (!therapist) {
      return res.status(404).json({
        status: 'error',
        message: 'Therapist profile not found.'
      });
    }

    // Update fields
    if (sessionDuration !== undefined) therapist.sessionDuration = sessionDuration;
    if (activeDays !== undefined) therapist.activeDays = activeDays;
    if (timeSlots !== undefined) therapist.timeSlots = timeSlots;

    await therapist.save();

    res.json({
      status: 'success',
      message: 'Availability schedule synced successfully.',
      therapist
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error syncing availability.',
      error: err.message
    });
  }
});

// @route   GET /api/therapist/bookings
// @desc    Get therapist bookings (pending and upcoming approved)
// @access  Private
router.get('/bookings', auth, async (req, res) => {
  try {
    const bookings = await SessionBooking.find({ therapistId: req.userId })
      .populate('clientId', 'fullName email avatarUrl gender')
      .sort({ appointmentDate: 1 });

    res.json({
      status: 'success',
      bookings
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error fetching bookings.',
      error: err.message
    });
  }
});

// @route   PUT /api/therapist/bookings/:id
// @desc    Update booking status (approve/decline)
// @access  Private
router.put('/bookings/:id', auth, async (req, res) => {
  try {
    const { status } = req.body;
    if (!status || !['approved', 'declined', 'cancelled'].includes(status)) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid status value.'
      });
    }

    const booking = await SessionBooking.findOne({ _id: req.params.id, therapistId: req.userId });
    if (!booking) {
      return res.status(404).json({
        status: 'error',
        message: 'Booking not found or unauthorized.'
      });
    }

    booking.status = status;
    await booking.save();

    // Create a notification for the client
    try {
      const therapistUser = await User.findById(req.userId);
      const therapistName = therapistUser ? therapistUser.fullName : 'Your therapist';
      
      await Notification.create({
        recipientId: booking.clientId,
        senderId: req.userId,
        title: `Booking request ${status}`,
        message: `${therapistName} has ${status} your booking request for ${new Date(booking.appointmentDate).toLocaleDateString()}.`,
        type: 'booking_status'
      });
    } catch (notificationErr) {
      console.error('Error creating notification:', notificationErr.message);
    }

    res.json({
      status: 'success',
      message: `Booking status updated to ${status} successfully.`,
      booking
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error updating booking status.',
      error: err.message
    });
  }
});

// @route   PUT /api/therapist/bookings/:id/notes
// @desc    Update/Save encrypted clinical notes for a booking
// @access  Private
router.put('/bookings/:id/notes', auth, async (req, res) => {
  try {
    const { encryptedNotes } = req.body;
    
    const booking = await SessionBooking.findOne({ _id: req.params.id, therapistId: req.userId });
    if (!booking) {
      return res.status(404).json({
        status: 'error',
        message: 'Booking not found or unauthorized.'
      });
    }

    booking.encryptedNotes = encryptedNotes || '';
    await booking.save();

    res.json({
      status: 'success',
      message: 'Encrypted clinical notes saved successfully.',
      booking
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error saving clinical notes.',
      error: err.message
    });
  }
});

// @route   GET /api/therapist/bookings/:id/notes
// @desc    Get encrypted clinical notes for a booking
// @access  Private
router.get('/bookings/:id/notes', auth, async (req, res) => {
  try {
    const booking = await SessionBooking.findOne({ _id: req.params.id, therapistId: req.userId });
    if (!booking) {
      return res.status(404).json({
        status: 'error',
        message: 'Booking not found or unauthorized.'
      });
    }

    res.json({
      status: 'success',
      encryptedNotes: booking.encryptedNotes || ''
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error retrieving clinical notes.',
      error: err.message
    });
  }
});

// @route   GET /api/therapist/earnings
// @desc    Get therapist dynamic completed session earnings & transaction history
// @access  Private
router.get('/earnings', auth, async (req, res) => {
  try {
    const therapist = await Therapist.findOne({ userId: req.userId });
    if (!therapist) {
      return res.status(404).json({
        status: 'error',
        message: 'Therapist profile not found.'
      });
    }

    const rates = {
      video: therapist.videoRate || 1500,
      audio: therapist.audioRate || 1000,
      chat: therapist.chatRate || 600
    };

    const bookings = await SessionBooking.find({
      therapistId: req.userId,
      status: 'approved',
      paymentStatus: 'paid'
    })
    .populate('clientId', 'fullName email avatarUrl')
    .sort({ appointmentDate: -1 });

    let totalGross = 0;
    let totalCommission = 0;
    let totalNet = 0;
    let pendingPayout = 0;

    const now = new Date();
    const twoDaysAgo = new Date(now.getTime() - 2 * 24 * 60 * 60 * 1000);

    const ledger = bookings.map(booking => {
      const type = booking.consultationType || 'video';
      const gross = rates[type] || 1500;
      const commission = Math.round(gross * 0.20);
      const net = gross - commission;

      totalGross += gross;
      totalCommission += commission;
      totalNet += net;

      const isPending = new Date(booking.appointmentDate) >= twoDaysAgo;
      if (isPending) {
        pendingPayout += net;
      }

      return {
        id: booking._id,
        clientName: booking.clientId ? booking.clientId.fullName : 'Client',
        clientAvatar: booking.clientId ? booking.clientId.avatarUrl : '',
        type: type === 'video' ? 'Video Call' : type === 'audio' ? 'Audio Call' : 'Chat Support',
        date: new Date(booking.appointmentDate).toLocaleDateString('en-US', {
          month: 'long',
          day: 'numeric',
          year: 'numeric'
        }),
        gross,
        commission,
        net,
        status: isPending ? 'Pending Payout' : 'Settled'
      };
    });

    res.json({
      status: 'success',
      totalGross,
      totalCommission,
      totalNet,
      pendingPayout,
      settledPayout: totalNet - pendingPayout,
      ledger
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error retrieving earnings.',
      error: err.message
    });
  }
});

export default router;
