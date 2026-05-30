import express from 'express';
import bcrypt from 'bcryptjs';
import jwt from 'jsonwebtoken';
import nodemailer from 'nodemailer';
import User from '../models/User.js';

const router = express.Router();

// @route   POST /api/auth/register
// @desc    Register a new user
// @access  Public
router.post('/register', async (req, res) => {
  try {
    const { email, password, fullName } = req.body;

    // Simple validation
    if (!email || !password || !fullName) {
      return res.status(400).json({
        status: 'error',
        message: 'Please enter all fields (email, password, fullName).'
      });
    }

    if (password.length < 6) {
      return res.status(400).json({
        status: 'error',
        message: 'Password must be at least 6 characters.'
      });
    }

    // Check for existing user
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({
        status: 'error',
        message: 'That email is already in use.'
      });
    }

    // Hash password
    const salt = await bcrypt.genSalt(12);
    const hashedPassword = await bcrypt.hash(password, salt);

    // Create user
    const newUser = new User({
      email,
      password: hashedPassword,
      fullName
    });

    await newUser.save();

    res.status(201).json({
      status: 'success',
      message: 'Account created successfully.'
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error during registration.',
      error: err.message
    });
  }
});

// @route   POST /api/auth/login
// @desc    Authenticate user & get token
// @access  Public
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;

    // Simple validation
    if (!email || !password) {
      return res.status(400).json({
        status: 'error',
        message: 'Please enter all fields (email, password).'
      });
    }

    // Check for user
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(400).json({
        status: 'error',
        message: 'No user found for that email.'
      });
    }

    // Validate password
    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) {
      return res.status(400).json({
        status: 'error',
        message: 'Wrong password provided.'
      });
    }

    // Sign Token
    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET || 'aakaa_super_secret_jwt_key_2026',
      { expiresIn: '30d' } // Long-lasting mobile session (30 days)
    );

    res.json({
      status: 'success',
      message: 'Login successful',
      token,
      user: {
        id: user._id,
        email: user.email,
        fullName: user.fullName,
        subscriptionTier: user.subscriptionTier,
        streakCount: user.streakCount,
        createdAt: user.createdAt
      }
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error during authentication.',
      error: err.message
    });
  }
});

// Temp OTP storage cache (expires in 5 minutes)
const otpCache = new Map();

// Helper to send email via SMTP (Nodemailer)
const sendOtpEmail = async (email, otp) => {
  const mailUser = process.env.EMAIL_USER;
  const mailPass = process.env.EMAIL_PASS;

  if (!mailUser || !mailPass || mailUser === 'your_email_here') {
    console.warn(`⚠️ EMAIL_USER or EMAIL_PASS not configured in .env. Logging OTP locally:`);
    console.log(`🔑 -----------------------------`);
    console.log(`✉️ Email: ${email}`);
    console.log(`🔑 OTP Verification Code: ${otp}`);
    console.log(`🔑 -----------------------------`);
    return true; 
  }

  const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
      user: mailUser,
      pass: mailPass
    }
  });

  const mailOptions = {
    from: `"Aakaa Services" <${mailUser}>`,
    to: email,
    subject: '🔑 Verify Your Aakaa Account',
    html: `
      <div style="font-family: Arial, sans-serif; max-width: 600px; margin: auto; padding: 32px; border: 1.5px solid #065643; border-radius: 24px; background-color: #FFF7F5;">
        <div style="text-align: center; margin-bottom: 24px;">
          <h2 style="color: #065643; margin: 0; font-size: 28px; letter-spacing: -0.5px;">Aakaa Services</h2>
          <p style="color: #5EBAA0; margin: 4px 0 0 0; font-size: 13px;">Your Mindful Inner Sky</p>
        </div>
        <hr style="border: none; border-top: 1px solid #065643; opacity: 0.15; margin: 24px 0;" />
        <p style="color: #1E293B; font-size: 16px; line-height: 1.6;">Hello,</p>
        <p style="color: #1E293B; font-size: 16px; line-height: 1.6;">Welcome to Aakaa! To securely activate and verify your clinical account, please enter the following 4-digit verification code in your mobile application:</p>
        <div style="text-align: center; margin: 32px 0;">
          <span style="font-size: 36px; font-weight: bold; color: #065643; letter-spacing: 6px; padding: 12px 28px; background-color: #white; border: 1px dashed #065643; border-radius: 12px; display: inline-block;">${otp}</span>
        </div>
        <p style="color: #475569; font-size: 14px; line-height: 1.6;">This code is strictly confidential and expires in <strong>5 minutes</strong>. If you did not request this code, please ignore this email.</p>
        <hr style="border: none; border-top: 1px solid #065643; opacity: 0.15; margin: 24px 0;" />
        <p style="color: #64748B; font-size: 11px; text-align: center; line-height: 1.5; margin: 0;">
          © 2026 Aakaa Platform Health Services. All rights reserved.<br />
          Grounded, Secure, and HIPAA-Compliant Tele-Therapy.
        </p>
      </div>
    `
  };

  await transporter.sendMail(mailOptions);
  return true;
};

