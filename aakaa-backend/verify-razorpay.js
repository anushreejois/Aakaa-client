import 'dotenv/config';
import Razorpay from 'razorpay';

console.log('Testing Razorpay Connection...');
console.log('RAZORPAY_KEY_ID:', process.env.RAZORPAY_KEY_ID);
console.log('RAZORPAY_KEY_SECRET:', process.env.RAZORPAY_KEY_SECRET ? 'Exists (******)' : 'Undefined ❌');

const razorpay = new Razorpay({
  key_id: process.env.RAZORPAY_KEY_ID,
  key_secret: process.env.RAZORPAY_KEY_SECRET
});

async function test() {
  try {
    const orders = await razorpay.orders.all({ count: 1 });
    console.log('✅ SUCCESS! Your Razorpay keys are authentic and working perfectly.');
  } catch (err) {
    console.error('❌ RAZORPAY ERROR:', err);
  }
}

test();
