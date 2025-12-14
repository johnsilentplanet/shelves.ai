# Shelves: Home Book Collection Manager

## Product Requirements Document

**Version:** 2.2
**Date:** December 13, 2025
**Platform:** iOS & Android (Flutter)
**Status:** Draft

---

## Executive Summary

Shelves is a premium cross-platform mobile application for serious book collectors who own hundreds of books and need a comprehensive system to catalog, locate, and explore relationships within their personal library. The app leverages Flutter for a seamless native-quality experience on both iOS and Android, combining rapid ISBN barcode scanning with Firebase AI-powered intelligence to automatically categorize books, discover relationships between titles, and suggest optimal shelf organization schemes.

---

## Problem Statement

Book collectors with large personal libraries face persistent challenges. They don't know what they already own, leading to duplicate purchases. They forget where specific books are stored across multiple shelves, rooms, or boxes. They miss connections between related books in their collection. Manual cataloging is tedious, and existing apps lack intelligent organization beyond basic sorting.

Shelves solves these problems through rapid barcode-based entry, cloud-synced inventory accessible anywhere, and AI that understands books well enough to categorize them meaningfully and surface non-obvious relationships.

---

## Target User

The primary user owns 200-1000+ books distributed across their home. They value their collection and want to know exactly what they have. They may be a theology scholar with shelves of commentaries, a fiction reader with decades of accumulated novels, or a professional with technical libraries spanning multiple disciplines. They've tried spreadsheets or other apps but found them inadequate for a collection of this scale.

Key behaviors: buys books frequently, has books in multiple locations, occasionally lends books and forgets to whom, wants to find "that book I know I have" without searching every shelf.

---

## Technical Stack

| Component | Technology | Rationale |
|-----------|------------|-----------|
| **Framework** | Flutter 3.27+ | Single codebase, native performance, rapid UI development |
| **Language** | Dart 3.6+ | Sound null safety, strong typing, highly productive |
| **State Management** | Riverpod (v2+) | Compile-safe dependency injection, testable, reactive state (Riverpod Generator) |
| **Navigation** | go_router | Declarative routing, deep linking support |
| **Persistence (Primary)** | Cloud Firestore | Single Source of Truth, real-time sync, offline capability |
| **Persistence (Local)** | Isar Database | **For Search Index & Transient Cache ONLY**. Not a full sync mirror. |
| **Cloud Storage** | Firebase Storage | Cover images, location photos |
| **Authentication** | Firebase Auth | Sign in with Apple, Google Sign-In, Email/Password |
| **AI/ML** | Firebase AI (Vertex AI) | Gemini integration for categorization, recommendations, and spine recognition |
| **Barcode Scanning** | Google ML Kit | On-device machine learning, extremely fast ISBN recognition |
| **UI Polish** | flutter_animate, skeletonizer, palette_generator | Premium animations, loading states, and dynamic theming |
| **Purchases** | RevenueCat | In-App Subscriptions and Entitlements management |
| **Book Metadata** | Google Books API, Open Library API | Comprehensive coverage, fallback redundancy |

---

## Feature Specifications

### P0: Core Features (MVP)

#### 1. ISBN Barcode Scanning

**Description:** Rapid book entry via camera-based barcode scanning using Google ML Kit.

**Requirements:**
- Launch scanner from prominent FAB or tab bar button
- Support ISBN-10 and ISBN-13 barcodes (EAN-13 format)
- Continuous scanning mode for batch entry (scan multiple books without dismissing)
- Haptic feedback on successful scan
- Manual ISBN entry fallback for damaged/missing barcodes
- Handle duplicate detection with prompt: "You already own this book. Add another copy?"

**Implementation Notes:**
```dart
// Dependency: google_mlkit_barcode_scanning
// Why: Faster and more accurate than pure camera packages

final barcodeScanner = BarcodeScanner(formats: [BarcodeFormat.ean13]);

void processImage(InputImage image) async {
  final barcodes = await barcodeScanner.processImage(image);
  for (final barcode in barcodes) {
     if (isValidISBN(barcode.rawValue)) {
        // Trigger lookup
     }
  }
}
```

**Acceptance Criteria:**
- Scan-to-result in under 2 seconds on average
- 95%+ successful scan rate under normal lighting
- Works in portrait and landscape orientations

#### 2. Book Metadata Lookup

**Description:** Automatically fetch book details from ISBN.

**Requirements:**
- Primary source: Google Books API
- Fallback source: Open Library API (if Google returns no results)
- Retrieved fields: title, authors, publisher, publication date, page count, description, cover image, categories/subjects
- Cache API responses to Firestore to avoid re-fetching
- Allow manual editing of all retrieved fields
- Support manual entry for books without ISBN (pre-1970, self-published)

**Data Flow (Firestore First):**
```
Scan ISBN → Query Firestore (Do we own it?) → If no, Query Google Books API
    ↓ (no result)
Query Open Library API → Present results → User confirms → Save to Firestore
    ↓ (background)
Update Local Isar Search Index
```

#### 3. Location Management

**Description:** Define and assign physical storage locations for books.

**Requirements:**
- Hierarchical location model: Room → Bookcase → Shelf (e.g., "Office > Bookcase 2 > Shelf 3")
- Support flat locations for simple setups: "Living Room Shelf"
- Optional location photo for visual reference
- Bulk location assignment (select multiple books, assign to location)
- "Where is this book?" quick answer from book detail view

