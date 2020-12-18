//
//  IMTabBarController.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/9/9.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMTabBarController.h"
#import "IMCallRecordsListVC.h"
#import "IMPhoneCallVC.h"

@interface IMTabBarController ()

@end

@implementation IMTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // 设置item属性
    [self setupItem];
    
    // 添加所有的子控制器
    [self setupChildVcs];
    
    [[UITabBar appearance] setBarTintColor:[UIColor whiteColor]];
    [UITabBar appearance].translucent = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.toolbar.hidden = YES;
    self.tabBar.translucent = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    //    return UIStatusBarStyleLightContent;
    return UIStatusBarStyleLightContent;
}

/**
 * 设置item属性
 */
- (void)setupItem
{
    // UIControlStateNormal状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    normalAttrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    // 文字大小
    normalAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    
    // UIControlStateSelected状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    // 文字颜色
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor colorWithRed:49.0/255 green:176.0/255 blue:246.0/255 alpha:1.0];
    
    // 统一给所有的UITabBarItem设置文字属性
    // 只有后面带有UI_APPEARANCE_SELECTOR的属性或方法, 才可以通过appearance对象来统一设置
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)setupChildVcs
{
    NSArray *imageNames = @[@"call_off", @"meeting_off"];
    NSArray *imageNamesSelected = @[@"call_on", @"meeting_on"];
    NSArray *titles = @[@"电话", @"会议"];
    for (int i = 0; i < imageNames.count; i ++)
    {
        NSString *title = titles[i];
        UIImage *image = [[UIImage imageNamed:imageNames[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIImage *imageSelected = [[UIImage imageNamed:imageNamesSelected[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        if ([title isEqualToString:@"电话"])
        {
            [self setupChildVc:[[IMPhoneCallVC alloc] init] title:title image:image selectedImage:imageSelected];
        }else if ([title isEqualToString:@"会议"])
        {
            [self setupChildVc:[[IMCallRecordsListVC alloc] init] title:title image:image selectedImage:imageSelected];
        }
    }
}

/**
 * 添加一个子控制器
 * @param title 文字
 * @param image 图片
 * @param selectedImage 选中时的图片
 */
- (void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage
{
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = image;
    //[[UIImage imageNamed:image]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = selectedImage;
    //[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [self addChildViewController:vc];
    
//    if ([vc isKindOfClass:[IMSessionListVC  class]])
//    {
//        _sessionTabBarItem = vc.tabBarItem;
//    }else if ([vc isKindOfClass:[IMAddressBookVC  class]])
//    {
//        _addressBookTabBarItem = vc.tabBarItem;
//    }else if ([vc isKindOfClass:[IMMineVC  class]])
//    {
//        _mineTabBarItem = vc.tabBarItem;
//    }
}
@end
