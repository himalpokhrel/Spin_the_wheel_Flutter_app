# Spin Wheel - Product Requirements Document (PRD)

Version: 1.0
Platform: Flutter (Android + iOS)
Architecture: Clean Architecture
State Management: Riverpod
Storage: SharedPreferences (Phase 1)
Target Release: MVP

---

# 1. Product Vision

Spin Wheel is a premium cross-platform application that allows users to create beautiful customizable spinning wheels for random decision making.

The app should feel modern, smooth, simple and polished.

The goal is to become one of the highest-rated spin wheel apps on Google Play and App Store.

---

# 2. Target Audience

• Teachers
• Students
• Streamers
• Giveaway Creators
• Families
• Office Teams
• Event Organizers
• Small Businesses

Age:

10–60+

---

# 3. Core Principles

The application must always be:

• Fast
• Offline-first
• Beautiful
• Simple
• Stable
• Responsive
• Easy to use

No unnecessary complexity.

---

# 4. Tech Stack

Framework:
Flutter Stable

Language:
Dart

Architecture:
Clean Architecture

State Management:
Riverpod

Persistence:
SharedPreferences

Animation:
AnimationController

Future:
Hive / Isar migration without architecture changes.

---

# 5. Folder Structure

Use feature-first clean architecture.

Never place unrelated files together.

Every feature contains:

presentation/
domain/
data/

---

# 6. MVP Features

## Home

Display current wheel

Spin button

Settings button

Bottom Navigation

---

## Wheel

Create wheel

Edit wheel

Delete wheel

Duplicate wheel

Unlimited wheel items

Unlimited wheels

Random spin

Winner detection

Smooth animation

---

## Wheel Items

Name

Color

Reorder

Delete

Add

---

## Winner

Winner dialog

Winner animation

Confetti

Future sound support

---

## History

Save every spin

Display history

Delete history

Clear history

Statistics

---

## Settings

Dark Theme

Light Theme

Animation Speed

Sound

Vibration

Reset App

---

# 7. Future Premium Features

Custom wheel images

Gradient slices

AI generated wheels

Online wheel sharing

Cloud Sync

Wheel Templates

QR Import

QR Export

Achievements

Widgets

Apple Watch

WearOS

Desktop

---

# 8. UI Guidelines

Material 3

Rounded corners

Premium spacing

Minimal design

Dark mode first

Smooth animations

No clutter

---

# 9. Colors

Primary

Purple

Background

Dark navy

Cards

Dark gray

Accent

Orange

Text

White

Secondary Text

Light gray

---

# 10. Typography

Material 3

Large headings

Readable buttons

Consistent spacing

---

# 11. Navigation

Home

↓

Create Wheel

↓

Edit Wheel

↓

Spin

↓

Winner Dialog

↓

History

↓

Statistics

↓

Settings

---

# 12. Data Model

Wheel

- id
- name
- createdAt
- updatedAt
- items

WheelItem

- id
- title
- color

SpinHistory

- id
- wheelId
- winner
- timestamp

Settings

- theme
- sound
- vibration
- animationSpeed

---

# 13. Performance Goals

60 FPS

Instant page transitions

Spin animation never drops frames

No memory leaks

Minimal rebuilds

---

# 14. Code Quality

Clean Architecture

SOLID

Reusable widgets

Small files

Single responsibility

No duplicated logic

No magic numbers

No business logic inside UI

---

# 15. Development Workflow

Every new feature follows this order:

1. UI
2. Navigation
3. Domain
4. Data
5. State
6. Persistence
7. Testing
8. Polish

Never skip steps.

---

# 16. AI Development Rules

ChatGPT is the Project Mentor.

Responsibilities:

• Decide architecture

• Decide feature order

• Review generated code

• Detect bugs

• Prevent overengineering

Claude generates production-ready code.

Antigravity IDE manages files and project execution.

Never generate multiple unrelated features in one step.

Every feature must compile before moving forward.

---

# 17. Current Development Status

Completed

✅ Project setup

✅ Theme

✅ Home page

✅ Bottom navigation

✅ Wheel painter

✅ Spin animation

✅ Winner detection

✅ Winner dialog

Current Phase

➡️ Create Wheel Page

---

# 18. Success Criteria

Users can:

Create wheels

Add items

Spin wheels

Receive correct winner

Save wheels

View history

Customize settings

All without internet.

---

# 19. Non Goals

No login

No backend

No ads (MVP)

No accounts

No cloud sync

No subscriptions

---

# 20. Release Checklist

UI polished

Responsive

No analyzer warnings

No crashes

Offline works

Android tested

iOS tested

Ready for Play Store

Ready for App Store