//
//  HUViewController.m
//  HelloUP
//
//  Created by Shadow on 11/15/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "HUViewController.h"
#import <UPPlatformSDK/UPPlatformSDK.h>

// OAuth keys.
NSString *const kAPIExplorerID = @"3ZYR1YjGd3Q";
NSString *const kAPIExplorerSecret = @"4dd5b10b3a3a16dbf3082c86d5faff09e11a682b";

@interface HUViewController ()

@end

@implementation HUViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Give us a detailed network activity overview.
    [UPPlatform sharedPlatform].enableNetworkLogging = YES;
    
    // Check if we have an outstanding session.
    [[UPPlatform sharedPlatform] validateSessionWithCompletion:^(UPSession *session, NSError *error) {
		if (session != nil) {
			[self performSegueWithIdentifier:@"LoggedIn" sender:nil];
		}
	}];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)didTapLogin:(UIButton *)sender {
    
    sender.enabled = NO;
	
	// Present login screen in a UIWebView.
	[[UPPlatform sharedPlatform] startSessionWithClientID:kAPIExplorerID
                                             clientSecret:kAPIExplorerSecret
                                                authScope:UPPlatformAuthScopeAll
                                               completion:^(UPSession *session, NSError *error) {
		
                                                   sender.enabled = YES;
		
                                                   if (session != nil) {
                                                       [self performSegueWithIdentifier:@"LoggedIn" sender:nil];
                                                   } else {
                                                       [[[UIAlertView alloc] initWithTitle:@"Error"
                                                                                   message:error.localizedDescription
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"OK"
                                                                         otherButtonTitles:nil] show];
                                                   }
	}];
}
@end
