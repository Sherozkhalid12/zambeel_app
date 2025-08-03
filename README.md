# Zambeel Store - Premium Storage Solutions

A beautiful, professional Flutter e-commerce app for Zambeel, specializing in flash drives, hard drives, and accessories.

## 🚀 Features

### ✨ Design & Animations
- **Stunning UI/UX**: Modern, professional design with eye-catching aesthetics
- **Smooth Animations**: Beautiful transitions and micro-interactions throughout the app
- **Responsive Design**: Optimized for various screen sizes
- **Professional Theme**: Consistent color scheme and typography

### 📱 Pages & Functionality
1. **Splash Screen**: Animated logo and brand introduction
2. **Home Page**: Featured products, categories, and hero section
3. **Products Page**: Search, filter, and grid layout with animations
4. **Product Detail Page**: Comprehensive product information with add to cart
5. **Cart Page**: Shopping cart management with quantity controls
6. **Profile Page**: User account management and settings
7. **About Page**: Company information and contact details

### 🛍️ E-commerce Features
- **Product Catalog**: Flash drives, hard drives, and accessories
- **Search & Filter**: Find products by category and search terms
- **Shopping Cart**: Add, remove, and manage cart items
- **Product Details**: Specifications, colors, sizes, and features
- **Checkout Process**: Complete purchase flow (demo)

### 🎨 Technical Features
- **State Management**: Provider pattern for efficient state management
- **Navigation**: GoRouter for smooth navigation between pages
- **Image Loading**: Cached network images with shimmer loading
- **Animations**: Staggered animations and micro-interactions
- **Responsive**: Works on various screen sizes

## 🛠️ Technology Stack

- **Framework**: Flutter 3.32.2
- **Language**: Dart 3.8.1
- **State Management**: Provider
- **Navigation**: GoRouter
- **UI Components**: Material Design 3
- **Animations**: Flutter Staggered Animations, Animated Text Kit
- **Icons**: Font Awesome Flutter
- **Image Loading**: Cached Network Image, Shimmer

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  cupertino_icons: ^1.0.8
  lottie: ^3.1.2
  animated_text_kit: ^4.2.2
  flutter_staggered_animations: ^1.1.1
  provider: ^6.1.2
  cached_network_image: ^3.3.1
  shimmer: ^3.0.0
  go_router: ^14.6.2
  font_awesome_flutter: ^10.7.0
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.32.2 or higher)
- Dart SDK (3.8.1 or higher)
- Android Studio / VS Code
- iOS Simulator / Android Emulator

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd zambeel_store
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

## 📱 App Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   ├── product.dart         # Product data model
│   └── cart.dart           # Cart data model
├── providers/
│   ├── product_provider.dart # Product state management
│   └── cart_provider.dart   # Cart state management
├── pages/
│   ├── splash_screen.dart   # Animated splash screen
│   ├── home_page.dart       # Main home page
│   ├── products_page.dart   # Product catalog
│   ├── product_detail_page.dart # Product details
│   ├── cart_page.dart       # Shopping cart
│   ├── profile_page.dart    # User profile
│   └── about_page.dart      # About company
└── widgets/
    ├── product_card.dart    # Product display card
    └── category_card.dart   # Category display card
```

## 🎨 Design System

### Colors
- **Primary**: `#2563EB` (Blue)
- **Secondary**: `#1E40AF` (Dark Blue)
- **Background**: `#F8FAFC` (Light Gray)
- **Text**: `#1F2937` (Dark Gray)
- **Accent**: `#10B981` (Green)

### Typography
- **Font Family**: Poppins
- **Weights**: Regular, Medium, SemiBold, Bold

### Components
- **Cards**: Rounded corners with subtle shadows
- **Buttons**: Gradient backgrounds with hover effects
- **Icons**: Consistent iconography throughout
- **Animations**: Smooth transitions and micro-interactions

## 📋 Product Categories

### Flash Drives
- USB 3.0/3.1 technology
- Various storage capacities
- Premium aluminum casing
- Water-resistant options

### Hard Drives
- External HDDs and SSDs
- High-speed data transfer
- Shock-resistant designs
- Multiple storage options

### Accessories
- USB hubs and adapters
- Cable organizers
- Storage cases
- Professional accessories

## 🔧 Customization

### Adding New Products
1. Update `ProductProvider` in `lib/providers/product_provider.dart`
2. Add product data with required fields
3. Include product images and specifications

### Modifying Theme
1. Update colors in `main.dart`
2. Modify typography in theme configuration
3. Adjust component styles as needed

### Adding New Pages
1. Create new page file in `lib/pages/`
2. Add route in `main.dart` router configuration
3. Update navigation as needed

## 📸 Screenshots

The app features:
- Beautiful splash screen with animations
- Professional home page with featured products
- Comprehensive product catalog with search and filter
- Detailed product pages with specifications
- Full shopping cart functionality
- User profile and account management
- Company information and contact details

## 🚀 Deployment

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License.

## 📞 Support

For support and questions:
- Email: info@zambeel.com
- Phone: +1 (555) 123-4567
- Address: 123 Storage Street, Tech City, TC 12345

---

**Zambeel Store** - Premium Storage Solutions for the modern world.
# zambeel_app
