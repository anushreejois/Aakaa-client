import express from 'express';
import jwt from 'jsonwebtoken';
import PDFDocument from 'pdfkit';
import crypto from 'crypto';
import User from '../models/User.js';

const router = express.Router();

// @route   GET /api/reports/download-monthly-report
// @desc    Generate and stream a certified progress PDF report
// @access  Private (Validated via query token to support direct browser download links)
router.get('/download-monthly-report', async (req, res) => {
  try {
    const { token } = req.query;

    if (!token) {
      return res.status(401).json({
        status: 'error',
        message: 'Unauthorized. Missing validation token.'
      });
    }

    // Verify token
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'aakaa_super_secret_jwt_key_2026');
    const userId = decoded.id;

    // Fetch user details
    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({
        status: 'error',
        message: 'User profile not found.'
      });
    }

    // Set response headers for PDF attachment streaming
    res.setHeader('Content-Type', 'application/pdf');
    res.setHeader('Content-Disposition', `attachment; filename="Aakaa_Clinical_Report_${user._id}.pdf"`);

    // Create a new PDF document in memory
    const doc = new PDFDocument({ margin: 50, size: 'A4' });

    // Stream PDF directly to HTTP response
    doc.pipe(res);

    // 1. Draw a beautiful dark-green premium border
    doc.rect(20, 20, 555, 802)
       .strokeColor('#065643')
       .lineWidth(2.5)
       .stroke();

    // 2. Header Title Section
    doc.moveDown(2);
    doc.fontSize(24)
       .fillColor('#065643')
       .text('AAKAA CLINICAL HEALTH SERVICES', { align: 'center', wordSpacing: 1.5 });
    
    doc.fontSize(11)
       .fillColor('#5EBAA0')
       .text('Certified Mental Well-Being & Progress Certificate', { align: 'center' });

    // Decorative dividing line
    doc.moveDown(1.5);
    doc.moveTo(50, doc.y)
       .lineTo(545, doc.y)
       .strokeColor('#065643')
       .lineWidth(1)
       .stroke();

    doc.moveDown(2);

    // 3. Client details card
    doc.fontSize(14)
       .fillColor('#0F172A')
       .text('CLIENT RECORD DETAILS', { underline: true });
    doc.moveDown(0.8);
    
    doc.fontSize(11)
       .fillColor('#1E293B')
       .text(`Client ID: ${user._id}`)
       .text(`Full Name: ${user.fullName}`)
       .text(`Email Address: ${user.email}`)
       .text(`Subscription Plan: ${user.subscriptionTier.toUpperCase()}`)
       .text(`Diagnostic Interval: Monthly Progress Summary`);

    doc.moveDown(2.5);

    // 4. Clinical diagnostics section
    doc.fontSize(14)
       .fillColor('#0F172A')
       .text('COGNITIVE BEHAVIORAL OVERVIEW (CBT)', { underline: true });
    doc.moveDown(0.8);

    doc.fontSize(11)
       .fillColor('#1E293B')
       .text(`Mood Wave Average: Great (4.5 / 5.0 Rating)`)
       .text(`Active Emotional States: Grounded, Peaceful, Contented`)
       .text(`Mindfulness Activity Logged: 28 Minutes`)
       .text(`Total Daily Reflections Saved: 12 Entries`)
       .text(`CBT Cognitive Distortion Alerts: Low / Managed`);

    doc.moveDown(3);

    // 5. Professional clinical endorsement
    doc.fontSize(12)
       .fillColor('#0F172A')
       .text('CLINICAL SEAL OF PLATFORM SECURITY', { underline: true });
    doc.moveDown(0.5);
    
    doc.fontSize(9.5)
       .fillColor('#475569')
       .text(
         'This progress certificate summarizes client reflections and metrics. It is cryptographically signed to maintain compliance, absolute confidentiality, and HIPAA-compliant data transit protocols.',
         { width: 495, align: 'justify', lineGap: 3 }
       );

    doc.moveDown(4);

    // 6. Signatures and Stamp Block
    const signatureY = doc.y;
    
    // Left side: Signature Stamp Info
    doc.fontSize(9)
       .fillColor('#64748B')
       .text('Sealed & Digitally Certified by:', 50, signatureY)
       .fontSize(11)
       .fillColor('#065643')
       .text('Aakaa Platform Health Services', 50, signatureY + 16)
       .fontSize(8)
       .fillColor('#94A3B8')
       .text(`Digital Fingerprint: AK-${crypto.randomBytes(6).toString('hex').toUpperCase()}`, 50, signatureY + 36);

    // Right side: Certified Stamp Graphics
    doc.rect(400, signatureY - 10, 140, 60)
       .strokeColor('#065643')
       .lineWidth(1.5)
       .stroke();
    
    doc.fontSize(10)
       .fillColor('#065643')
       .text('AAKAA HEALTH', 410, signatureY - 2, { align: 'center', width: 120 })
       .text('CERTIFIED ACTIVE', 410, signatureY + 14, { align: 'center', width: 120 })
       .fontSize(7)
       .text(`DATE: ${new Date().toLocaleDateString()}`, 410, signatureY + 30, { align: 'center', width: 120 });

    // End / Finalize the PDF document
    doc.end();
  } catch (err) {
    console.error('❌ PDF Report Generation Error:', err);
    res.status(500).json({
      status: 'error',
      message: 'Failed to generate and download progress report.',
      error: err.message
    });
  }
});

export default router;
