MPTextView
==========

A UITextView subclass with support for placeholder text (similar to UITextField)

### Notes and errata

- The property is named `.placeholderText` to avoid colliding with `.placeholder` if UITextView gains that property in a future version of iOS.
- Some setters on UITextView are overridden to pass font and text alignment data through to the placeholder label. `setAttributedText:` has *not* been.
- This has been tested on an iPhone 5 running iOS 6.1.4, and in the iOS 6.1 Simulator for both non-Retina and Retina iPads.

Open an issue if you have any problems!
