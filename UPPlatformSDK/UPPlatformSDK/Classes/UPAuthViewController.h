//
//  UPAuthViewController.h
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//
#if !(!TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR)
#import <UIKit/UIKit.h>

#import "UPPlatform.h"

@class UPAuthViewController;

@protocol UPAuthViewControllerDelegate <NSObject>

- (void)authViewController:(UPAuthViewController *)viewController didCompleteWithAuthCode:(NSString *)code;
- (void)authViewController:(UPAuthViewController *)viewController didFailWithError:(NSError *)error;
- (void)authViewControllerDidCancel:(UPAuthViewController *)viewController;

@end

@interface UPAuthViewController : UIViewController

- (id)initWithURL:(NSURL *)url delegate:(id<UPAuthViewControllerDelegate>)delegate;
- (void)show;

@end
#endif