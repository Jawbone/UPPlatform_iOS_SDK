//
//  UPAuthViewController.m
//  PlatformSDK
//
//  Created by Andy Roth on 4/6/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//
#if !(!TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR)

#import "UPAuthViewController.h"

@interface UPAuthViewController () <UIWebViewDelegate>

@property (nonatomic, weak) id<UPAuthViewControllerDelegate> delegate;

@property (nonatomic, strong) UIViewController *rootViewController;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) NSURL *authURL;

@property (nonatomic, strong) NSString *redirectURIScheme;

@end

@implementation UPAuthViewController

#pragma mark - Initialization

- (id)initWithURL:(NSURL *)url delegate:(id<UPAuthViewControllerDelegate>)delegate
{
    self = [super init];
    if (self)
    {
        self.authURL = url;
        self.delegate = delegate;
    }
    
    return self;
}

- (void)viewDidLoad
{
    // Setup the auth view
    UIWindow *keyWindow = [UIApplication sharedApplication].delegate.window;
    if (!keyWindow) keyWindow = [UIApplication sharedApplication].keyWindow;
    self.rootViewController = keyWindow.rootViewController;
    
    NSAssert(self.rootViewController != nil, @"Application must have a root view controller.");
    
    self.view.backgroundColor = [UIColor blackColor];
    self.view.frame = [UIScreen mainScreen].applicationFrame;
    
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    navigationBar.items = @[ self.navigationItem ];
    [self.view addSubview:navigationBar];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44)];
    self.webView.delegate = self;
    self.webView.backgroundColor = [UIColor blackColor];
    
    NSURL *url = [NSURL URLWithString:[UPPlatform sharedPlatform].redirectURI];
    self.redirectURIScheme = url.scheme;
}

- (void)show
{
    self.view.alpha = 0.0;
    self.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [self.rootViewController.view addSubview:self.view];
    
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 1.0;
        self.view.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:self.authURL]];
    }];
}

- (void)hideWithCompletion:(void(^)())completion
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0.0;
        self.view.transform = CGAffineTransformMakeScale(0.1, 0.1);
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (completion) completion();
    }];
}

- (void)cancel
{
    [self hideWithCompletion:^{
        [self.delegate authViewControllerDidCancel:self];
    }];
}

#pragma mark - Web View Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if (!self.webView.superview)
    {
        self.navigationItem.title = @"Loading";
    }
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    // Add the web view once it loads
    if (!self.webView.superview)
    {
        self.navigationItem.title = @"";
        [self.view addSubview:self.webView];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.scheme isEqualToString:self.redirectURIScheme])
    {
        NSString *query = request.URL.query;
        NSString *code = [query stringByReplacingOccurrencesOfString:@"code=" withString:@""];
        
        [self hideWithCompletion:nil];
        [self.delegate authViewController:self didCompleteWithAuthCode:code];
        return NO;
    }
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hideWithCompletion:nil];
    [self.delegate authViewController:self didFailWithError:error];
}

@end

#endif
