# 🩺 Aakaa Therapist App: Final Production Deliverables & Roadmap

This document serves as the master checklist of remaining modules required to bring the **Aakaa Therapist Companion App** (`aakaa_therapist`) to a fully polished, final production-ready state.

---

## 🏁 Summary of Completed Features

The core system architecture has been successfully built and synced to the repository:
*   **Encrypted Notes (Option 3)**: Secure client-side symmetric AES encryption for clinical consultation notepad sessions.
*   **Calendar Sync (Option 4)**: Dynamically pulling and pushing the availability matrix settings from MongoDB.
*   **Real Earnings ledger (Option A)**: 80/20 transaction split calculator returning dynamic gross, commission, net, pending, and settled payout structures.
*   **Onboarding Payment Gateway & Gated Waiting Room**: Seamless registration redirecting to a membership payment simulator (₹999 fee) and locking pending accounts inside an administrative credentials waiting room.

---

## 🛠️ The 5 Final Deliverables (To Complete the Platform)

To move this application into production, the following 5 modules need to be implemented:

### 1. Administrative Approval Console
*   **Description**: A secure set of endpoints to manage therapist credentials verification.
*   **Backend Endpoints Required**:
    *   `GET /api/admin/therapists/pending`: Retrieve all therapists whose `verificationStatus` is `'pending'`.
    *   `PUT /api/admin/therapists/:id/verify`: Flip verification status to `'approved'` or `'rejected'`.
*   **Goal**: Provide a mechanism (either a simple script or a backend router) to unlock verified therapists' access to the dashboard.

### 2. Interactive Booking Reschedule Flow
*   **Description**: Connecting the "Reschedule" button in the caregiver's inbox to an actual scheduler.
*   **Workflow**:
    1.  Caregiver selects "Reschedule" on a booking card.
    2.  Presents a calendar view highlighting the therapist's configured practice slots.
    3.  Proposes a new date/time, shifting the status of the `SessionBooking` to `'rescheduled'`.
    4.  Client app receives a notification card to accept or decline the proposal.

### 3. Payout Withdrawal Queue Clearances
*   **Description**: Managing bank settlement transactions.
*   **Workflow**:
    1.  The therapist triggers "Withdraw Settled Funds" from their Earnings tab.
    2.  Creates a payout ticket containing bank account coordinates (IFSC, Account Number, Name) or UPI IDs.
    3.  Admin clears requests in batches. Available balances adjust dynamically:
        *   `settledPayout = totalNet - pendingPayout - withdrawnAmount`.

### 4. Tele-Consultation Call Polish
*   **Description**: High-fidelity UI details inside the secure video call room.
*   **Enhancements**:
    *   **Signal Strength Bar**: Visual feedback on WebRTC stream quality and network latency.
    *   **Therapeutic Soundboard**: Calm micro-interactions (e.g. mindfulness bell audio clips) during session starts and ends.
    *   **Secure Floating Overlay**: Mini video preview windows when typing notes.

### 5. Real-Time Push Notifications (FCM / WebSockets)
*   **Description**: Keeping therapists responsive during active business hours.
*   **Workflow**:
    *   Installs Firebase Cloud Messaging (FCM) triggers or WebSocket listeners.
    *   Triggers instant, high-priority notifications for:
        1.  New booking requests.
        2.  Client cancellations.
        3.  Real-time chat messages.

---

## 📈 Suggested Testing Sequence (For Later)
When resuming this project, run tests in this order:
1.  **Launch Backend**: `npm run dev` inside `aakaa-backend`.
2.  **Launch App**: `flutter run` inside `aakaa_therapist`.
3.  **Onboard Test**: Create a doctor profile $\rightarrow$ Pay ₹999 $\rightarrow$ Run Mongo script to approve status $\rightarrow$ Test dashboard features.
