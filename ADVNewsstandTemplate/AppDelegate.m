//
//  AppDelegate.m
//  ADVNewsstandTemplate
//
//  Created by Tope on 07/03/2013.
//  Copyright (c) 2013 App Design Vault. All rights reserved.
//

#import "AppDelegate.h"
#import "BlueTheme.h"
#import "RedTheme.h"
#import "OrangeTheme.h"
#import "MagrackTheme.h"

@implementation AppDelegate


+(AppDelegate*)instance
{
    return [[UIApplication sharedApplication] delegate];
}

- (InterceptorWindow *)window
{
    static InterceptorWindow *customWindow = nil;
    if (!customWindow) customWindow = [[InterceptorWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    customWindow.backgroundColor = [UIColor whiteColor];
    return customWindow;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.theme = [[MagrackTheme alloc] init];
    [self customizeTheme];
    
    self.publisher = [[Publisher alloc] init];
    self.newsstandDownloader = [[NewsstandDownloader alloc] init];
    self.repository = [[Repository alloc] init];
    
    NKLibrary *nkLib = [NKLibrary sharedLibrary];
    
    for(NKAssetDownload *asset in [nkLib downloadingAssets]) {
        [asset downloadWithDelegate:self.newsstandDownloader];
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.storeManager = [[StoreManager alloc] init];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self.storeManager];

    return YES;
}

-(void)customizeTheme{
    
    UINavigationBar* navigationBarAppearance = [UINavigationBar appearance];
    
    [navigationBarAppearance setBackgroundImage:[UIImage imageNamed:[self.theme navigationBackgroundImage]] forBarMetrics:UIBarMetricsDefault];
    
    [navigationBarAppearance setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor whiteColor], UITextAttributeTextColor,
      [UIFont boldSystemFontOfSize:22.0f], UITextAttributeFont,
      [UIColor darkGrayColor], UITextAttributeTextShadowColor,
      [NSValue valueWithCGSize:CGSizeMake(0.0, 1.0)], UITextAttributeTextShadowOffset, nil]];
   
    
    UIBarButtonItem* barButtonAppearance = [UIBarButtonItem appearance];
    
    UIImage* backButtonImage = [[UIImage imageNamed:[self.theme backButtonImage]] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 19, 10, 10)];
    
    UIImage* barButtonImage = [[UIImage imageNamed:[self.theme barButtonImage]] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
    
    
    [barButtonAppearance setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonAppearance setBackgroundImage:barButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    
    UIToolbar* toolbarAppearance = [UIToolbar appearance];
    
    [toolbarAppearance setBackgroundImage:[UIImage imageNamed:[self.theme navigationBackgroundImage]] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    UIApplication *app = [UIApplication sharedApplication]; NSInteger unreadCount = [app applicationIconBadgeNumber];
    [app setApplicationIconBadgeNumber:MAX(0, (unreadCount - 1))];
    
    NSLog(@"application:didReReturnFromBackground: -");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:
     @"com.advnewsstand.returnFromBackground"
                                                        object:self];

}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
