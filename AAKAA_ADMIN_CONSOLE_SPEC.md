# 🛠️ Aakaa Platform: Admin Console Architecture & Access Control Specification

This document details the functional workflow, technical stack, and security protocols required to build and access the **Aakaa Admin Console**.

---

## 🗺️ 1. Where Will the Admin Console Be Accessed?

The Admin Console is structured as a secure Web-based interface (rather than a mobile app) for ease of document review and administrative workflows.

*   **Access URL**: Typically hosted on a sub-domain (e.g., `https://admin.aakaa.com`) or a protected web route (e.g., `https://aakaa.com/admin`).
*   **Target Users**: Aakaa internal operations staff, clinical review board members, and finance administrators.

---

## 🔒 2. How Access Control is Managed (Security)

Security is managed via **Role-Based Access Control (RBAC)** implemented at both database and router levels:

### A. Database Layer (`User` Schema)
The User model contains a `role` field. Only users flagged with `'admin'` can gain access:
```javascript
role: {
  type: String,
  enum: ['client', 'therapist', 'admin'],
  default: 'client'
}
```

### B. Backend Route Middleware Layer (`adminAuth.js`)
An Express middleware intercepts all admin API routes to verify JWT signature and admin roles:
```javascript
// middleware/adminAuth.js
import User from '../models/User.js';

export default async function adminAuth(req, res, next) {
  try {
    // 1. Verify JWT token (populated by standard auth middleware)
    const user = await User.findById(req.userId);
    if (!user || user.role !== 'admin') {
      return res.status(403).json({
        status: 'error',
        message: 'Access Denied: Administrative privileges required.'
      });
    }
    next();
  } catch (err) {
    res.status(500).json({ status: 'error', message: 'Server authentication error.' });
  }
}
```

---

## 🖥️ 3. How the Admin Console Works (Key Dashboards)

The web console consists of two primary operational queues:

### Queue A: Therapist Credentials Verification
*   **The Problem**: Caregivers register and upload license certificates but cannot practice yet.
*   **The Visual Queue**: A table listing all therapists with status `pending`.
*   **The Action**:
    1.  Admin clicks **"View Document"** (opens their uploaded S3 license PDF file in a new tab).
    2.  Admin checks name matching and credentials status.
    3.  Admin clicks **"Approve"** (calls `PUT /api/admin/therapists/:id/verify` with `status: 'approved'`).
    4.  The system flips their database state to `'approved'`, instantly unlocking the caregiver's mobile dashboard app, and triggers a congratulatory confirmation email.

### Queue B: Payout Settlement Dashboard
*   **The Problem**: Caregivers request withdrawals of their settled consultation earnings.
*   **The Visual Queue**: A list of all pending withdrawal requests containing the therapist's bank coordinates (Account Number, IFSC, UPI ID) and the requested payout sum.
*   **The Action**:
    1.  Admin logs into their payout portal (e.g. RazorpayX, Stripe Payouts, or net banking) and transfers the amount to the destination account.
    2.  Admin returns to the Aakaa Console and clicks **"Confirm Settlement"** (calls `PUT /api/admin/withdrawals/:id/settle`).
    3.  The system deducts the sum from the therapist's available balance and updates the transaction log status to `'settled'`.
