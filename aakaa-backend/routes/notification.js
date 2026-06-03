import express from 'express';
import auth from '../middleware/auth.js';
import Notification from '../models/Notification.js';

const router = express.Router();

// @route   GET /api/notifications
// @desc    Get all notifications for logged-in user
// @access  Private
router.get('/', auth, async (req, res) => {
  try {
    const notifications = await Notification.find({ recipientId: req.userId })
      .sort({ createdAt: -1 })
      .limit(50); // Keep it performant

    res.json({
      status: 'success',
      notifications
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error fetching notifications.',
      error: err.message
    });
  }
});

// @route   PUT /api/notifications/read-all
// @desc    Mark all notifications as read for logged-in user
// @access  Private
router.put('/read-all', auth, async (req, res) => {
  try {
    await Notification.updateMany(
      { recipientId: req.userId, read: false },
      { $set: { read: true } }
    );

    res.json({
      status: 'success',
      message: 'All notifications marked as read.'
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error marking notifications as read.',
      error: err.message
    });
  }
});

// @route   PUT /api/notifications/:id/read
// @desc    Mark a single notification as read
// @access  Private
router.put('/:id/read', auth, async (req, res) => {
  try {
    const notification = await Notification.findOneAndUpdate(
      { _id: req.params.id, recipientId: req.userId },
      { $set: { read: true } },
      { new: true }
    );

    if (!notification) {
      return res.status(404).json({
        status: 'error',
        message: 'Notification not found or unauthorized.'
      });
    }

    res.json({
      status: 'success',
      notification
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error updating notification status.',
      error: err.message
    });
  }
});

export default router;
