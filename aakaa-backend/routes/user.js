import express from 'express';
import User from '../models/User.js';
import ActivityLog from '../models/ActivityLog.js';
import SessionBooking from '../models/SessionBooking.js';
import auth from '../middleware/auth.js';

const router = express.Router();

// @route   GET /api/users/profile
// @desc    Get current user profile details
// @access  Private
router.get('/profile', auth, async (req, res) => {
  try {
    const user = await User.findById(req.userId).select('-password');
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User profile not found.'
      });
    }

    res.json({
      status: 'success',
      user
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error retrieving profile.',
      error: err.message
    });
  }
});

// @route   PUT /api/users/profile
// @desc    Update user profile details
// @access  Private
router.put('/profile', auth, async (req, res) => {
  try {
    const { fullName, subscriptionTier, streakCount, avatarUrl, gender } = req.body;
    
    // Find user
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User profile not found.'
      });
    }

    // Apply updates
    if (fullName) user.fullName = fullName;
    if (subscriptionTier) user.subscriptionTier = subscriptionTier;
    if (streakCount !== undefined) user.streakCount = streakCount;
    if (avatarUrl) user.avatarUrl = avatarUrl;
    if (gender) user.gender = gender;

    await user.save();

    res.json({
      status: 'success',
      message: 'Profile updated successfully.',
      user: {
        id: user._id,
        email: user.email,
        fullName: user.fullName,
        subscriptionTier: user.subscriptionTier,
        streakCount: user.streakCount,
        avatarUrl: user.avatarUrl,
        gender: user.gender,
        createdAt: user.createdAt
      }
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error updating profile.',
      error: err.message
    });
  }
});

// @route   GET /api/users/activity-summary
// @desc    Get aggregated user activity data
// @access  Private
router.get('/activity-summary', auth, async (req, res) => {
  try {
    const userId = req.userId;

    // Count sessions
    const sessionCount = await SessionBooking.countDocuments({ clientId: userId });

    // Count mood logs
    const moodLogs = await ActivityLog.find({ clientId: userId });
    const moodLogCount = moodLogs.filter(log => log.moodScore > 0).length;

    // Retrieve user for streak count and mindful activity minutes
    const user = await User.findById(userId);
    const streakCount = user ? user.streakCount : 0;
    const mindfulMinutes = user ? (user.mindfulMinutes || 0) : 0;

    // Calculate average mood label
    const weekdayNames = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"];
    const moodNames = ["Terrible", "Bad", "Okay", "Good", "Great"];
    
    const moodLogsWithScore = moodLogs.filter(log => log.moodScore > 0);
    let averageMood = "Okay";
    if (moodLogsWithScore.length > 0) {
      const sum = moodLogsWithScore.reduce((acc, log) => acc + log.moodScore, 0);
      const avg = sum / moodLogsWithScore.length;
      const roundedIndex = Math.min(4, Math.max(0, Math.round(avg) - 1));
      averageMood = moodNames[roundedIndex];
    }

    // Dynamic growth index formula
    const growthPercentage = Math.min(0.98, 0.50 + (moodLogCount * 0.02) + (sessionCount * 0.05));

    // Get latest journal entries
    const latestJournals = await ActivityLog.find({ 
      clientId: userId, 
      journalSnippet: { $ne: '' } 
    }).sort({ timestamp: -1 }).limit(3);

    // Format journal responses
    const journalEntries = latestJournals.map(j => {
      const date = new Date(j.timestamp);
      return {
        date: date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }),
        content: j.journalSnippet
      };
    });

    // Generate last 7 days ending today, populating database scores where present
    const moodHistory = [];
    for (let i = 6; i >= 0; i--) {
      const d = new Date();
      d.setDate(d.getDate() - i);
      
      const startOfDay = new Date(d);
      startOfDay.setHours(0, 0, 0, 0);
      
      const endOfDay = new Date(d);
      endOfDay.setHours(23, 59, 59, 999);

      const log = await ActivityLog.findOne({
        clientId: userId,
        moodScore: { $gt: 0 },
        timestamp: { $gte: startOfDay, $lte: endOfDay }
      });

      if (log) {
        moodHistory.push({
          day: weekdayNames[d.getDay()],
          value: log.moodScore - 1, // Map 1-5 to 0-4
          mood: moodNames[log.moodScore - 1] || "Okay",
          time: new Date(log.timestamp).toLocaleDateString('en-US', { weekday: 'short', hour: 'numeric', minute: '2-digit' })
        });
      } else {
        moodHistory.push({
          day: weekdayNames[d.getDay()],
          value: 2, // Neutral baseline for days without logs
          mood: "Okay",
          time: `${weekdayNames[d.getDay()]}, No Log`
        });
      }
    }

    res.json({
      status: 'success',
      sessionCount,
      moodLogCount,
      streakCount,
      growthPercentage,
      journalEntries,
      moodHistory,
      mindfulMinutes,
      averageMood
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error retrieving activity summary.',
      error: err.message
    });
  }
});

// @route   POST /api/users/mindfulness
// @desc    Increment user's completed mindfulness minutes
// @access  Private
router.post('/mindfulness', auth, async (req, res) => {
  try {
    const { minutes } = req.body;
    const minutesToAdd = parseInt(minutes, 10) || 5;

    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User profile not found.'
      });
    }

    user.mindfulMinutes = (user.mindfulMinutes || 0) + minutesToAdd;
    await user.save();

    res.json({
      status: 'success',
      message: 'Mindful activity minutes updated successfully.',
      mindfulMinutes: user.mindfulMinutes
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error updating mindfulness minutes.',
      error: err.message
    });
  }
});

