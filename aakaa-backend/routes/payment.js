import express from 'express';
import Razorpay from 'razorpay';
import crypto from 'crypto';
import User from '../models/User.js';
import auth from '../middleware/auth.js';

const router = express.Router();



// @route   POST /api/payments/create-order
// @desc    Create a payment order on Razorpay
// @access  Private
router.post('/create-order', auth, async (req, res) => {
  try {
    const { amount, purpose, planIndex } = req.body;

    console.log('--- Creating Razorpay Order ---');
    console.log('Amount:', amount);
    console.log('Using Key ID:', process.env.RAZORPAY_KEY_ID);
    console.log('Using Secret Key Exists:', !!process.env.RAZORPAY_KEY_SECRET);

    if (!amount) {
      return res.status(400).json({
        status: 'error',
        message: 'Amount is required.'
      });
    }

    // Razorpay amount is in paise (1 INR = 100 paise)
    const amountInPaise = Math.round(amount * 100);

    const options = {
      amount: amountInPaise,
      currency: 'INR',
      receipt: `receipt_${Date.now()}`,
      notes: {
        userId: req.userId,
        purpose: purpose || 'subscription',
        planIndex: (planIndex !== undefined && planIndex !== null) ? planIndex.toString() : ''
      }
    };

    const razorpay = new Razorpay({
      key_id: process.env.RAZORPAY_KEY_ID,
      key_secret: process.env.RAZORPAY_KEY_SECRET
    });

    const order = await razorpay.orders.create(options);

    res.json({
      status: 'success',
      orderId: order.id,
      amount: order.amount,
      currency: order.currency,
      keyId: process.env.RAZORPAY_KEY_ID || 'rzp_test_dummy_key_123'
    });
  } catch (err) {
    console.error('❌ Razorpay Order Creation Error:', err);
    res.status(500).json({
      status: 'error',
      message: err.message || 'Failed to create payment order.',
      error: err.message
    });
  }
});

// @route   POST /api/payments/verify-subscription
// @desc    Verify payment signature & upgrade user tier
// @access  Private
router.post('/verify-subscription', auth, async (req, res) => {
  try {
    const { razorpay_payment_id, razorpay_order_id, razorpay_signature, planIndex } = req.body;

    if (!razorpay_payment_id || !razorpay_order_id || !razorpay_signature) {
      return res.status(400).json({
        status: 'error',
        message: 'Missing verification fields.'
      });
    }

    // Verify signature using HMAC SHA-256
    const key_secret = process.env.RAZORPAY_KEY_SECRET || 'rzp_test_dummy_secret_123';
    const generated_signature = crypto
      .createHmac('sha256', key_secret)
      .update(razorpay_order_id + '|' + razorpay_payment_id)
      .digest('hex');

    if (generated_signature !== razorpay_signature) {
      return res.status(400).json({
        status: 'error',
        message: 'Payment verification failed. Invalid signature.'
      });
    }

    // Upgrade subscription tier
    const user = await User.findById(req.userId);
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User not found.'
      });
    }

    let subscriptionTier = 'freemium';
    if (planIndex === 1) subscriptionTier = 'basic';
    else if (planIndex === 2) subscriptionTier = 'standard';
    else if (planIndex === 3) subscriptionTier = 'premium';

    user.subscriptionTier = subscriptionTier;
    await user.save();

    res.json({
      status: 'success',
      message: 'Payment verified and subscription upgraded successfully.',
      user: {
        id: user._id,
        email: user.email,
        fullName: user.fullName,
        subscriptionTier: user.subscriptionTier,
        streakCount: user.streakCount,
        avatarUrl: user.avatarUrl,
        gender: user.gender
      }
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to verify subscription payment.',
      error: err.message
    });
  }
});

// @route   POST /api/payments/verify-booking
// @desc    Verify payment signature for consultation bookings
// @access  Private
router.post('/verify-booking', auth, async (req, res) => {
  try {
    const { razorpay_payment_id, razorpay_order_id, razorpay_signature } = req.body;

    if (!razorpay_payment_id || !razorpay_order_id || !razorpay_signature) {
      return res.status(400).json({
        status: 'error',
        message: 'Missing verification fields.'
      });
    }

    // Verify signature
    const key_secret = process.env.RAZORPAY_KEY_SECRET || 'rzp_test_dummy_secret_123';
    const generated_signature = crypto
      .createHmac('sha256', key_secret)
      .update(razorpay_order_id + '|' + razorpay_payment_id)
      .digest('hex');

    if (generated_signature !== razorpay_signature) {
      return res.status(400).json({
        status: 'error',
        message: 'Payment verification failed. Invalid signature.'
      });
    }

    // Return success. (The actual booking session schema addition will happen inside Flutter)
    res.json({
      status: 'success',
      message: 'Booking payment verified successfully.'
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to verify booking payment.',
      error: err.message
    });
  }
});

export default router;
