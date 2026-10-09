# Requirements Document

## Introduction

This feature adds eight popular pre-made wheel templates to the Spin Wheel app, allowing users to quickly access common decision wheels without creating them from scratch. Users can spin these templates immediately or customize and save them as personal copies. The feature integrates seamlessly with the existing wheel creation, editing, and spinning functionality.

## Glossary

- **Default_Wheel_Template**: A pre-defined wheel configuration with a name and set of items that exists in code and cannot be modified directly
- **Template_Section**: A distinct UI section in the wheel list that displays default wheel templates separately from user-created wheels
- **User_Wheel**: A wheel entity saved in the database that belongs to the user's personal collection
- **Wheel_Entity**: The domain entity representing a wheel with id, name, items, timestamps, and removeWinner flag
- **Template_Card**: A visual card representation of a default wheel template in the wheel list
- **Customization_Flow**: The process of editing a default wheel template and saving it as a new user wheel
- **Wheel_List_Page**: The existing page that displays all wheels available to the user
- **Create_Wheel_Page**: The existing page used for creating new wheels and editing existing wheels
- **Wheel_Spin_Page**: The existing page that displays the wheel and handles spin animations
- **AppColors.wheelColors**: The existing array of eight vibrant colors used for wheel slice coloring

## Requirements

### Requirement 1: Default Wheel Template Library

**User Story:** As a user, I want to access eight popular pre-made wheel templates, so that I can start spinning immediately without manual setup.

#### Acceptance Criteria

