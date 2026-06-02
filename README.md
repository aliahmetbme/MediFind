# MediFinder

A modern, "Mobile Engineer Case Study" implementation focusing on clean architecture, maintainability, and exceptional user experience.

MediFinder is a health provider directory application that allows users to seamlessly search, filter, and view detailed profiles of doctors, clinics, and hospitals.

## 📱 Features & Flow
The application implements the required 3-screen flow:
1. **Provider List:** Features a robust search bar, a shimmer loading state, and an edge-to-edge list of healthcare providers.
2. **Filter View:** An advanced filter screen utilizing native sticky action bars and multi-select chips for Country, City, and Specialty.
3. **Provider Detail:** A premium profile screen with immersive imagery, gradients, contact information, and biography.

## 🏗 Architecture & State Management

This application is built using a robust **Feature-First Clean Architecture** combined with the **MVVM (Model-View-ViewModel)** design pattern. It enforces unidirectional data flow, absolute decoupling of layers, and compile-time type safety.

### 📂 Directory Layout

The workspace is organized into highly structured directories:

- **`lib/core/`**: Shared framework-level components and utilities.
  - **`components/`**: Reusable atom widgets (`AppButton`, `ProviderCard`, `FilterChipWidget`, and status layouts under `states/`).
  - **`network/`**: Centralized models (`ResourceState`) and network error mappers.
  - **`router/`**: Declarative routing definition and configuration (`AppRouter`).
  - **`theme/`**: Design system tokens (`AppColors`, `AppTypography`, `AppTheme`).
- **`lib/features/provider_search/`**: Self-contained business logic of the provider search feature.
  - **`data/`**: Repositories implementation, mock datasources, and JSON-based Freezed models.
  - **`domain/`**: Pure business rules, abstract repository contracts, entities, and type-safe enums.
  - **`presentation/`**: Views (`views/`) observing states through ViewModels (`viewmodels/`).

### 🛡 Architectural Core Pillars

#### 1. Decoupled Clean Layering (Presentation, Domain, Data)
- **Domain Isolation:** The domain layer is completely pure. Entities like `ProviderEntity` and `FilterCriteria` are clean Dart objects with no dependency on packages, serialization, or generators.
- **Data Encapsulation:** All API models (`ProviderModel`) and serialization annotations live exclusively in the data layer. Mapping functions cleanly transform data-layer JSON models into pure domain-layer entities.
- **Dependency Inversion:** ViewModels depend purely on the abstract `IProviderRepository` contract rather than the concrete implementation. Concrete implementations are injected at startup, facilitating effortless unit and mock testing.

#### 2. Clean State Management (MVVM + Provider)
- **Sealed State Semantics:** Asynchronous operations are wrapped within a structured `ResourceState` sealed class hierarchy (`Initial`, `Loading`, `Success`, `Empty`, `Error`). The UI performs exhaustive mapping using Dart 3 switch expressions, ensuring compile-time safety.
- **Optimized Rebuild Boundaries:** Views consume states via bounded `Consumer` widgets rather than global context watching, keeping the render pipeline light.
- **Draft Selection Control:** Tapping filter chips inside the Filter page updates a local widget-bound draft (`FilterCriteria`). Global list states are untouched until "Apply" is pressed, preventing unnecessary list re-fetches.

#### 3. Defensive Programming & Deep-Link Safety
- **Centralized String Normalization:** Specialty filters are represented by domain-controlled enums, while country and city filters are data-driven values derived from provider data. They are processed through case-insensitive normalization and structured formatting (e.g. USA, UK, and Title Case fallbacks) to prevent magic string mismatches.
- **Robust Route Restoration:** Deep-linking directly to a detail page is entirely safe. Navigation passes a fast-path cache (`extra: ProviderEntity`) when available, but automatically queries the ViewModel to fetch details by path parameter ID if cold-started or deep-linked.

## 🎨 UI & UX Highlights
- **Premium Aesthetics:** Edge-to-edge cover images in the detail screen, subtle box shadows, and precise typography spacing.
- **Keyboard Safety:** `resizeToAvoidBottomInset: false` ensures that opening the keyboard during a search does not break the layout.
- **Search Debounce:** Search updates are debounced in the ViewModel to avoid per-keystroke repository calls.
- **Draft Filters:** The filter screen uses local draft state and only commits selections when the user taps Apply.
- **Progressive Location Disclosure:** A progressive disclosure UX is implemented for locations: City options remain hidden until a Country is selected, preventing impossible country-city combinations and reducing cognitive load. The transition uses a smooth, hardware-accelerated height expansion animation (`AnimatedSize`).
- **Shimmer Effects:** Instead of a generic spinner, a `ShimmerLoadingWidget` structurally mirrors the provider cards to reduce perceived loading time.
- **Retry Mechanism:** Error states use mapped, user-facing copy and retry actions without exposing raw exception strings.

## 🧪 Testing
The codebase is structured to be highly testable. By injecting `IProviderRepository` into the ViewModel, we can easily inject fakes or mocks.
- **Unit Tests:** ViewModels and Repositories are tested to ensure business logic and state transitions behave predictably. Run tests via `flutter test`.

---
*Developed as a case study demonstration for Senior Mobile Engineering practices.*
