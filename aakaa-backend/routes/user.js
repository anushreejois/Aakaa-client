import express from 'express';
import User from '../models/User.js';
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

export default router;
