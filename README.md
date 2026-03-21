# Cheers - Kozhikode Nightlife Discovery App

Hyper-local nightlife, hospitality, and lifestyle discovery platform for Kozhikode.

## Architecture

```
┌─────────────┐                              ┌──────────────┐
│  Flutter App │──── (Public read APIs) ────▶│              │
│  (Mobile)    │                              │  API Gateway │──▶ C# Lambda ──▶ DynamoDB
└─────────────┘                              │  (REST API)  │
                                              │              │
┌─────────────┐                              │              │
│ Admin Panel  │──── (Admin write APIs) ────▶│              │
│ (Flutter Web)│     (X-Admin + Bearer)       └──────────────┘
└─────────────┘
```

## Project Structure

```
CheersApp/
├── lib/                    # Consumer Flutter app (mobile)
│   ├── main.dart
│   ├── theme/
│   ├── models/
│   ├── services/
│   ├── providers/
│   ├── widgets/
│   └── screens/
│       ├── auth/           # Login, OTP, age verification
│       ├── home/           # Discovery engine, navigation
│       ├── venue/          # Venue details
│       ├── events/         # Events listing
│       ├── offers/         # Offers & promotions
│       ├── jobs/           # Job marketplace
│       ├── profile/        # User profile, referral, points
│       └── notifications/  # Push notifications
├── admin/                  # Admin Flutter web app (separate)
│   ├── lib/
│   │   ├── main.dart
│   │   ├── services/       # Admin API with auth headers
│   │   ├── widgets/        # Form dialogs
│   │   └── screens/
│   │       ├── admin_login_screen.dart
│   │       ├── dashboard_screen.dart
│   │       ├── manage_venues_screen.dart
│   │       ├── manage_events_screen.dart
│   │       ├── manage_offers_screen.dart
│   │       └── manage_jobs_screen.dart
│   └── web/
├── backend/src/            # C# Lambda backend
│   ├── Models/
│   ├── Services/
│   └── Functions/          # API handler with admin auth guard
└── infra/                  # AWS CDK infrastructure
    └── lib/
```

## Setup

### Consumer App (Mobile)

```bash
flutter pub get
flutter run
```

Use "Enter Demo Mode" on the login screen to explore with sample data.

### Admin Panel (Web)

```bash
cd admin
flutter pub get
flutter run -d chrome
```

Login: admin@cheers.app / admin123

### Backend Deployment

```bash
cd backend/src
dotnet publish -c Release

cd ../../infra
cdk bootstrap
cdk deploy
```

After deployment, update the API URL in:
- `lib/services/api_service.dart` (consumer app)
- `admin/lib/services/admin_api_service.dart` (admin panel)

## API Security

| Route Type | Auth Required | Who Can Access |
|-----------|--------------|----------------|
| GET /venues, /events, /offers, /jobs | User token | All users |
| POST /auth/*, GET /users/* | None/User | All users |
| POST /venues, /events, /offers, /jobs | Admin token + X-Admin header | Admin only |
| DELETE /venues/*, /events/*, etc. | Admin token + X-Admin header | Admin only |
| GET /admin/analytics | Admin token + X-Admin header | Admin only |

## DynamoDB Tables

| Table | Partition Key |
|-------|--------------|
| cheers_users | uid |
| cheers_venues | id |
| cheers_events | id |
| cheers_offers | id |
| cheers_jobs | id |
| cheers_points | user_id |

## Features

### Consumer App
- Phone + OTP authentication with 21+ age verification
- Venue discovery with category filtering
- Events with live status badges (Live/New/Join/Coming/Offers)
- Offers & promotions with redeem functionality
- Job marketplace with apply button
- Loyalty points system
- Referral system with share links
- Push notifications

### Admin Panel
- Secure admin login (email + password)
- Dashboard with analytics (venue/event/offer/job counts)
- CRUD management for venues, events, offers, jobs
- Data tables with add/delete actions
- Sidebar navigation
