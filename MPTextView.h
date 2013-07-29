//
//  MPTextView.h
//
//  Created by Christopher Bowns on 7/25/13.
//  Licensed under the Apache v2 license.
//

#import <UIKit/UIKit.h>

@interface MPTextView : UITextView

// Named .placeholderText, in case UITextView gains
// a .placeholder property (like UITextField) in future iOS versions.
@property (nonatomic, copy) NSString *placeholderText;

@end
