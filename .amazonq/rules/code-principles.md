# Flutter Navigation 2.0 Application - Code Quality Principles

This is a Flutter application using declarative navigation (Navigator 2.0), Riverpod 3 state management, and state restoration for mobile devices.

# Code Quality Principles

## Minimal Code
- Write ONLY the absolute minimal code needed
- Ensure every line directly contributes to the solution
- Make refactored code SHORTER, not longer
- Reconsider any approach that increases line count
- DO NOT add unnecessary abstractions or wrapper classes
- DO NOT create helper methods for single-use logic

## SOLID & OOP
- Give each class/method one clear purpose (Single Responsibility)
- Hide implementation behind clean interfaces (Encapsulation)
- Keep internal state structure hidden from callers (Information Hiding)
- Centralize logic in one place, never duplicate (DRY)
- Depend on abstractions, not concrete implementations (Dependency Inversion)
- Minimize dependencies between components (Low Coupling)
- DO NOT chain method calls (e.g., `ref.read().notifier.select()`)
- Follow the Law of Demeter - objects should only talk to immediate neighbors

## Separation of Concerns
- **Screens**: UI rendering ONLY - no business logic, no state management
- **Routes**: URL parsing and navigation paths ONLY - no business logic
- **Facades**: Business logic and state management ONLY
- DO NOT mix concerns:
  - NO state logic in routes
  - NO business logic in screens
  - NO navigation logic in facades
- Keep application logic separate from framework/library code

## Framework Abstraction
- Wrap complex framework APIs behind simple interfaces
- Hide Navigator 2.0/Router complexity in library classes
- Provide standard patterns (e.g., `fromUri(Uri)` for route parsing)
- Wrap verbose framework code in clean abstractions
- DO NOT sacrifice good design for framework idioms
- DO NOT expose Riverpod providers directly to screens or routes

## Facade Pattern
- Encapsulate ALL framework/library implementation details in facades
- Make routes and screens call facade methods ONLY
- DO NOT let routes or screens access providers directly
- Provide utility methods in facades (e.g., `invalidate(ref)`)
- Access restorable providers directly from facades - NO intermediate notifiers

**Correct pattern:**
```dart
// In screen/route:
storiesProvider.setCurrentStory(ref, id)

// Inside facade:
ref.read(restorableCurrentStoryIdProvider).value = id
```

**WRONG pattern:**
```dart
// DO NOT do this:
ref.read(currentStoryIdProvider.notifier).select(id)
```

## Declarative UI = f(state)
- Derive UI purely from state
- ONLY change state - let the framework render UI automatically
- DO NOT imperatively manipulate navigation:
  - NO `stack.push()`
  - NO `context.showModal()`
  - NO `Navigator.of(context).push()`
  - NO similar imperative calls
- Make button handlers call facade methods to update state, NOTHING ELSE
- Let state changes trigger automatic UI re-renders via `topScreen()`
- Use `topScreen()` to compute overlay screens from current state

**Correct pattern:**
```dart
onPressed: () => facade.showDialog(ref)
```

**WRONG pattern:**
```dart
// DO NOT do this:
onPressed: () {
  facade.showDialog(ref);
  context.showModal(...);
}
```

## State Management

### Architecture
- Use TWO-layer architecture ONLY:
  1. **Restorable providers**: State definition
  2. **Facades**: Business logic and state access
- DO NOT create middle notifier layer
- DO NOT create `@riverpod class` notifiers that just forward to restorable providers

### Restorable Providers
- Define state with `restorableProvider<RestorableInt/Bool/etc>` for state restoration
- Register ALL restorable providers in `globalRestorableProviders` list

### Facades
- Put ALL business logic in facades
- Put ALL computed state logic in facade methods
- Put ALL validation logic in facades
- Access restorable providers directly: `ref.watch(provider).value` and `ref.read(provider).value = x`
- DO NOT create separate `@riverpod` functions for computed state
- DO NOT put validation logic in routes or screens

### Routes and Facades
- Make routes call single facade methods (e.g., `selectBookIfExists(ref, id)`)
- Return meaningful results from facades (e.g., bool for existence checks)
- Use proper lookup methods - IDs are NOT array indices

**Example:**
```dart
// Restorable provider:
final restorableCounterProvider = restorableProvider<RestorableInt>(
  create: (ref) => RestorableInt(0),
  restorationId: 'counter',
);

// Facade:
class CounterDataAccess {
  static int getValue(WidgetRef ref) => 
      ref.watch(restorableCounterProvider).value;
  
  static void increment(WidgetRef ref) => 
      ref.read(restorableCounterProvider).value++;
}
```

## Leverage Existing Code
- Use existing framework widgets (e.g., `AsyncValueAwaiter`) instead of verbose `.when()` calls
- DO NOT reinvent what exists in the codebase
- Check for helper widgets/utilities BEFORE writing boilerplate
- Reuse patterns consistently across the codebase
- Look for existing abstractions before creating new ones

## Preserving Functionality
- DO NOT remove important details:
  - Widget keys
  - Validation logic
  - State restoration registration
  - Error handling
- Verify functional equivalence when replacing methods
- Test critical paths after refactoring
- Breaking changes are acceptable ONLY if they improve maintainability significantly
