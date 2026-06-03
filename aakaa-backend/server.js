import 'dotenv/config';
import express from 'express';
import mongoose from 'mongoose';
import cors from 'cors';
import authRouter from './routes/auth.js';
import userRouter from './routes/user.js';
import paymentRouter from './routes/payment.js';
import agoraRouter from './routes/agora.js';
import chatRouter from './routes/chat.js';
import reportsRouter from './routes/reports.js';
import aiRouter from './routes/ai.js';
import therapistRouter from './routes/therapist.js';
import notificationRouter from './routes/notification.js';

const app = express();
const PORT = process.env.PORT || 5000;
const MONGODB_URI = process.env.MONGODB_URI || 'mongodb://localhost:27017/aakaa';

// Middleware
app.use(cors());
app.use(express.json());

// Routes
app.use('/api/auth', authRouter);
app.use('/api/users', userRouter);
app.use('/api/payments', paymentRouter);
app.use('/api/agora', agoraRouter);
app.use('/api/chat', chatRouter);
app.use('/api/reports', reportsRouter);
app.use('/api/ai', aiRouter);
app.use('/api/therapist', therapistRouter);
app.use('/api/notifications', notificationRouter);

// Basic Health Check Route
app.get('/', (req, res) => {
  res.json({
    status: 'success',
    message: 'Welcome to Aakaa Mental Health Platform API',
    version: '1.0.0',
    timestamp: new Date()
  });
});

// Database Connection & Server Startup
mongoose
  .connect(MONGODB_URI)
  .then(() => {
    console.log('✅ Connected to MongoDB successfully.');
    app.listen(PORT, () => {
      console.log(`🚀 Server is running on http://localhost:${PORT}`);
    });
  })
  .catch((err) => {
    console.error('❌ MongoDB connection error:', err.message);
    process.exit(1);
  });
