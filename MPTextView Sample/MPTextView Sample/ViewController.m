//
//  ViewController.m
//  MPTextView Sample
//
//  Created by Daniel Resnick on 1/8/14.
//  Copyright (c) 2014 Daniel Resnick. All rights reserved.
//

#import "ViewController.h"
#import "MPTextView.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MPTextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    self.textView.placeholderText = @"Placeholder text taking up multiple lines.";
}

@end
