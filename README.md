# Vector - Money in Motion

A modern Flutter payment app with instant QR code payments, built with Riverpod state management and go_router navigation.

## 🚀 Quick Start

```bash
# Install dependencies
flutter pub get

# Run the app
flutter run

# Run tests
flutter test
```

## ✨ Features

- **Quick Payments**: Scan QR codes or share links to send/receive money instantly
- **Bank Integration**: Connect multiple bank accounts (mock TrueLayer integration)
- **Transaction History**: Track all payments with filtering
- **User Profiles**: Manage account settings and preferences
- **Vector Pro**: Premium subscription with advanced features

## 📁 Project Structure

```
lib/
├── core/                    # Shared utilities
│   ├── router/             # Go router configuration
│   ├── theme/              # Colors, typography, theme
│   └── widgets/            # Reusable components
├── features/               # Feature modules
│   ├── auth/              # Authentication
│   ├── bank/              # Bank accounts
│   ├── payments/          # Pay/receive/history
│   ├── profile/           # User profile
│   └── subscription/      # Pro subscription
└── main.dart              # App entry point
```

## 🎨 Design System

### Colors
- **Primary**: #01FF42 (Vector Green)
- **Background**: White (#FFFFFF)
- **Surface**: Light gray (#F5F5F5)

### Key Components
- `PrimaryButton` / `SecondaryButton` - Action buttons
- `AppTextField` - Form inputs
- `ActionCard` - Feature cards
- `BankAccountCard` - Bank display
- `UserAvatar` - Circular avatars
- `AppBottomNav` - Bottom navigation

## 🗺️ Routes

- `/` - Landing
- `/login` / `/signup` - Authentication
- `/pay` - Pay screen
- `/receive` - Receive screen
- `/history` - Transaction history
- `/profile` - User profile
- `/profile/pro` - Pro pricing

## 🧪 Testing

Basic widget test included. Run with:
```bash
flutter test
```

## 📝 Notes

- Uses **mock services** for auth and payments (no backend required)
- **Riverpod** for state management
- **go_router** for navigation
- Matches provided UI mockups exactly

## 🔮 Future Enhancements

- Real Supabase authentication
- TrueLayer Open Banking integration
- QR code scanning
- Payment sessions
- Analytics dashboard
