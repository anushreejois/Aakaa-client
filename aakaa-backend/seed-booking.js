import 'dotenv/config';
import mongoose from 'mongoose';
import User from './models/User.js';
import SessionBooking from './models/SessionBooking.js';
import Therapist from './models/Therapist.js';

const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/aakaa';

async function seed() {
  try {
    await mongoose.connect(MONGODB_URI);
    console.log('✅ Connected to MongoDB.');

    // 1. Find therapist user specifically matching Dr. Sarwah
    let therapistUser = await User.findOne({ role: 'therapist', fullName: /Sarwah/i });
    if (!therapistUser) {
      console.log('Could not find Dr. Sarwah, checking any therapist...');
      therapistUser = await User.findOne({ role: 'therapist' });
    }
    if (!therapistUser) {
      console.log('❌ No therapist user found in database. Please register/login in the app first.');
      process.exit(1);
    }
    console.log(`Found therapist user: ${therapistUser.fullName} (${therapistUser.email})`);

    // 2. Find or create a client user
    let clientUser = await User.findOne({ role: 'client' });
    if (!clientUser) {
      console.log('Creating a mock client user...');
      clientUser = await User.create({
        email: 'client.test@aakaa.com',
        password: 'password123', // dummy hashed password in production, simple for test
        fullName: 'Aditya Rao',
        role: 'client',
        avatarUrl: 'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=400&h=400&fit=crop'
      });
    }
    console.log(`Using client user: ${clientUser.fullName}`);

    // 3. Clear existing bookings to start fresh (optional)
    await SessionBooking.deleteMany({ therapistId: therapistUser._id });

    // 4. Create an APPROVED session (so the "Join Session" card displays at the top)
    const approvedBooking = await SessionBooking.create({
      clientId: clientUser._id,
      therapistId: therapistUser._id,
      appointmentDate: new Date(Date.now() + 1000 * 60 * 30), // 30 mins from now
      consultationType: 'video',
      paymentStatus: 'paid',
      status: 'approved'
    });
    console.log('✅ Created approved video session booking!');

    // 5. Create a PENDING session (so it shows up in the Booking Request Inbox at the bottom)
    const pendingBooking = await SessionBooking.create({
      clientId: clientUser._id,
      therapistId: therapistUser._id,
      appointmentDate: new Date(Date.now() + 1000 * 60 * 60 * 24), // Tomorrow
      consultationType: 'audio',
      paymentStatus: 'pending',
      status: 'pending'
    });
    console.log('✅ Created pending audio session booking request!');

    console.log('\n🎉 Seeding complete! Check your emulator dashboard.');
    process.exit(0);
  } catch (err) {
    console.error('❌ Error seeding data:', err);
    process.exit(1);
  }
}

seed();
