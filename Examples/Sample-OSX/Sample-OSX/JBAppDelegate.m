//
//  JBAppDelegate.m
//  Sample-OSX
//
//  Created by Andy Roth on 5/5/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import "JBAppDelegate.h"

#import "UP.h"

NSString *const kAPIExplorerID = @"3ZYR1YjGd3Q";
NSString *const kAPIExplorerSecret = @"4dd5b10b3a3a16dbf3082c86d5faff09e11a682b";

@interface JBAppDelegate ()

@property (nonatomic, weak) IBOutlet NSButton *authButton;
@property (nonatomic, weak) IBOutlet NSButton *postButton;
@property (nonatomic, weak) IBOutlet NSButton *logoutButton;
@property (nonatomic, weak) IBOutlet NSTextField *infoLabel;

@property (nonatomic, strong) UPPlatform *platform;

- (IBAction)authenticate:(id)sender;
- (IBAction)postGenericEvent:(id)sender;

@end

@implementation JBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[UPPlatform sharedPlatform] validateSessionWithCompletion:^(UPSession *session, NSError *error) {
        if (session != nil)
        {
            [self enablePosting];
        }
    }];
}

- (IBAction)authenticate:(id)sender
{
    [[UPPlatform sharedPlatform] startSessionWithClientID:kAPIExplorerID clientSecret:kAPIExplorerSecret webView:nil authScope:UPPlatformAuthScopeAll completion:^(UPSession *session, NSError *error) {
        if (session != nil)
        {
            [UPUserAPI getCurrentUserWithCompletion:^(UPUser *user, UPURLResponse *response, NSError *error) {
                [UPPlatform sharedPlatform].currentSession.currentUser = user;
                [self enablePosting];
            }];
        }
    }];
}

- (IBAction)logout:(id)sender
{
    [[UPPlatform sharedPlatform] endCurrentSession];

    [self.authButton setEnabled:YES];
    [self.postButton setEnabled:NO];
    [self.logoutButton setEnabled:NO];
    [self.infoLabel setStringValue:@"Not Authenticated."];
}

- (IBAction)postGenericEvent:(id)sender
{
    [self.postButton setEnabled:NO];
    
    NSImage *logo = [NSImage imageNamed:@"logo"];
    UPGenericEvent *event = [UPGenericEvent eventWithTitle:@"OS X Time" verb:@"posted" attributes:nil note:@"Just testing the OS X SDK." image:logo];
    [UPGenericEventAPI postGenericEvent:event completion:^(UPGenericEvent *event, UPURLResponse *response, NSError *error) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"Event was posted successfully!"];
        [alert addButtonWithTitle:@"OK"];
        [alert runModal];
        [self.postButton setEnabled:YES];
    }];
}

- (void)enablePosting
{
    UPSession *session = [UPPlatform sharedPlatform].currentSession;
    NSString *message = [NSString stringWithFormat:@"Signed in as %@ %@.", session.currentUser.firstName, session.currentUser.lastName];
    
    [self.authButton setEnabled:NO];
    [self.postButton setEnabled:YES];
    [self.logoutButton setEnabled:YES];
    [self.infoLabel setStringValue:message];
}

@end
