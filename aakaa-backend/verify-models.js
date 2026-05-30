import mongoose from 'mongoose';
import User from './models/User.js';
import ActivityLog from './models/ActivityLog.js';
import SessionBooking from './models/SessionBooking.js';
import ChatMessage from './models/ChatMessage.js';

console.log('✅ User Model successfully imported. Schema keys:', Object.keys(User.schema.paths));
console.log('✅ ActivityLog Model successfully imported. Schema keys:', Object.keys(ActivityLog.schema.paths));
console.log('✅ SessionBooking Model successfully imported. Schema keys:', Object.keys(SessionBooking.schema.paths));
console.log('✅ ChatMessage Model successfully imported. Schema keys:', Object.keys(ChatMessage.schema.paths));

console.log('\n🌟 SUCCESS: All models are defined and imported perfectly without any syntax errors!');
process.exit(0);
