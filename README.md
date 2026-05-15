# Flutter UI Library 🎨

A collection of reusable and customizable widgets for Flutter, designed to accelerate UI development and ensure design consistency across your projects. [Learn about most commonly used handy Flutter widgets.](./flutter_cheat_sheet.md)

## Table of Contents 📌

- [Flutter UI Library 🎨](#flutter-ui-library-)
  - [Table of Contents 📌](#table-of-contents-)
  - [Custom Widgets 📋](#custom-widgets-)
    - [Animation ✨](#animation-)
    - [Async & State ⚡️](#async--state-️)
    - [Clipper ✂️](#clipper-️)
    - [Painter 🎨](#painter-)
    - [User Inputs ✍️](#user-inputs-️)
      - [Button](#button)
      - [Checkbox](#checkbox)
      - [Date Picker](#date-picker)
      - [Dropdown](#dropdown)
      - [Form](#form)
      - [Overlays](#overlays)
      - [Tabs](#tabs)
      - [Toggle(Switch)](#toggleswitch)
      - [Tooltip](#tooltip)
    - [Visual Layouts 🧱](#visual-layouts-)
      - [Dialog](#dialog)
      - [Divider](#divider)
      - [Document](#document)
      - [Draggable](#draggable)
      - [Grid](#grid)
      - [Icons](#icons)
      - [Image](#image)
      - [PDF](#pdf)
      - [Tag](#tag)
      - [Youtube](#youtube)
  - [Animation Views 🎬](#animation-views-)
    - [Explicit Animation Views](#explicit-animation-views)
    - [Implicit Animation Views](#implicit-animation-views)

## Custom Widgets 📋

### Animation ✨

Bring your UI to life with smooth animations:

- **Explicit Animations**
  - ✅ **Loading Circle**: An animated circular loader with changing colors to indicate progress.
  - ✅ **Gradient Loading Circle**: A rotating circular loader with a gradient effect, perfect for stylish loading states.
- **Implicit Animations**
  - ✅ **Animated Indicator**: A customizable indicator for page views or step-by-step progress, with smooth transitions between active and inactive states.
  - ✅ **Animated Expansion Tile**: A tile that expands and collapses with a smooth animation, useful for accordions or collapsible lists.
  - ✅ **Resend OTP Button**: A button that displays a countdown timer before allowing the user to resend an OTP, preventing spam.
  - ✅ **Tab Bar**: A styled `TabBar` for creating clean and modern tab-based navigation.

---

### Async & State ⚡️

Widgets for handling asynchronous operations and managing state reactively.

- ✅ **Base Future Builder**: An efficient `FutureBuilder` using `flutter_hooks` with dedicated builders for data, error, and loading states.
- ✅ **Base Stream Builder**: A simplified `StreamBuilder` wrapper with dedicated builders for data, error, and loading states.

---

### Clipper ✂️

Custom-shaped widgets for creative designs:

- ✅ **Circle**: A clipper that masks its child widget into a perfect circular shape.
- ✅ **Curve**: A container that can be clipped with a curve on any of its four sides (top, right, bottom, left).
- ✅ **Half Circle**: A clipper that masks its child widget into a half-circle on either the left or right side.

---

### Painter 🎨

Draw custom shapes with ease:

- ✅ **Dotted Circle**: A custom painter that draws a circle with a dotted or dashed border.
- ✅ **Dotted Container**: A container with a customizable dotted or dashed border, perfect for upload areas or callouts.
- ✅ **Polygon**: A custom painter that draws a regular polygon with a specified number of sides.

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
  - ✅ **Dropdown Multi Selection**: A dropdown that opens a bottom sheet to allow selecting multiple items from a list, complete with a 'Select All' feature.
  - ✅ **Drop Down Text Field**: A text field that, when tapped, reveals a dropdown overlay for item selection.
- **Overlays**
  - ✅ **Overlay Menu**: A widget that displays a customizable popup menu anchored to its child.
  - ✅ **Text Field with Overlay**: An autocomplete-style text field that shows a dropdown of suggestions as the user types.
- **Form**
  - ✅ **OTP Field**: A set of input fields for entering one-time passwords (OTP), using the `pinput` package.
  - ✅ **Text Field**: A highly customizable `TextFormField` with an optional title, icons, and validation support.
- **Date Picker**
  - ✅ **Date Range Picker**: A modal or inline date range picker for selecting a start and end date using `syncfusion_flutter_datepicker`.
  - ✅ **Date Timeline**: A horizontal timeline for selecting a specific date with customizable styling.
- **Tabs**
  - ✅ **Base Tab**: A customizable tab widget with support for icons and labels.
  - ✅ **Base Tab List**: A horizontal list of `BaseTab` widgets with a scrollable area and an optional bottom divider.
- ✅ **Toggle(Switch)**: A `Switch` with an optional label for simple on/off toggling.
- ✅ **Tooltip**: A customizable tooltip that appears on long press or hover, providing additional context with optional icons.

---

### Visual Layouts 🧱

Enhance your UI with foundational layout elements:

- **Dialog**
  - ✅ **Generic Dialog**: A highly customizable dialog wrapper for alerts, confirmations, and custom content with responsive sizing.
- **Divider**
  - ✅ **Base Divider**: A styled horizontal divider with customizable padding, color, and indents.
  - ✅ **Base Vertical Divider**: A styled vertical divider for separating side-by-side content.
- **Document**
  - ✅ **Document Upload**: A component that provides a UI for users to select and upload files (images, PDFs) from their device.
  - ✅ **Document List**: A `ListTile` styled widget for displaying a document item with an icon, title, and optional trailing widget.
  - ✅ **Document BottomSheet**: A function to display a selected document (image or PDF) within a modal bottom sheet for a quick preview.
- **Draggable**
  - ✅ **Draggable Content Widget**: A draggable bottom sheet that dynamically adjusts its size based on its content, with separate sections for always-visible and expandable content.
- **Grid**
  - ✅ **Grid View Layout**: A responsive grid layout widget that adapts the number of columns based on screen size.
  - ✅ **Sliver Grid View Layout**: A sliver-based grid layout for use within `CustomScrollView`.
- **Icons**
  - ✅ **Error Icon**: A standardized red error icon for indicating failures or errors.
  - ✅ **Gradient Icon**: A versatile widget that applies a linear gradient to any icon.
- **Image**
  - ✅ **Asset Image**: A robust wrapper for `Image.asset` that provides a seamless experience by including loading and error builders, ensuring your UI remains graceful even if an image fails to load.
  - ✅ **Cached Network Image**: An advanced widget for displaying and caching network images with platform-specific logic. It dynamically provides separate caching mechanisms for mobile and web, ensuring optimal performance on both platforms while supporting custom placeholders and error widgets.
  - ✅ **File Image**: A convenient widget for displaying an image from a local `File` object. It simplifies handling images selected from the device's gallery or camera by managing loading and error states.
  - ✅ **Memory Image**: A specialized widget for rendering an image directly from a `Uint8List` in memory. This is particularly useful for displaying dynamically generated images or images received from an API as byte data.
  - ✅ **Network Image**: A fundamental widget for displaying an image from a URL. It comes with built-in loading and error builders to handle different network states gracefully.
- **PDF**
  - ✅ **File PDF**: A widget to render a PDF document from a local `File`.
  - ✅ **Memory PDF**: A widget to render a PDF document from a `Uint8List` in memory.
- **Tag**
  - ✅ **Base Tag**: A small, styled label widget for categories, status indicators, or chips, with optional icon support.
- **Youtube**
  - ✅ **Youtube Video Player**: An embedded YouTube video player with custom controls for a seamless viewing experience.
  - ✅ **Youtube Thumbnail Image**: Displays a thumbnail for a YouTube video from its URL, with a play button overlay.
- ✅ **Cupertino Loading**: A simple wrapper around `CupertinoActivityIndicator` for consistent iOS-style loading spinners.
- ✅ **Error Indicator**: A centered error icon, often used as a placeholder when content fails to load.
- ✅ **Keyboard Space**: A dynamic `SizedBox` that adjusts its height to match the on-screen keyboard, preventing UI overlap.
- ✅ **Loading Circle**: A versatile circular progress indicator with options for Material or Cupertino styles.
- ✅ **Shimmer**: A loading placeholder that displays a shimmering animation, indicating that content is being loaded.
- ✅ **Slider**: A styled slider for selecting a value from a range, with customizable track and thumb.
- ✅ **Stopwatch**: A text widget that displays the elapsed time from a `Stopwatch` instance, formatted as HH:MM:SS.
- ✅ **Text**: A foundational text widget with factory constructors for various text styles (headings, body, links) to ensure typographic consistency.

---

## Animation Views 🎬

Explore our collection of pre-built animation views that demonstrate complex animations. [Learn more about Flutter animations.](./flutter_animation.md)

### Explicit Animation Views

- ✅ **Animated Prompt**: A view that displays a prompt with an icon that animates its scale and position, ideal for confirmations.
- ✅ **Animated Polygon**: A view that animates a polygon's sides, radius, and rotation simultaneously.
- ✅ **Bouncing Position**: A view demonstrating an elastic bouncing effect on a widget's position using `SlideTransition`.
- ✅ **Bouncing Size**: A view that showcases a heart icon with a bouncing size and color animation when tapped.
- ✅ **3D Cube**: A view that renders a 3D cube rotating on its X, Y, and Z axes.
- ✅ **3D Drawer**: A view demonstrating a 3D drawer that swings open with a rotation effect on the main content.
- ✅ **Ticker Animation**: A view that uses a `Ticker` to display a running stopwatch, updating on every frame.
- ✅ **Transform and Clip Path**: A view demonstrating a complex animation combining `Transform` and `ClipPath` to create a rotating and flipping effect.
- ✅ **Rotation Transform**: A view that shows a container continuously rotating around its Y-axis.
- ✅ **Transitions**: A view that showcases various explicit transition widgets like `SlideTransition`, `SizeTransition`, `FadeTransition`, `ScaleTransition`, and `RotationTransition`.

### Implicit Animation Views

- ✅ **Animated List View**: A view demonstrating an `AnimatedList` where items are inserted with a slide animation.
- ✅ **Animated Widgets**: A view showcasing `AnimatedContainer` that animates its size and color properties.
- ✅ **Hero Animation**: A view demonstrating `Hero` animations, where an element smoothly transitions from one screen to another.
- ✅ **Tween Builders**: A view that uses `TweenAnimationBuilder` to create animations for opacity, a countdown timer, and color transitions.
