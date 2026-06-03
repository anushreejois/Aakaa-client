# 🩺 Aakaa Therapist App: Core Architecture & Monetization Decisions

This document serves as a persistent record of the strategic business and architectural decisions agreed upon on **May 23, 2026**. It ensures that any future development session retains perfect alignment with our planned workflow and business model.

---

## 💎 1. The Monetization Model

To maximize onboarding volume while maintaining premium quality and platform profitability, we are implementing a **Dual-Engine Monetization Strategy**:

### A. One-Time "Credential Verification & Membership Fee"
*   **Price**: **₹999** (one-time payment).
*   **Purpose**: 
    *   Filters out non-licensed or unserious applicants.
    *   Covers the human operational cost of verifying medical licenses, check credentials, and university degrees.
*   **Risk-Free Hook (Money-Back Guarantee)**: 
    *   If the admin rejects the therapist's verification credentials, the ₹999 fee is **100% refunded automatically**.
    *   To offset onboarding friction, Aakaa will **waive its 20% commission on the therapist's first 2 sessions**, allowing them to make their membership fee back immediately on their first day!

### B. The 20% Platform Commission Fee (Take-Rate)
*   **Rate**: **20% platform fee** deducted from every video, audio, or chat consultation booked.
*   **Example (Video Session @ ₹1,200)**:
    *   Client pays: ₹1,200
    *   Aakaa Commission (20%): ₹240 (minus ~₹39 in WebRTC bandwidth & Razorpay gateway fees = **₹201 Net Platform Profit**).
    *   Therapist Net Share (80%): ₹960 (credited to their bank payout balance).

---

## 🗺️ 2. The Exact End-to-End Therapist Flow

1.  **Registration & Bio**: Therapist fills out basic bio data, uploads their State Medical License credentials, selects therapeutic specialty tags (CBT, Trauma, etc.), and sets custom rates.
2.  **Onboarding Payment**: Right after submitting the registration form, the therapist is directed to a secure payment gateway to pay the ₹999 Onboarding Fee.
3.  **Verification Waiting Room**: Upon successful payment, the therapist enters a soothing, locked "Verification Waiting Room" screen. The dashboard remains locked while Aakaa Admins review the credentials.
4.  **Onboarding Approval**: Once approved, their database status flips to `approved`, immediately unlocking the full Therapist Dashboard on their next login.
5.  **Smart Calendar Availability**: The doctor configures their weekly calendar grid (defining recurring slots, 10-minute session buffers, and emergency off toggles).
6.  **Booking Request Inbox**: Clients book therapists from the directory. The therapist receives real-time booking cards in their inbox to `Approve`, `Reschedule`, or `Decline`.
7.  **Consultation Room (Split View)**: During active slots, the therapist launches a secure WebRTC audio/video call. On tablet/desktop, they see a split UI: client video on the left, and an AES-256 encrypted progress notepad on the right.
8.  **Earnings Settlement**: The session timer hits zero, the channel locks, and transaction split calculations automatically route the net payout to the therapist's ledger showing **Gross**, **Platform Share**, and **Net Settled** payout categories.
