//
//  JBAppDelegate.m
//  PlatformTest-OSX
//
//  Created by Andy Roth on 6/12/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBAppDelegate.h"

#import "UP.h"

NSString *kAPIExplorerID          = @"Z1ghuhmIQvA";
NSString *kAPIExplorerSecret      = @"20105f7734c3daefa9d14321cc0c1eaaa2db9206";

@interface JBAppDelegate ()

@property (nonatomic, weak) IBOutlet NSButton *authButton;

@end

@implementation JBAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
	[[UPPlatform sharedPlatform] endCurrentSession];
}

- (IBAction)authenticate:(id)sender
{
    [self.authButton setEnabled:NO];
    
    [[UPPlatform sharedPlatform] startSessionWithClientID:kAPIExplorerID clientSecret:kAPIExplorerSecret webView:nil authScope:UPPlatformAuthScopeAll completion:^(UPSession *session, NSError *error) {
        
        if (session != nil)
        {
            [self.authButton removeFromSuperview];
            
            NSAlert *alert = [NSAlert alertWithMessageText:@"Authenticated" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Getting some UP information."];
            [alert runModal];
            
            /*
             [UPUserAPI getCurrentUserWithCompletion:^(UPUser *user, UPURLResponse *response, NSError *error) {
             NSAlert *alert = [NSAlert alertWithMessageText:@"Found User" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Found %@ %@", user.firstName, user.lastName];
             [alert runModal];
             }];
             */
            
            /*
             NSImage *image = [NSImage imageNamed:@"Image.png"];
             UPGenericEvent *event = [UPGenericEvent eventWithTitle:@"OS X Time" verb:@"tested" attributes:nil note:@"Uploaded via OS X" image:image];
             [UPGenericEventAPI postGenericEvent:event completion:^(UPGenericEvent *event, UPURLResponse *response, NSError *error) {
             if (error == nil)
             {
             NSAlert *alert = [NSAlert alertWithMessageText:@"Event uploaded" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Uploaded generic event with xid %@", event.xid];
             [alert runModal];
             }
             else
             {
             NSAlert *alert = [NSAlert alertWithMessageText:@"Error" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"Error: %@", error.localizedDescription];
             [alert runModal];
             }
             }];
             */
            
            [UPMoveAPI getMovesWithLimit:1 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
                UPMove *move = results[0];
                [UPMoveAPI getMoveGraphImage:move completion:^(NSImage *image) {
                    NSImageView *imageView = [[NSImageView alloc] initWithFrame:NSMakeRect(0, 0, image.size.width, image.size.height)];
                    imageView.image = image;
                    [self.window.contentView addSubview:imageView];
                }];
            }];
        }
        else
        {
            [self.authButton setEnabled:YES];
        }
	}];
}

@end
