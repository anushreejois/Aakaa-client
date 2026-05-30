import express from 'express';
import pkg from 'agora-access-token';
import auth from '../middleware/auth.js';

const { RtcTokenBuilder, RtcRole } = pkg;
const router = express.Router();

// @route   POST /api/agora/generate-token
// @desc    Generate secure Agora RTC token for video/audio rooms
// @access  Private
router.post('/generate-token', auth, async (req, res) => {
  try {
    const { channelName, role, uid } = req.body;

    if (!channelName) {
      return res.status(400).json({
        status: 'error',
        message: 'Channel name is required.'
      });
    }

    // Retrieve Agora credentials from env
    const appId = process.env.AGORA_APP_ID;
    const appCertificate = process.env.AGORA_APP_CERTIFICATE;

    // Standard fallback logic: if credentials are not configured, return a bypass response to prevent application crashes
    if (!appId || !appCertificate) {
      console.log('⚠️ Agora credentials missing in backend .env. Generating mock bypass token.');
      return res.json({
        status: 'success',
        token: 'mock_bypass_token_for_development',
        uid: uid || 0,
        channelName,
        appId: appId || 'mock_app_id_12345'
      });
    }

    // Determine role (publisher vs subscriber)
    const rtcRole = role === 'subscriber' ? RtcRole.SUBSCRIBER : RtcRole.PUBLISHER;
    
    // Default UID is 0 (Agora handles UID allocation automatically if 0)
    const numericUid = uid ? parseInt(uid, 10) : 0;

    // Expiration duration (default 2 hours)
    const expirationTimeInSeconds = 3600 * 2;
    const currentTimestamp = Math.floor(Date.now() / 1000);
    const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds;

    // Generate token
    const token = RtcTokenBuilder.buildTokenWithUid(
      appId,
      appCertificate,
      channelName,
      numericUid,
      rtcRole,
      privilegeExpiredTs
    );

    res.json({
      status: 'success',
      token,
      uid: numericUid,
      channelName,
      appId
    });
  } catch (err) {
    console.error('❌ Agora Token Generation Error:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to generate Agora token.',
      error: err.message
    });
  }
});

export default router;
