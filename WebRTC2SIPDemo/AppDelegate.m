//
//  AppDelegate.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/8/26.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>
#import "IMTabBarController.h"
#import "IMCallRecordsListVC.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate () <UNUserNotificationCenterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //1.创建主窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    IOWeakSelf
    //获取手机型号
    [self getIphoneXInfo];
    
    IMLoginVC *VC = [[IMLoginVC alloc] initWithNibName:@"IMLoginVC" bundle:nil];
    VC.loginSuccessBlock = ^(){
        dispatch_async(dispatch_get_main_queue(), ^{
            IMTabBarController *home = [[IMTabBarController alloc] init];
            ZDNavigationC *nav_a = [[ZDNavigationC alloc] initWithRootViewController:home];
            weakSelf.window.rootViewController = nav_a;
            weakSelf.navi = nav_a;
        });
    };
    ZDNavigationC *nav = [[ZDNavigationC alloc] initWithRootViewController:VC];
    self.navi = nav;
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    /**
    IMTabBarController *home = [[IMTabBarController alloc] init];
    self.home = home;
    
    ZDNavigationC *nav_a = [[ZDNavigationC alloc] initWithRootViewController:home];
    self.navi = nav_a;
    self.window.rootViewController = nav_a;
    [self.window makeKeyAndVisible];
    */
    [Bugly startWithAppId:@"5de7af6df0"];
    
    //FMDatabase *db = [FMDatabase databaseWithPath:@""];
    //设置通知中心
    [self setNotiCenter];
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}

//设置通知中心
- (void)setNotiCenter
{
    //注册通知设置代理
    UNUserNotificationCenter *notiCenter = [UNUserNotificationCenter currentNotificationCenter];
    notiCenter.delegate = self;
    //用户授权
    [notiCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error) {
        
    }];
    //获取当前通知设置
    [notiCenter getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
    }];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)getIphoneXInfo
{
    BOOL iPhoneX = NO;
    if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone)
    {
    }else
    {
        if (@available(iOS 11.0, *))
        {
            UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
            if (mainWindow.safeAreaInsets.bottom > 0.0)
            {
                iPhoneX = YES;
            }
        }
    }
    self.isIphoneX = iPhoneX;
}

- (CGFloat)getStatusBarHeight
{
    float statusBarHeight = 0;
    if (@available(iOS 13.0, *))
    {
        UIStatusBarManager *statusBarManager = [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager;
        statusBarHeight = statusBarManager.statusBarFrame.size.height;
    }
    else {
        statusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
    }
    return statusBarHeight;
}
@end
