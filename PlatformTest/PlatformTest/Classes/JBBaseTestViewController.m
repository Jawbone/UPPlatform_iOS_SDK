//
//  JBBaseTestViewController.m
//  PlatformTest
//
//  Created by Andy Roth on 5/29/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBBaseTestViewController.h"

#import "JBResultsViewController.h"

@interface JBBaseTestViewController ()

@end

@implementation JBBaseTestViewController

- (void)showResults:(id)resultObject
{
	JBResultsViewController *resultVC = [self.storyboard instantiateViewControllerWithIdentifier:@"Results"];
	resultVC.results = [NSString stringWithFormat:@"%@", resultObject];
	[self.navigationController pushViewController:resultVC animated:YES];
}

@end