1. THE System SHALL provide exactly eight default wheel templates
2. THE System SHALL include a "Yes or No" template with 2 items (Yes, No)
3. THE System SHALL include a "What Should I Eat?" template with 6 items (Pizza, Burger, Pasta, Salad, Tacos, Sushi)
4. THE System SHALL include a "Truth or Dare" template with 2 items (Truth, Dare)
5. THE System SHALL include a "Study or Break" template with 2 items (Study, Take a Break)
6. THE System SHALL include a "Random Numbers" template with 10 items (1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
7. THE System SHALL include a "Color Picker" template with 8 items (Red, Blue, Green, Yellow, Orange, Purple, Pink, Black)
8. THE System SHALL include a "Decision Maker" template with 3 items (Yes, No, Maybe)
9. THE System SHALL include a "Party Challenges" template with 6 items (Dance, Sing, Tell a joke, Do a dare, Share a story, Skip turn)
10. THE System SHALL assign colors to template items by cycling through AppColors.wheelColors

### Requirement 2: Template Display and Organization

**User Story:** As a user, I want to see default wheel templates in a separate section at the top of my wheel list, so that I can quickly distinguish them from my personal wheels.

#### Acceptance Criteria

1. THE Wheel_List_Page SHALL display the Template_Section above all User_Wheel entries
2. THE Template_Section SHALL display a section header labeled "Templates" or "Quick Start"
3. WHEN no User_Wheel entries exist, THE Wheel_List_Page SHALL display the Template_Section above the empty state message
4. THE System SHALL display each Default_Wheel_Template as a Template_Card in the Template_Section
5. THE Template_Card SHALL include a distinctive visual indicator (icon, badge, or styling) to distinguish it from User_Wheel cards
6. THE Template_Card SHALL display the template name
7. THE Template_Card SHALL display the number of items in the template
8. THE Template_Card SHALL use visual styling consistent with the existing wheel list card design

### Requirement 3: Template Spinning

**User Story:** As a user, I want to spin a default wheel template without saving it, so that I can use common wheels instantly for quick decisions.

#### Acceptance Criteria

1. WHEN a user taps a Template_Card, THE System SHALL navigate to Wheel_Spin_Page with the template data
2. THE Wheel_Spin_Page SHALL display the template wheel using existing spin animation and physics
3. THE Wheel_Spin_Page SHALL detect winners using the existing winner detection logic
4. THE System SHALL allow unlimited spins of a Default_Wheel_Template without requiring save operations
5. THE System SHALL apply haptic feedback during template spinning when haptic settings are enabled
6. THE System SHALL play sound effects during template spinning when sound settings are enabled

### Requirement 4: Template Customization

**User Story:** As a user, I want to customize a default wheel template and save it as my own wheel, so that I can personalize popular wheels to my specific needs.

#### Acceptance Criteria

1. THE Template_Card SHALL display an "Edit" or "Customize" button
2. WHEN a user activates the customize action, THE System SHALL navigate to Create_Wheel_Page
3. THE Create_Wheel_Page SHALL pre-populate the name field with the template name prefixed with "My " (e.g., "My Yes or No")
4. THE Create_Wheel_Page SHALL pre-populate all items from the Default_Wheel_Template
5. THE Create_Wheel_Page SHALL pre-populate item colors from the template
6. THE User SHALL be able to modify the wheel name
7. THE User SHALL be able to add new items
8. THE User SHALL be able to delete items
9. THE User SHALL be able to edit item text
10. THE User SHALL be able to change item colors
11. WHEN the user saves the customized wheel, THE System SHALL create a new Wheel_Entity with a unique id
12. WHEN the user saves the customized wheel, THE System SHALL store the new User_Wheel in the database
13. WHEN the user saves the customized wheel, THE System SHALL display the new User_Wheel in the user's wheel collection

### Requirement 5: Template Immutability

**User Story:** As a user, I want default wheel templates to remain available after I customize them, so that I can create multiple variations or start fresh anytime.

#### Acceptance Criteria

1. THE System SHALL define Default_Wheel_Template data as static constants in application code
2. THE System SHALL NOT store Default_Wheel_Template data in the database
3. WHEN a user customizes a Default_Wheel_Template, THE System SHALL create a new Wheel_Entity with a new unique id
4. THE System SHALL NOT modify the original Default_Wheel_Template data when a customization is saved
5. THE Default_Wheel_Template SHALL remain available in the Template_Section after customization operations
6. THE System SHALL NOT provide a save or update operation that modifies Default_Wheel_Template data

### Requirement 6: Integration with Existing Features

**User Story:** As a user, I want template wheels to work seamlessly with all existing app features, so that I have a consistent and reliable experience.

#### Acceptance Criteria

1. THE System SHALL use the existing Wheel_Entity domain model for Default_Wheel_Template data representation
2. THE System SHALL use the existing WheelItem entity for template item data representation
3. THE System SHALL use Wheel_Spin_Page to spin Default_Wheel_Template instances
4. THE System SHALL use Create_Wheel_Page to customize Default_Wheel_Template instances
5. THE System SHALL use the existing wheel repository to save customized templates
6. THE System SHALL NOT modify the existing spin animation logic
7. THE System SHALL NOT modify the existing winner detection logic
8. THE System SHALL NOT modify the existing sound effect system
9. THE System SHALL NOT modify the existing haptic feedback system
10. THE System SHALL NOT modify the existing wheel data persistence layer beyond adding template display logic

### Requirement 7: Code Preservation

**User Story:** As a developer, I want to preserve all existing functionality, so that the feature addition does not introduce regressions or breaking changes.

#### Acceptance Criteria

1. THE System SHALL NOT modify existing Wheel_Entity or WheelItem entity definitions
2. THE System SHALL NOT modify the existing wheel repository interface or implementation
3. THE System SHALL NOT modify Create_Wheel_Page save or update logic
4. THE System SHALL NOT modify Wheel_Spin_Page animation, physics, or winner detection
5. THE System SHALL NOT modify the existing theme, color system, or typography
6. THE System SHALL NOT modify the existing bottom navigation
7. THE System SHALL NOT modify the existing history feature
8. THE System SHALL NOT modify the existing settings feature
9. THE System SHALL NOT modify any file unrelated to displaying Default_Wheel_Template instances
10. THE System SHALL compile without errors after feature implementation

### Requirement 8: User Experience Consistency

**User Story:** As a user, I want the template feature to match the existing app design, so that it feels like a natural part of the application.

#### Acceptance Criteria

1. THE Template_Card SHALL use the same card style as User_Wheel cards (rounded corners, shadows, padding)
2. THE Template_Section SHALL use consistent spacing and layout with the rest of Wheel_List_Page
3. THE System SHALL apply the same animations to Template_Card entries as User_Wheel cards
4. THE System SHALL maintain the existing warm cream background color in light mode
5. THE System SHALL maintain the existing dark background color in dark mode
6. THE System SHALL use Poppins font family consistent with the existing design
7. THE System SHALL follow Material 3 design patterns consistent with the existing UI
8. WHEN a user interacts with a Template_Card, THE System SHALL provide haptic feedback consistent with User_Wheel card interactions
