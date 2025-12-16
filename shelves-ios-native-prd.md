# Shelves: Native iOS Edition

## Product Requirements Document
**Version:** 1.0 (Native Pivot)
**Date:** December 15, 2025
**Platform:** iOS 17.0+ (SwiftUI)
**Architecture:** Model-View-Controller (Modern), Observable Pattern
**Status:** Draft

---

## Executive Summary
Shelves is a premium native iOS application for book collectors. It pivots from the previous cross-platform Flutter iteration to a pure native experience, leveraging the latest Apple technologies (SwiftUI, SwiftData, VisionKit) to deliver an app that feels completely at home on iOS.

## Architectural Vision: "Forget MVVM"
Following modern SwiftUI best practices (2025 era), we reject the rigid MVVM boilerplate in favor of a simpler, more reactive data flow enabled by the `@Observable` macro.

### Core Principles
1.  **View-Model Fusion:** Views own their transient state. We do NOT create a matching `ViewModel` for every `View`.
2.  **Observable Models:** Our data models (e.g., `Book`, `User`) are simple `@Observable` classes or pure structs held by observable stores.
3.  **Environment Controllers:** Application-wide state (Auth, Library, Navigation) is managed by "Controllers" (or Stores) injected via `.environment`.
    *   *Example:* `AuthManager`, `LibraryStore`.
4.  **Composition:** Logic is extracted into reusable view modifiers or service extensions, not massive ViewModel classes.

---

## Technical Stack

| Component | Technology | Rationale |
|-----------|------------|-----------|
| **Language** | Swift 5.9+ | Modern concurrency (async/await), macros. |
| **Framework** | SwiftUI (iOS 17) | Declarative UI, latest Animations/Transitions. |
| **State Management** | `@Observable` | No more `ObservableObject`/`@Published`. Granular change tracking. |
| **Persistence (Cloud)** | Firebase Firestore | Single Source of Truth. |
| **Persistence (Local)** | SwiftData | For offline caching and instant search. Simple `@Model` Syntax. |
| **Scanning** | VisionKit | Native `DataScannerViewController` for seamless "Live Text" style barcode scanning. |
| **AI** | Firebase Vertex AI | Gemini integration. |
| **Auth** | Firebase Auth | Native SDKs (Apple, Google, Email). |
| **Purchases** | RevenueCat | Subscription management. |

---

## Feature Specifications

### 1. Unified Authentication (AuthManager)
*   **Role:** Single source of truth for user session.
*   **Architecture:** `AuthManager` class annotated with `@Observable`. Injected at `App` root.
*   **Features:**
    *   Sign in with Apple (Native `AuthenticationServices`).
    *   Sign in with Google.
    *   Email/Password fallback.
    *   Auto-redirects main view based on `authManager.user` state.

### 2. Live Barcode Scanning (VisionKit)
*   **Component:** `DataScannerViewController` wrapped in `UIViewControllerRepresentable`.
*   **Behavior:**
    *   Live viewfinder that highlights ISBNs.
    *   "Tap to Add" or "Continuous Scan" modes.
    *   No external camera dependencies; purely native iOS Vision stack.
    *   **Haptics:** `UIImpactFeedbackGenerator` upon detection.

### 3. The Library (SwiftData + Firestore)
*   **Data Flow:**
    *   Firestore is authoritative.
    *   SwiftData uses `@Model` to mirror necessary fields for instant search (Spotlight-like feel).
    *   List View uses `@Query` for minimal boilerplate and automatic UI updates.
*   **UI:**
    *   Grid/List toggle.
    *   **Context Menus:** Heavy use of native iOS context menus (Long press to organize, delete, share).
    *   **Search:** `.searchable()` modifier attached to the Library List.

### 4. Book Details & Metadata
*   **Architecture:** Fetch logic lives in a `BookService` actor, not the view.
*   **Sources:** Google Books API, with fallback to Open Library.
*   **Experience:**
    *   Fluid transitions (`.navigationTransition(.zoom)`).
    *   Dynamic background gradients using `Color` extraction from cached `UIImage`.

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

