//
//  AppDelegate.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/8/26.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class IMTabBarController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

//是否为X机型
@property (nonatomic, assign) BOOL isIphoneX;

@property (nonatomic, strong) IMTabBarController *home;
@property (nonatomic, strong) ZDNavigationC *navi;

//是否添加新成员
@property (nonatomic, assign) BOOL isAddMember;

//获取状态栏高度
- (CGFloat)getStatusBarHeight;
@end

