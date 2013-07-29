//
//  MPTextView.m
//
//  Created by Christopher Bowns on 7/25/13.
//  Licensed under the Apache v2 license.
//

#import "MPTextView.h"

// Manually-selected label offset to align placeholder label with real text.
static CGFloat const kLabelLeftOffset = 8.f;
static CGFloat const kLabelTopOffsetRetina = 0.5f;

@interface MPTextView ()

@property (nonatomic, strong) UILabel *placeholderLabel;

// Calculate and save the label's left and top offset.
@property (nonatomic, assign) CGSize labelOffset;

// Handle text changed event so we can update the placeholder appropriately
- (void)textChanged:(NSNotification *)note;

@end


@implementation MPTextView

#pragma mark - Initializers

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self finishInitialization];
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self finishInitialization];
    }
    return self;
}


// Private method for finishing initialization.
// Rather than muck with designated initializers, let's do it the easy way.
- (void)finishInitialization {
    // Sign up for notifications for text changes:
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textChanged:)
                                                 name:UITextViewTextDidChangeNotification
                                               object:self];

    CGFloat labelLeftOffset = kLabelLeftOffset;
    CGFloat labelTopOffset = 0.f;

    // On retina iPhones and iPads, the label is offset by 0.5 points.
    if ([[UIScreen mainScreen] scale] == 2.0) {
        labelTopOffset = kLabelTopOffsetRetina;
    }
    self.labelOffset = CGSizeMake(labelLeftOffset, labelTopOffset);

    [self createPlaceholderLabel];
}


#pragma mark - Placeholder label helper

// Create our label:
- (void)createPlaceholderLabel {
    CGRect labelFrame = [self calculatePlaceholderLabelFrame];

    self.placeholderLabel = [[UILabel alloc] initWithFrame:labelFrame];
    self.placeholderLabel.lineBreakMode = NSLineBreakByWordWrapping;
    self.placeholderLabel.numberOfLines = 0;
    self.placeholderLabel.font = self.font;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    self.placeholderLabel.text = self.placeholderText;
    // Manually matched to UITextField's placeholder text color.
    self.placeholderLabel.textColor = [UIColor colorWithWhite:0.71f alpha:1.0f];

    [self addSubview:self.placeholderLabel];
}


- (CGRect)calculatePlaceholderLabelFrame {
    return CGRectMake(self.labelOffset.width,
                      self.labelOffset.height,
                      self.bounds.size.width  - (2 * self.labelOffset.width),
                      self.bounds.size.height - (2 * self.labelOffset.height));
}

#pragma mark - Custom accessors

- (void)setPlaceholderText:(NSString *)string {
    _placeholderText = [string copy];
    self.placeholderLabel.text = string;
    [self.placeholderLabel sizeToFit];
}


#pragma mark - UITextView subclass methods

// Keep the placeholder label font in sync with the text view's
- (void)setFont:(UIFont *)font {
    // Call super.
    [super setFont:font];

    self.placeholderLabel.font = self.font;
}


// Keep placeholder label alignment in sync
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    // Call super.
    [super setTextAlignment:textAlignment];

    self.placeholderLabel.textAlignment = textAlignment;
}

// Todo: override setAttributedText to capture changes
// in text alignment?


#pragma mark - UITextInput overrides

// Listen to dictation events to hide the placeholder as is appropriate.

// Hide when there's a dictation result placeholder
- (id)insertDictationResultPlaceholder {
    // Call super.
    id placeholder = [super insertDictationResultPlaceholder];

    // Use .hidden (instead of alpha), since these events also trigger
    // -[textChanged] (which has a different criteria by which it shows the label)
    self.placeholderLabel.hidden = YES;
    return placeholder;
}


// Update visibility when dictation ends.
- (void)removeDictationResultPlaceholder:(id)placeholder willInsertResult:(BOOL)willInsertResult {
    // Call super.
    [super removeDictationResultPlaceholder:placeholder willInsertResult:willInsertResult];

    // Unset the hidden flag from insertDictationResultPlaceholder.
    self.placeholderLabel.hidden = NO;

    // Update our text label based on the entered text.
    [self updatePlaceholderLabelVisibility];
}


#pragma mark - Text change listeners

- (void)updatePlaceholderLabelVisibility {
    if ([self.text length] == 0) {
        self.placeholderLabel.alpha = 1.f;
    } else {
        self.placeholderLabel.alpha = 0.f;
    }
}


// When text is set or changed, update the label's visibility:

- (void)setText:(NSString *)text {
    // Call super.
    [super setText:text];

    [self updatePlaceholderLabelVisibility];
}


- (void)textChanged:(NSNotification *)notification {
    [self updatePlaceholderLabelVisibility];
}


@end