#### 4. Collection Browsing and Search

**Description:** Multiple ways to view and find books in the collection.

**Requirements:**
- **List view:** Sortable by title, author, date added, publication date. Animated entry using `flutter_animate`.
- **Grid view:** Cover image thumbnails. Use `cached_network_image` with `skeletonizer` placeholder.
- **Search:** Instant local search via **Isar Index**.
    - *Note:* We mirror minimal data (ID, Title, Author) to Isar for instant search. Full details fetched from Firestore.
- **Filters:** By location, genre, AI category, user tag, read status
- **Dynamic Theming:** Use `palette_generator` to extract colors from the book cover and theme the details page.

#### 5. Cloud Sync with Firebase

**Description:** Real-time synchronization using Firestore as the primary source of truth.

**Architecture:**
- **Firestore:** Stores the authoritative `Book` and `Location` documents.
- **Offline:** Firestore `persistenceEnabled: true` handles basic offline read/write.
- **Search Index:** On app launch (or background sync), update a lightweight Isar index for full-text search capability (which Firestore lacks natively).

---

### P1: AI-Powered Features

#### 6. Intelligent Categorization

**Description:** Use Firebase AI (Vertex AI) to analyze book metadata and generate meaningful categories.

**Requirements:**
- Analyze title, description, author, and existing categories
- Dimensions: Theme, Setting, Tone, Audience
- Process books in background (Cloud Functions or client-side if quota permits)

#### 7. Spine Recognition (New "Killer Feature")

**Description:** Identify books by scanning their spines on a shelf, useful for books without barcodes or rapid auditing.

**Requirements:**
- User takes photo of a shelf.
- Vertex AI (Gemini Flash multimodal) analyzes the image.
- Returns list of identified titles/authors.
- Match against Google Books API to import.

**Prompt Example:**
> "Identify all book titles and authors visible on the spines in this image. Return as JSON list."

#### 8. Related Books Discovery & Organization

- Surface connections: Same author, Series, Thematic similarity.
- Shelf Organization suggestions based on metadata.

---

### P2: Extended Features

#### 9. Reading Status Tracking
- Enum: unread, reading, completed, abandoned
- Progress bar for 'reading'

#### 10. Lending Tracker
- Track borrower name and date
- Local notifications for return reminders (`flutter_local_notifications`)

#### 11. Wishlist
- Separate "Wishlist" collection
- Share via system sheet

#### 12. Import/Export
- CSV Import/Export
- Goodreads/LibraryThing compatibility

#### 13. Widgets
- iOS Home Screen Widgets (using `home_widget`)
- Android App Widgets

#### 14. Monetization (RevenueCat)
- **Freemium Model:** Core features (Scanning, Inventory) are free.
- **Pro Subscription:** Unlocks AI features (Spine Recognition, Auto-Categorization, Organization suggestions).
- **Implementation:** Use `purchases_flutter` plugin.

---


## User Interface Design

### Design Principles (Modern & Premium)
1.  **Material 3 & Human Interface Guidelines:** Adaptive design.
2.  **Immersive Imagery:** Large cover art, blurs, and sliver app bars.
3.  **Micro-interactions:** `flutter_animate` for list entry, `hero` animations for covers.
4.  **Loading States:** No spinners. Use `skeletonizer` to show UI structure while loading.
5.  **Color:** `palette_generator` to create unique Book Detail vibes.
6.  **App Icon:** Use `square.png` (located in project root) as the source for the app icon.

### Key Screens
-   **Main TabView:** Library | Locations | Discover | Settings
-   **Scanner:** Full screen camera, overlay with cutout, fast recognition.
-   **Book Details:** SliverAppBar with dynamic background color from cover.

---

## Data Models (Dart)

### Book (Firestore Document)

```dart
class Book {
  final String id; // Firestore Doc ID
  final String title;
  final List<String> authors;
  final String? isbn;
  final String? coverImageUrl;
  final String? description;
  
  // Stored as ID string to allow loose coupling
  final String? locationId; 
  
  final DateTime createdAt;
  
  // ... other fields
}
```

### SearchIndex (Isar Local Only)

```dart
@collection
class BookSearchIndex {
  Id id = Isar.autoIncrement; // Local ID
  
  @Index(unique: true, replace: true)
  late String firestoreId;

  @Index(type: IndexType.value, caseSensitive: false)
  late String title;

  @Index(type: IndexType.value, caseSensitive: false)
  late String authorNames; // Space separated for search
}
```

---

## Performance Requirements

| Metric | Target |
|--------|--------|
| App launch (warm) | < 500ms |
| Barcode scan speed | < 100ms detection (ML Kit) |
| List scroll | 60fps (120fps on ProMotion) |
| Search latency | < 50ms (Isar Local Index) |

---

## Project Structure (Flutter Standard)

```
lib/
├── main.dart
├── app/
├── core/
│   ├── theme/
│   ├── widgets/        // Shared widgets (Skeleton, Animations)
├── features/
│   ├── library/
│   ├── scanner/
│   ├── locations/
├── services/
    ├── search_service.dart // Handles Isar Index updates
    ├── firestore_service.dart
    └── ai_service.dart
```

## Success Metrics
-   Crash-free users > 99.5%
-   Scan success rate > 95%
-   Play Store / App Store Rating > 4.5
