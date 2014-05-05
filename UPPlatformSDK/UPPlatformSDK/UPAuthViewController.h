//
//  UPAuthViewController.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "UPDefines.h"
#if !UP_TARGET_OSX
#import <UIKit/UIKit.h>

#import "UPPlatform.h"

@class UPAuthViewController;

@protocol UPAuthViewControllerDelegate <NSObject>

- (void)authViewController:(UPAuthViewController *)viewController didCompleteWithAuthCode:(NSString *)code;
- (void)authViewController:(UPAuthViewController *)viewController didFailWithError:(NSError *)error;
- (void)authViewControllerDidCancel:(UPAuthViewController *)viewController;

@end

@interface UPAuthViewController : UINavigationController

- (id)initWithURL:(NSURL *)url delegate:(id<UPAuthViewControllerDelegate>)delegate;
- (void)show;

@end
#endif