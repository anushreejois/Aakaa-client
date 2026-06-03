import mongoose from 'mongoose';

const therapistSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  licenseNumber: {
    type: String,
    required: true,
    trim: true
  },
  specialties: [{
    type: String,
    trim: true
  }],
  verificationStatus: {
    type: String,
    enum: ['pending', 'approved', 'rejected'],
    default: 'approved' // Set to approved temporarily for development
  },
  licenseFileUrl: {
    type: String,
    default: ''
  },
  sessionDuration: {
    type: Number,
    default: 45
  },
  activeDays: [{
    type: String,
    trim: true
  }],
  timeSlots: [{
    start: String,
    end: String
  }],
  bio: {
    type: String,
    default: 'Licensed clinical mental health professional dedicated to helping clients achieve emotional balance.'
  },
  experienceYears: {
    type: Number,
    default: 5
  },
  videoRate: {
    type: Number,
    default: 1500
  },
  audioRate: {
    type: Number,
    default: 1000
  },
  chatRate: {
    type: Number,
    default: 600
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const Therapist = mongoose.model('Therapist', therapistSchema);

export default Therapist;
