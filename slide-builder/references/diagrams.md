# Slidev Diagrams Reference

## Mermaid Diagrams

Slidev has built-in Mermaid support.

### Flowchart

```markdown
```mermaid
graph TD
    A[Start] --> B{Is it working?}
    B -->|Yes| C[Great!]
    B -->|No| D[Debug]
    D --> B
```
```

Direction options: `TD` (top-down), `TB`, `BT`, `LR` (left-right), `RL`

### Flowchart with Styling

```markdown
```mermaid
graph LR
    A[Hard edge] -->|Link text| B(Round edge)
    B --> C{Decision}
    C -->|One| D[Result one]
    C -->|Two| E[Result two]

    style A fill:#f9f,stroke:#333
    style B fill:#bbf,stroke:#333
```
```

### Sequence Diagram

```markdown
```mermaid
sequenceDiagram
    participant Browser
    participant Server
    participant Database

    Browser->>Server: HTTP Request
    activate Server
    Server->>Database: Query
    activate Database
    Database-->>Server: Results
    deactivate Database
    Server-->>Browser: JSON Response
    deactivate Server
```
```

### Sequence with Notes

```markdown
```mermaid
sequenceDiagram
    Alice->>+John: Hello John
    Note right of John: Thinking...
    John-->>-Alice: Hi Alice!
    Note over Alice,John: They are friends
```
```

### Class Diagram

```markdown
```mermaid
classDiagram
    Animal <|-- Duck
    Animal <|-- Fish
    Animal : +int age
    Animal : +String gender
    Animal: +isMammal()
    Animal: +mate()

    class Duck{
        +String beakColor
        +swim()
        +quack()
    }

    class Fish{
        -int sizeInFeet
        -canEat()
    }
```
```

### State Diagram

```markdown
```mermaid
stateDiagram-v2
    [*] --> Idle
    Idle --> Processing: Start
    Processing --> Success: Complete
    Processing --> Error: Fail
    Success --> [*]
    Error --> Idle: Retry
```
```

### Entity Relationship Diagram

```markdown
```mermaid
erDiagram
    CUSTOMER ||--o{ ORDER : places
    ORDER ||--|{ LINE-ITEM : contains
    CUSTOMER {
        string name
        string email
    }
    ORDER {
        int orderNumber
        date created
    }
    LINE-ITEM {
        string product
        int quantity
    }
```
```

### Gantt Chart

```markdown
```mermaid
gantt
    title Project Timeline
    dateFormat  YYYY-MM-DD
    section Design
    Research           :a1, 2024-01-01, 7d
    Wireframes         :a2, after a1, 5d
    section Development
    Frontend           :b1, after a2, 14d
    Backend            :b2, after a2, 14d
    section Testing
    QA                 :c1, after b1, 7d
```
```

### Pie Chart

```markdown
```mermaid
pie title Browser Market Share
    "Chrome" : 65
    "Safari" : 19
    "Firefox" : 4
    "Edge" : 4
    "Other" : 8
```
```

### Git Graph

```markdown
```mermaid
gitGraph
    commit
    commit
    branch develop
    checkout develop
    commit
    commit
    checkout main
    merge develop
    commit
```
```

### Journey Map

```markdown
```mermaid
journey
    title User Onboarding
    section Sign Up
      Visit website: 5: User
      Click sign up: 4: User
      Fill form: 3: User
    section Activation
      Verify email: 4: User
      Complete profile: 3: User
    section First Use
      View dashboard: 5: User
      Create first item: 4: User
```
```

### Mindmap

```markdown
```mermaid
mindmap
  root((Project))
    Frontend
      React
      TypeScript
      Tailwind
    Backend
      Node.js
      PostgreSQL
      Redis
    DevOps
      Docker
      Kubernetes
      CI/CD
```
```

### Timeline

```markdown
```mermaid
timeline
    title Company History
    2020 : Founded
         : First product
    2021 : Series A
         : 50 employees
    2022 : Series B
         : Global expansion
    2023 : IPO
```
```

### Quadrant Chart

```markdown
```mermaid
quadrantChart
    title Technology Assessment
    x-axis Low Effort --> High Effort
    y-axis Low Impact --> High Impact
    quadrant-1 Quick Wins
    quadrant-2 Major Projects
    quadrant-3 Fill Ins
    quadrant-4 Avoid
    Feature A: [0.3, 0.8]
    Feature B: [0.7, 0.9]
    Feature C: [0.2, 0.3]
    Feature D: [0.8, 0.2]
```
```

### Mermaid Theming

```markdown
```mermaid {theme: 'dark'}
graph LR
    A --> B
```
```

Available themes: `default`, `dark`, `forest`, `neutral`

---

## PlantUML

Enable PlantUML (requires server or local installation):

```yaml
# In frontmatter or vite.config.ts
plantuml:
  server: 'https://www.plantuml.com/plantuml'
```

### PlantUML Sequence

```markdown
```plantuml
@startuml
actor User
participant "Frontend" as FE
participant "Backend" as BE
database "Database" as DB

User -> FE: Click button
FE -> BE: API call
BE -> DB: Query
DB --> BE: Results
BE --> FE: JSON
FE --> User: Update UI
@enduml
```
```

### PlantUML Class

```markdown
```plantuml
@startuml
class User {
  -id: int
  -name: string
  +getName(): string
  +setName(name: string): void
}

class Order {
  -id: int
  -total: float
  +getTotal(): float
}

User "1" --> "*" Order : places
@enduml
```
```

### PlantUML Component

```markdown
```plantuml
@startuml
package "Frontend" {
  [React App]
  [Redux Store]
}

package "Backend" {
  [API Server]
  [Auth Service]
}

database "PostgreSQL"

[React App] --> [Redux Store]
[React App] --> [API Server]
[API Server] --> [Auth Service]
[API Server] --> [PostgreSQL]
@enduml
```
```

---

## ASCII Diagrams

For simple diagrams, ASCII art works well in code blocks:

```markdown
```
┌─────────────┐     ┌─────────────┐
│   Client    │────>│   Server    │
└─────────────┘     └─────────────┘
                          │
                          v
                    ┌─────────────┐
                    │  Database   │
                    └─────────────┘
```
```

---

## Diagram Best Practices

### Size Control

```markdown
<div class="w-3/4 mx-auto">

```mermaid
graph TD
    A --> B
```

</div>
```

### With Click Animation

```markdown
<div v-click>

```mermaid
graph LR
    A --> B
```

</div>
```

### Multiple Diagrams

Use two-cols layout:

```markdown
---
layout: two-cols
---

```mermaid
graph TD
    A --> B
```

::right::

```mermaid
graph TD
    C --> D
```
```

### When to Use Each

| Diagram Type | Use For |
|--------------|---------|
| Flowchart | Processes, algorithms, decisions |
| Sequence | API calls, interactions, protocols |
| Class | OOP design, data models |
| ER | Database schemas |
| State | State machines, lifecycles |
| Gantt | Project timelines |
| Pie | Proportions, distributions |
| Git Graph | Branching strategies |
| Mindmap | Brainstorming, hierarchies |
| Journey | User flows, experiences |
