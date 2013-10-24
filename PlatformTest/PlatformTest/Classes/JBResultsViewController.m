//
//  JBResultsViewController.m
//  PlatformTest
//
//  Created by Andy Roth on 5/29/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBResultsViewController.h"

@interface JBResultsViewController ()

@property (nonatomic, weak) IBOutlet UITextView *textView;

@end

@implementation JBResultsViewController

- (void)viewDidLoad
{
	self.textView.text = self.results;
}

@end
