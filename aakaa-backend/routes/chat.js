import express from 'express';
import ChatMessage from '../models/ChatMessage.js';
import auth from '../middleware/auth.js';

const router = express.Router();

// @route   GET /api/chat/history/:recipientId
// @desc    Retrieve chat message history between current user and recipient
// @access  Private
router.get('/history/:recipientId', auth, async (req, res) => {
  try {
    const { recipientId } = req.params;
    const userId = req.userId;

    if (!recipientId) {
      return res.status(400).json({
        status: 'error',
        message: 'Recipient ID is required.'
      });
    }

    // Find all messages sent between user and recipient, sorted chronologically
    const messages = await ChatMessage.find({
      $or: [
        { senderId: userId, recipientId: recipientId },
        { senderId: recipientId, recipientId: userId }
      ]
    }).sort({ timestamp: 1 });

    res.json({
      status: 'success',
      messages
    });
  } catch (err) {
    console.error('❌ Get Chat History Error:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to retrieve chat history.',
      error: err.message
    });
  }
});

// @route   POST /api/chat/send
// @desc    Save a new text chat message
// @access  Private
router.post('/send', auth, async (req, res) => {
  try {
    const { recipientId, messageText } = req.body;
    const userId = req.userId;

    if (!recipientId || !messageText) {
      return res.status(400).json({
        status: 'error',
        message: 'Recipient ID and message text are required.'
      });
    }

    const newMessage = new ChatMessage({
      senderId: userId,
      recipientId,
      messageText: messageText.trim()
    });

    await newMessage.save();

    res.status(201).json({
      status: 'success',
      message: 'Message saved successfully.',
      chatMessage: newMessage
    });
  } catch (err) {
    console.error('❌ Send Message Error:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to send message.',
      error: err.message
    });
  }
});

export default router;