### 7. Reading Status & Statistics
*   **Goal:** Drive daily engagement.
*   **Features:**
    *   **Status:** Unread, Reading, Read, Abandoned.
    *   **Progress:** Track current page vs total pages.
    *   **Shareable Card:** Generate an Instagram Story format image ("My 2025 Stats").
    *   **Dashboard:** "Currently Reading" carousel on top of the Library view.

### 8. Gamification (Retention)
*   **Goal:** User lock-in during onboarding.
*   **Mechanic:** "Scan 5 books to unlock the custom App Icon."
*   **Implementation:** check `user.scanCount`, programmatically change `UIApplication.shared.setAlternateIconName`.

### 9. Waitlist Conversion
*   **Goal:** Convert pre-launch signups to Pro.
*   **Mechanism:** Deep Link (`shelves://redeem?code=WAITLIST`) or manual code entry in Settings.
*   **Reward:** Grant 3-months Pro entitlement via RevenueCat.

### 10. Import & Export
*   **Goal:** Allow users to migrate from Goodreads/CLZ and own their data.
*   **Import:** Parse standard Goodreads CSV export.
*   **Export:** Generate JSON/CSV backup of the Library.
*   **Note:** Native Goodreads Sync is NOT possible due to API deprecation (2020).

### 11. Data Models
We use `Codable` structs for Firestore (network) and `@Model` classes for SwiftData (local persistence).

#### Book (SwiftData + Firestore Mirror)
```swift
@Model
final class Book {
    @Attribute(.unique) var id: String // Firestore Document ID
    var title: String
    var authors: [String]
    var isbn: String?
    var coverImageUrl: String?
    var descriptionText: String? // 'description' is reserved in Swift
    var locationId: String?
    var dateAdded: Date

    // Reading Status (Marketing Hook)
    var readingStatus: ReadingStatus // Enum: unread, reading, read, abandoned
    var currentPage: Int
    var pageCount: Int
    var rating: Int? // 1-5 stars

    // Loaning
    var isLoaned: Bool = false
    var loaneeName: String?
    var loanDate: Date?
    var dueDate: Date?

    // Transient/Computed properties logic excluded from persistence
}

enum ReadingStatus: String, Codable {
    case unread, reading, read, abandoned
}
```

#### User (Firestore Only)
```swift
struct UserProfile: Codable {
    let id: String
    let email: String
    var displayName: String?
    var isOnboarded: Bool
    
    // Gamification & Retention
    var scanCount: Int // Drives "5 scans" unlock
    var joinDate: Date
    var isPro: Bool    // RevenueCat source of truth
}
```

---

## Project Structure

```text
Shelves/
├── App
│   ├── ShelvesApp.swift      // Entry point, injects environment
│   └── AppController.swift   // High-level app state coordinator
├── Models
│   ├── Book.swift            // SwiftData @Model / Firestore Codable
│   └── User.swift
├── Views
│   ├── Auth
│   │   └── LoginScreen.swift
│   ├── Library
│   │   ├── LibraryList.swift
│   │   └── BookDetailView.swift
│   └── Scanner
│       └── VisionScannerView.swift
├── Stores (Controllers)
│   ├── AuthManager.swift     // Authentication Logic
│   └── LibraryStore.swift    // Firestore Sync Logic
├── Services
│   ├── GoogleBooksAPI.swift
│   └── VertexAIService.swift
└── Resources
    └── Assets.xcassets
```

## Setup Steps
1.  **Xcode:** Create new iOS App project (SwiftUI + SwiftData).
2.  **Dependencies:** Add Firebase via Swift Package Manager (SPM).
3.  **Capabilities:** Enable "Sign In With Apple", "Camera".

---

## Migration Note
This PRD replaces the Flutter implementation (`shelves-prd.md`). Data schema (Firestore) remains compatible, allowing seamless transition for existing database records.