// @route   POST /api/users/mood-log
// @desc    Log a new mood entry (updates today's existing entry if already logged)
// @access  Private
router.post('/mood-log', auth, async (req, res) => {
  try {
    const { moodScore, emotionTags } = req.body;
    if (!moodScore || moodScore < 1 || moodScore > 5) {
      return res.status(400).json({
        status: 'error',
        message: 'Valid mood score (1-5) is required.'
      });
    }

    const startOfToday = new Date();
    startOfToday.setHours(0, 0, 0, 0);

    const endOfToday = new Date();
    endOfToday.setHours(23, 59, 59, 999);

    // Find if there's already a mood log today for this user
    let log = await ActivityLog.findOne({
      clientId: req.userId,
      moodScore: { $gt: 0 },
      timestamp: { $gte: startOfToday, $lte: endOfToday }
    });

    let isNewLog = false;
    if (log) {
      // Overwrite/update today's existing log
      log.moodScore = moodScore;
      if (emotionTags) log.emotionTags = emotionTags;
      log.timestamp = new Date();
      await log.save();
    } else {
      // Create a brand new log for today
      log = new ActivityLog({
        clientId: req.userId,
        moodScore,
        emotionTags: emotionTags || []
      });
      await log.save();
      isNewLog = true;
    }

    // Increment user streak only if it's the first log of the day
    const user = await User.findById(req.userId);
    if (user && isNewLog) {
      user.streakCount = (user.streakCount || 0) + 1;
      await user.save();
    }

    res.status(201).json({
      status: 'success',
      message: isNewLog ? 'Mood logged successfully.' : 'Today\'s mood updated successfully.',
      streakCount: user ? user.streakCount : 1,
      log
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error logging mood.',
      error: err.message
    });
  }
});

// @route   POST /api/users/journal
// @desc    Log a new journal entry
// @access  Private
router.post('/journal', auth, async (req, res) => {
  try {
    const { content } = req.body;
    if (!content || content.trim().isEmpty) {
      return res.status(400).json({
        status: 'error',
        message: 'Journal content is required.'
      });
    }

    const log = new ActivityLog({
      clientId: req.userId,
      moodScore: 3, // default neutral mood for a pure journal entry if not specified
      journalSnippet: content.trim()
    });
    await log.save();

    // Increment streak
    const user = await User.findById(req.userId);
    if (user) {
      user.streakCount = (user.streakCount || 0) + 1;
      await user.save();
    }

    res.status(201).json({
      status: 'success',
      message: 'Journal logged successfully.',
      streakCount: user ? user.streakCount : 1,
      log
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error logging journal.',
      error: err.message
    });
  }
});

// @route   GET /api/users/sessions
// @desc    Get user upcoming and past sessions
// @access  Private
router.get('/sessions', auth, async (req, res) => {
  try {
    const userId = req.userId;
    const sessions = await SessionBooking.find({ clientId: userId })
      .populate('therapistId', 'fullName avatarUrl')
      .sort({ appointmentDate: 1 });

    const now = new Date();

    const upcoming = sessions.filter(s => new Date(s.appointmentDate) >= now).map(s => {
      const date = new Date(s.appointmentDate);
      const name = s.therapistId ? s.therapistId.fullName : "Unknown Therapist";
      const initials = name.split(" ").map(w => w[0]).join("").substring(0, 2).toUpperCase();
      return {
        id: s._id,
        therapistName: name,
        therapistInitials: initials,
        startTime: s.appointmentDate,
        endTime: new Date(date.getTime() + 45 * 60 * 1000), // 45 min duration
        consultationType: s.consultationType
      };
    });

    const past = sessions.filter(s => new Date(s.appointmentDate) < now).map(s => {
      const date = new Date(s.appointmentDate);
      const name = s.therapistId ? s.therapistId.fullName : "Unknown Therapist";
      const initials = name.split(" ").map(w => w[0]).join("").substring(0, 2).toUpperCase();
      return {
        id: s._id,
        therapistName: name,
        therapistInitials: initials,
        startTime: s.appointmentDate,
        endTime: new Date(date.getTime() + 45 * 60 * 1000),
        consultationType: s.consultationType
      };
    });

    res.json({
      status: 'success',
      upcoming,
      past
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error retrieving sessions.',
      error: err.message
    });
  }
});

// @route   POST /api/users/book-session
// @desc    Create a new therapy session booking
// @access  Private
router.post('/book-session', auth, async (req, res) => {
  try {
    const { therapistId, appointmentDate, consultationType } = req.body;
    if (!therapistId || !appointmentDate || !consultationType) {
      return res.status(400).json({
        status: 'error',
        message: 'Therapist ID, appointment date, and consultation type are required.'
      });
    }

    const booking = new SessionBooking({
      clientId: req.userId,
      therapistId,
      appointmentDate: new Date(appointmentDate),
      consultationType,
      paymentStatus: 'paid' // Default paid for simplified testing
    });

    await booking.save();

    res.status(201).json({
      status: 'success',
      message: 'Session booked successfully.',
      booking
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error booking session.',
      error: err.message
    });
  }
});

export default router;
