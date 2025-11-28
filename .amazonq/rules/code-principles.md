# Flutter Navigation 2.0 Application - Code Quality Principles

This is a Flutter application using declarative navigation (Navigator 2.0), Riverpod 3 state management, and state restoration for mobile devices.

# Code Quality Principles

## Testing & Migration
- Test critical user flows after ANY framework upgrade (Riverpod, Flutter, etc.)
- Pay special attention to:
  - Async operations (timers, network calls)
  - Background operations (polling, auto-refresh)
  - Tab switching behavior
  - State restoration
- When migrating, compare behavior with previous version, not just compilation

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

## Proper Encapsulation

### Core Principle: Methods Operate on Their Own Data
- If a method primarily operates on data from another type, it belongs to that type (as instance method or extension)
- Methods taking unrelated data as parameters indicate misplaced responsibility
- Ask: "Does this method need the class's state, or just the parameters?" If just parameters, move it

### Extensions vs Facades: The Decision Criteria
**Use Extensions when:**
- Adding behavior based solely on the type's own data/members
- The operation is a pure function of the type's state
- No external dependencies (like WidgetRef, providers, services) are needed

**Use Facade Methods when:**
- Dealing with cross-cutting concerns (ref access, provider coordination, state management)
- Orchestrating multiple objects or providers
- Business logic that spans multiple domains

**Critical Rule:** Never create extensions that take external dependencies as parameters - this violates Law of Demeter and indicates the logic belongs in a facade

### Framework Detail Encapsulation
- Hide ALL framework implementation details (`.future`, `.value`, `.notifier`, etc.) behind facade methods
- Callers should never know what provider type or framework API is being used
- This enables changing implementations without affecting callers

## Dependency Management
- Prefer tree-like dependency structures over graphs
- Avoid bidirectional dependencies between classes
- Dependencies should flow in one direction (typically: UI → Facades → Providers → Models)
- If two classes need each other, extract shared logic to a third class or use events/callbacks
- Use dependency injection to break circular dependencies

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
- Routes and screens call facade methods ONLY - never access providers directly
- Facades provide clean business-focused APIs that hide technical implementation
- Access restorable providers directly from facades - avoid unnecessary intermediate layers
- Provide utility methods (invalidation, refresh, etc.) as needed

## Declarative UI = f(state)
- Derive UI purely from state - never imperatively manipulate navigation
- Button handlers ONLY change state via facade methods - framework handles rendering
- Avoid imperative navigation calls (stack.push, context.showModal, Navigator.push, etc.)
- Use `topScreen()` to compute overlay screens declaratively from current state
- For background operations (timers, polling), cancel when screen/tab becomes inactive

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
- Put ALL business logic, computed state, and validation in facades
- DO NOT create separate `@riverpod` functions for computed state
- DO NOT put validation logic in routes or screens

**Eliminating Boilerplate:**
- Encapsulate repetitive provider access patterns (like `.value` unwrapping) in private helper methods
- Keep public API clean and focused on business operations
- Private helpers handle technical details (watch vs read, value unwrapping, etc.)
- This maintains encapsulation while reducing repetition

### Async Operations (Riverpod 3)
- Never use `ref` inside async callbacks (Future.delayed, network calls, etc.)
- Capture provider references BEFORE async operations to avoid lifecycle issues
- For tab-based navigation, check if still in current tab before executing background operations

### Routes and Facades
- Routes call single facade methods with meaningful return values (bool for existence checks, etc.)
- Facades handle all validation and state updates
- Use proper lookup methods - never treat IDs as array indices

## Leverage Existing Code
- Use existing framework widgets and utilities instead of reinventing
- Check for helper widgets/utilities BEFORE writing boilerplate
- Reuse patterns consistently across the codebase
- Look for existing abstractions before creating new ones

## Preserving Functionality
- DO NOT remove important details: widget keys, validation logic, state restoration registration, error handling
- Verify functional equivalence when replacing methods
- Test critical paths after refactoring
- Breaking changes are acceptable ONLY if they significantly improve maintainability

## Senior-Level Thinking

### Analyze, Don't Just Follow
- Understand WHY a principle exists, not just WHAT it says
- Identify patterns and anti-patterns proactively across the entire codebase
- Fix systemic issues, not just symptoms
- Ensure consistency - if you fix something in one place, check if the same issue exists elsewhere

### Question and Improve
- If a method takes data as a parameter instead of using class members, ask: "Should this be an extension on that type?"
- If you see repetitive code, ask: "Can this be encapsulated in a helper method?"
- If you see external dependencies in extensions, ask: "Should this be a facade method instead?"
- If you see circular dependencies, ask: "How can I restructure this into a tree?"

### Apply Principles Holistically
- Don't just fix the example shown - analyze the entire codebase for similar issues
- Maintain architectural consistency - all facades should follow the same patterns
- Think about maintainability, testability, and extensibility
- Balance purity with pragmatism - perfect is the enemy of good

### Key Questions to Ask
1. **Encapsulation**: Does this method operate on its own class's data?
2. **Responsibility**: Does this class/method have a single, clear purpose?
3. **Dependencies**: Are dependencies unidirectional? Any circular references?
4. **Abstraction**: Are framework details hidden behind clean interfaces?
5. **Consistency**: Does this follow the same pattern as similar code elsewhere?
6. **Simplicity**: Is this the minimal code needed, or am I over-engineering?
