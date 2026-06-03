# 🚀 Aakaa Project Roadmap: Client-Side Completion Priority

As agreed on **May 23, 2026**, we will **100% complete all client-side integrations and features** before starting implementation work on the Therapist Companion App (`therapists_ui`).

---

## 📅 Remaining Client-Side Phases (To Execute Next)

### 🔒 1. Phase 2: Profile Persistence & Token Validation
*   Ensure the profile screen (`clientprofile.dart` / `clienteditprofile.dart`) fetches active subscription tiers, streaks, and user details via secure JWT backend calls (`GET /api/users/profile`).
*   Ensure updates to names or subscription plans sync back to the database (`PUT /api/users/profile`).

### 💳 2. Phase 3: Live Payment Gateway Integration
*   Build the Stripe/Razorpay backend order route (`POST /api/payments/create-order`).
*   Integrate payment gateway SDK inside Flutter's `payment_screen.dart` to replace simulations.
*   Implement secure payment webhooks on the Node.js backend to instantly upgrade user subscriptions in MongoDB Atlas.

### 📞 3. Phase 4: Agora WebRTC Tele-Therapy Consultation
*   Create backend token generator `/api/agora/generate-token`.
*   Integrate Agora Flutter SDK inside `video_call_screen.dart` and `audio_call_screen.dart` for secure, low-latency client consultations.

### 🤖 4. Phase 5: AI Clinical Coach (Gemini/Claude)
*   Build `/api/ai/analyze-journal` on the backend.
*   Send client journal logs through a clinical system prompt to analyze cognitive distortions.
*   Beautifully render the CBT advice on the client's journal details screen.

### 📄 5. Phase 6: certified Progress Reports & Audio Sanctuaries
*   Backend PDF rendering for monthly progress charts.
*   Enable streaming of high-quality sleep sanctuaries from Cloud storage.