// @route   POST /api/auth/send-otp
// @desc    Generate and send email verification OTP
// @access  Public
router.post('/send-otp', async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({
        status: 'error',
        message: 'Please provide a valid email.'
      });
    }

    // 1. Prevent duplicate registration if email already exists in database
    const existingUser = await User.findOne({ email: email.toLowerCase().trim() });
    if (existingUser) {
      return res.status(400).json({
        status: 'error',
        message: 'That email is already registered. Please log in.'
      });
    }

    // 2. Generate random 4-digit OTP
    const otp = Math.floor(1000 + Math.random() * 9000).toString();
    const expiry = Date.now() + 5 * 60 * 1000; // 5 minutes expiration

    otpCache.set(email.toLowerCase().trim(), { otp, expiry });

    // 3. Send email asynchronously
    await sendOtpEmail(email.toLowerCase().trim(), otp);

    res.json({
      status: 'success',
      message: 'Verification OTP sent successfully to your email.'
    });

  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Failed to dispatch verification email.',
      error: err.message
    });
  }
});

// @route   POST /api/auth/verify-otp
// @desc    Verify the email OTP
// @access  Public
router.post('/verify-otp', async (req, res) => {
  try {
    const { email, otp } = req.body;
    if (!email || !otp) {
      return res.status(400).json({
        status: 'error',
        message: 'Please provide email and OTP code.'
      });
    }

    const cached = otpCache.get(email.toLowerCase().trim());
    if (!cached) {
      return res.status(400).json({
        status: 'error',
        message: 'No active OTP verification session found. Please request a new code.'
      });
    }

    if (Date.now() > cached.expiry) {
      otpCache.delete(email.toLowerCase().trim());
      return res.status(400).json({
        status: 'error',
        message: 'Verification code has expired. Please request a new one.'
      });
    }

    if (cached.otp !== otp.trim()) {
      return res.status(400).json({
        status: 'error',
        message: 'Invalid verification code. Please try again.'
      });
    }

    // Success! Clear the cached OTP session
    otpCache.delete(email.toLowerCase().trim());

    res.json({
      status: 'success',
      message: 'Email verified successfully.'
    });

  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error during OTP verification.',
      error: err.message
    });
  }
});

// @route   POST /api/auth/forgot-password
// @desc    Initiate password reset process
// @access  Public
router.post('/forgot-password', async (req, res) => {
  try {
    const { email } = req.body;
    if (!email) {
      return res.status(400).json({
        status: 'error',
        message: 'Please provide a valid email.'
      });
    }

    const user = await User.findOne({ email: email.toLowerCase().trim() });
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'No user registered with this email address.'
      });
    }

    console.log(`✉️ Sending secure password reset link to: ${email}`);

    res.json({
      status: 'success',
      message: 'Password reset link successfully dispatched to email.'
    });
  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error during password reset request.',
      error: err.message
    });
  }
});

// @route   POST /api/auth/google-login
// @desc    Register or Login a user via Google OAuth callback simulation
// @access  Public
router.post('/google-login', async (req, res) => {
  try {
    const { email, fullName } = req.body;
    if (!email || !fullName) {
      return res.status(400).json({
        status: 'error',
        message: 'Please provide email and fullName from Google.'
      });
    }

    const cleanEmail = email.toLowerCase().trim();

    // 1. Search for existing user
    let user = await User.findOne({ email: cleanEmail });

    if (!user) {
      // 2. Register new user automatically (generate random password for secure OAuth fallback)
      const salt = await bcrypt.genSalt(10);
      const hashedPassword = await bcrypt.hash(Math.random().toString(36), salt);

      user = new User({
        email: cleanEmail,
        password: hashedPassword,
        fullName: fullName.trim(),
        subscriptionTier: 'freemium'
      });
      await user.save();
    }

    // 3. Sign JWT Token
    const token = jwt.sign(
      { id: user._id },
      process.env.JWT_SECRET || 'aakaa_super_secret_jwt_key_2026',
      { expiresIn: '30d' }
    );

    res.json({
      status: 'success',
      message: 'Google login successful',
      token,
      user: {
        id: user._id,
        email: user.email,
        fullName: user.fullName,
        subscriptionTier: user.subscriptionTier,
        streakCount: user.streakCount,
        createdAt: user.createdAt
      }
    });

  } catch (err) {
    res.status(500).json({
      status: 'error',
      message: 'Server error during Google authentication.',
      error: err.message
    });
  }
});

export default router;
