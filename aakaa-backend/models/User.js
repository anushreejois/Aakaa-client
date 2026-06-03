import mongoose from 'mongoose';

const userSchema = new mongoose.Schema({
  uid: {
    type: String,
    unique: true,
    sparse: true // Allows null/empty for users before full integration
  },
  email: {
    type: String,
    required: true,
    unique: true,
    trim: true,
    lowercase: true
  },
  password: {
    type: String,
    required: true
  },
  fullName: {
    type: String,
    required: true,
    trim: true
  },
  role: {
    type: String,
    enum: ['client', 'therapist'],
    default: 'client'
  },
  subscriptionTier: {
    type: String,
    enum: ['freemium', 'basic', 'standard', 'premium'],
    default: 'freemium'
  },
  streakCount: {
    type: Number,
    default: 0
  },
  avatarUrl: {
    type: String,
    default: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop'
  },
  gender: {
    type: String,
    enum: ['Male', 'Female', 'Other'],
    default: 'Female'
  },
  mindfulMinutes: {
    type: Number,
    default: 0
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const User = mongoose.model('User', userSchema);

export default User;
