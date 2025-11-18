# Flutter UI Library 🎨

A Flutter project showcasing a library of reusable custom widgets to accelerate UI development and maintain design consistency across projects. [Learn about most commonly used handy Flutter widgets.](./flutter_cheat_sheet.md)

## Table of Contents 📌

- [Flutter UI Library 🎨](#flutter-ui-library-)
  - [Table of Contents 📌](#table-of-contents-)
  - [Overview 🛠️](#overview-️)
  - [Features 📋](#features-)
    - [Animation Widgets ✨](#animation-widgets-)
    - [Clipper Widgets ✂️](#clipper-widgets-️)
    - [Painter Widgets 🎨](#painter-widgets-)
    - [Visual Layouts 🧱](#visual-layouts-)
    - [User Inputs ✍️](#user-inputs-️)
    - [Async \& State Widgets ⚡️](#async--state-widgets-️)
  - [Why Use This Project? 🤔](#why-use-this-project-)

## Overview 🛠️

This project provides a collection of pre-built, customizable widgets to simplify your Flutter app's development. These components are designed to be flexible and reusable, ensuring consistency and reducing development time.

## Features 📋

### Animation Widgets ✨

Bring your UI to life with smooth animations:

- **Explicit Animations**
  - ✅ **Loading Circle**: An animated circular loader with changing colors to indicate progress.
  - ✅ **Gradient Loading Circle**: A rotating circular loader with a gradient effect, perfect for stylish loading states.
- **Implicit Animations**
  - ✅ **Animated Indicator**: A customizable indicator for page views or step-by-step progress, with smooth transitions between active and inactive states.
  - ✅ **Resend OTP Button**: A button that displays a countdown timer before allowing the user to resend an OTP, preventing spam.
  - ✅ **Tab Bar**: A styled `TabBar` for creating clean and modern tab-based navigation.

---

### Clipper Widgets ✂️

Custom-shaped widgets for creative designs:

- ✅ **Circle**: A clipper that masks its child widget into a perfect circular shape.
- ✅ **Curve**: A container that can be clipped with a curve on any of its four sides (top, right, bottom, left).
- ✅ **Half Circle**: A clipper that masks its child widget into a half-circle on either the left or right side.

---

### Painter Widgets 🎨

Draw custom shapes with ease:

- ✅ **Dotted Circle**: A custom painter that draws a circle with a dotted or dashed border.
- ✅ **Dotted Container**: A container with a customizable dotted or dashed border, perfect for upload areas or callouts.
- ✅ **Polygon**: A custom painter that draws a regular polygon with a specified number of sides.

---

### Visual Layouts 🧱

Enhance your UI with foundational layout elements:

- **Document**
  - ✅ **Document Upload**: A component that provides a UI for users to select and upload files (images, PDFs) from their device.
  - ✅ **Document List**: A `ListTile` styled widget for displaying a document item with an icon, title, and optional trailing widget.
  - ✅ **Document BottomSheet**: A function to display a selected document (image or PDF) within a modal bottom sheet for a quick preview.
- **Draggable**
  - ✅ **Draggable Content Widget**: A draggable bottom sheet that dynamically adjusts its size based on its content, with separate sections for always-visible and expandable content.
- **Image**
  - ✅ **Asset Image**: A wrapper for `Image.asset` that includes loading and error builders for a better user experience.
  - ✅ **Cached Network Image**: Displays and caches network images, with support for placeholders and error widgets.
  - ✅ **File Image**: Displays an image from a local `File`, including loading and error states.
  - ✅ **Memory Image**: Renders an image from a `Uint8List` (byte data), useful for dynamically generated images.
  - ✅ **Network Image**: A basic widget to display an image from a URL with loading and error builders.
- **PDF**
  - ✅ **File PDF**: A widget to render a PDF document from a local `File`.
  - ✅ **Memory PDF**: A widget to render a PDF document from a `Uint8List` in memory.
- **Youtube**
  - ✅ **Youtube Video Player**: An embedded YouTube video player with custom controls for a seamless viewing experience.
  - ✅ **Youtube Thumbnail Image**: Displays a thumbnail for a YouTube video from its URL, with a play button overlay.
- ✅ **Cupertino Loading**: A simple wrapper around `CupertinoActivityIndicator` for consistent iOS-style loading spinners.
- ✅ **Error Icon**: A standardized red error icon for indicating failures or errors.
- ✅ **Error Indicator**: A centered error icon, often used as a placeholder when content fails to load.
- ✅ **Keyboard Space**: A dynamic `SizedBox` that adjusts its height to match the on-screen keyboard, preventing UI overlap.
- ✅ **Loading Circle**: A versatile circular progress indicator with options for Material or Cupertino styles.
- ✅ **Shimmer**: A loading placeholder that displays a shimmering animation, indicating that content is being loaded.
- ✅ **Slider**: A styled slider for selecting a value from a range, with customizable track and thumb.
- ✅ **Stopwatch**: A text widget that displays the elapsed time from a `Stopwatch` instance, formatted as HH:MM:SS.
- ✅ **Text**: A foundational text widget with factory constructors for various text styles (headings, body, links) to ensure typographic consistency.

---

### User Inputs ✍️

Intuitive and interactive components for user input:

- ✅ **Bottom Sheet**: A structured bottom sheet component with a title and body for presenting options or information.
- **Button**
  - ✅ **Icon Button**: A simple `IconButton` with sensible defaults for padding and size.
  - ✅ **Link Button**: A button that looks like a hyperlink, with optional icons and customizable states.
  - ✅ **Primary Button**: A `FilledButton` for primary actions, with support for loading states and icons.
  - ✅ **Secondary Button**: An `OutlinedButton` for secondary actions, also with loading state and icon support.
  - ✅ **Text Button**: A wrapper around `TextButton` that can be expanded and show a loading indicator.
- ✅ **Checkbox**: A `Checkbox` with an optional label and support for tristate values.
- **Dropdown**
  - ✅ **Drop Down Bottom Sheet**: A dropdown that opens a modal bottom sheet for item selection, ideal for mobile-friendly lists.
  - ✅ **Drop Down Button**: A styled wrapper around Flutter's native `DropdownButton`.
  - ✅ **Drop Down Menu**: A modern dropdown based on `DropdownMenu` with built-in search and filtering capabilities.
  - ✅ **Drop Down Search Field**: An autocomplete-style text field that shows a dropdown of suggestions as the user types.
  - ✅ **Drop Down Text Field**: A text field that, when tapped, reveals a dropdown overlay for item selection.
- **Overlay**
  - ✅ **Overlay Menu**: A widget that displays a customizable popup menu anchored to its child.
- **Form**
  - ✅ **OTP Field**: A set of input fields for entering one-time passwords (OTP), using the `pinput` package.
  - ✅ **Text Field**: A highly customizable `TextFormField` with an optional title, icons, and validation support.
- ✅ **Toggle(Switch)**: A `Switch` with an optional label for simple on/off toggling.

---

### Async & State Widgets ⚡️

Widgets for handling asynchronous operations and managing state reactively.

- ✅ **Base Future Builder**: An efficient `FutureBuilder` using `flutter_hooks` with dedicated builders for data, error, and loading states.
- ✅ **Base Stream Builder**: A simplified `StreamBuilder` wrapper with dedicated builders for data, error, and loading states.

---

## Why Use This Project? 🤔

- 🏗️ **Reusable Design**: Save time by reusing tested and flexible components.
- 🎨 **Consistency**: Maintain a unified design language across your app.
- ⚙️ **Customizability**: Easily tweak widgets to fit your specific requirements.
- 🚀 **Speed Up Development**: Focus on functionality, not reinventing the UI.
