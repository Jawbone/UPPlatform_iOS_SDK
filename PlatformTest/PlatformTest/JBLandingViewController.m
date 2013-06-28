//
//  JBViewController.m
//  PlatformTest
//
//  Created by Andy Roth on 5/29/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBLandingViewController.h"

#import "UP.h"

NSString *kAPIExplorerID          = @"Z1ghuhmIQvA";
NSString *kAPIExplorerSecret      = @"20105f7734c3daefa9d14321cc0c1eaaa2db9206";

@interface JBLandingViewController ()

@property (nonatomic, weak) IBOutlet UIButton *loginButton;
@property (nonatomic, weak) IBOutlet UILabel *statusLabel;

@end

@implementation JBLandingViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	self.loginButton.enabled = NO;
	self.statusLabel.text = @"Validating Session";
	
    [UPPlatform sharedPlatform].enableNetworkLogging = YES;
	[[UPPlatform sharedPlatform] validateSessionWithCompletion:^(UPSession *session, NSError *error) {
		
		self.loginButton.enabled = YES;
		self.statusLabel.text = @"";
		
		if (session != nil)
		{
			[self performSegueWithIdentifier:@"LoggedIn" sender:nil];
		}
	}];
}

- (IBAction)login:(id)sender
{
	self.loginButton.enabled = NO;
	self.statusLabel.text = @"Authenticating";
	
	// Show the login screen
	[[UPPlatform sharedPlatform] startSessionWithClientID:kAPIExplorerID clientSecret:kAPIExplorerSecret authScope:UPPlatformAuthScopeAll completion:^(UPSession *session, NSError *error) {
		
		self.loginButton.enabled = YES;
		self.statusLabel.text = @"";
		
		if (session != nil)
		{
			[self performSegueWithIdentifier:@"LoggedIn" sender:nil];
		}
		else
		{
			[[[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
		}
	}];
}

@end
