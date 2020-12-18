//
//  UIViewController+Tool.m
//  IO定制游
//
//  Created by 宋利军 on 16/7/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "UIViewController+Tool.h"
//#import "IMSmallNumberModel.h"

//#import "IMSetLocationNumView.h"
//#import "IMSelectInternationalCodeVC.h"
//#import "IMInternationalCodeModel.h"
//#import "IMSelectSmallNumberVC.h"
//#import "IMSelectCityVC.h"

//超时时间
#define OutTime 150
#define ZDOutTime 30

@implementation UIViewController (Tool)

- (void)pushVC:(UIViewController*)vc animated:(BOOL)animated
{
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:animated];
}

#pragma mark -- 添加remove方法
- (void)removeLoadinView
{
    UIView *loadingV = nil;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    loadingV = [window viewWithTag:408922];
    //有loadingV的话不能再创建
    if (loadingV)
    {
        [loadingV removeFromSuperview];
    }
}


- (void)loadingToVC:(UIViewController*)vc
{
    UIView *loadingV = nil;
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    loadingV = [window viewWithTag:408922];
    //有loadingV的话不能再创建
    if (loadingV)
    {
        loadingV.hidden = NO;
        [window addSubview:loadingV];

    }else
    {
        loadingV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        [window addSubview:loadingV];
        loadingV.backgroundColor = [UIColor clearColor];
        loadingV.tag = 408922;
        loadingV.alpha = 0.5;
        loadingV.hidden = NO;
        
        //创建灰色层
        UIView *grayV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        
        [loadingV addSubview:grayV];
        grayV.backgroundColor = [UIColor blackColor];
        grayV.alpha = 0.3;
        
        //创建白色圆角视图
        UIView *whiteV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        whiteV.tag = 32982;
        whiteV.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
        whiteV.backgroundColor = [UIColor blackColor];
        whiteV.layer.cornerRadius = 10;
        whiteV.layer.masksToBounds = YES;
        [loadingV addSubview:whiteV];
        
        //创建默认标题
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, whiteV.width, 40)];
        titleL.tag      = 110;
        titleL.numberOfLines = 2;
        titleL.text = @"加载中";
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.textColor = [UIColor whiteColor];
        [whiteV addSubview:titleL];
        
        //创建加载视图
        UIImageView *myImageV = [[UIImageView alloc] initWithFrame:CGRectMake(50, 35, 40, 40)];
        myImageV.tag = 35692;
        [whiteV addSubview:myImageV];
        NSMutableArray *imageViews = [NSMutableArray array];
        for (int i = 0; i < 9; i ++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", i]];
            [imageViews addObject:image];
        }
        myImageV.animationImages = imageViews;
        //设置一次动画时长
        myImageV.animationDuration = 0.8;
        //设置帧动画播放次数
        myImageV.animationRepeatCount = 0;
        //开启动画
        [myImageV startAnimating];
        
        //loadingV的渐变动画
        [UIView animateWithDuration:0.5 animations:^{
            loadingV.alpha = 1;
        }];
    }
    __weak typeof (self) weakVC = vc;
    __weak typeof (self) weakSelf = self;
    //延迟调用 默认为30秒
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(OutTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!loadingV.hidden) {
            [weakSelf hideLoadFromVC:weakVC];
        }
    });
}

- (UIView*)ZDLoadingToVC:(UIViewController*)vc title:(NSString*)title outTime:(NSUInteger)outTime outTimeBlock:(void (^)(void))outTimeBlock
{
    __block UIView *loadingV = loadingV = [vc.view viewWithTag:208299];
    if (loadingV)
    {
        [loadingV removeFromSuperview];
        loadingV = nil;
    }
    //有loadingV的话不能再创建
    if (!loadingV)
    {
        loadingV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        [vc.view addSubview:loadingV];
        loadingV.backgroundColor = [UIColor clearColor];
        loadingV.tag = 208299;
        loadingV.alpha = 0.5;
        loadingV.hidden = NO;
        
        //创建灰色层
        UIView *grayV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        
        [loadingV addSubview:grayV];
        grayV.backgroundColor = [UIColor blackColor];
        grayV.alpha = 0.3;
        
        //创建白色圆角视图
        UIView *whiteV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 140, 140)];
        whiteV.tag = 32982;
        whiteV.center = CGPointMake(SCREEN_W/2.0, SCREEN_H/2.0);
        whiteV.backgroundColor = [UIColor blackColor];
        whiteV.layer.masksToBounds = YES;
        whiteV.layer.cornerRadius = 10;
        
        [loadingV addSubview:whiteV];
        
        //创建默认标题
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(8, 90, whiteV.width-16, 40)];
        titleL.tag      = 110;
        titleL.numberOfLines = 2;
        if ([BaseModel getStr:title].length==0)
        {
            titleL.text = @"加载中...";
        }else
        {
            titleL.text = title;
        }
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont systemFontOfSize:15];
        titleL.textColor = [UIColor whiteColor];
        //    self.currentLabl = titleL;
        [whiteV addSubview:titleL];
        
        //创建加载视图
        __block UIImageView *myImageV = [[UIImageView alloc] initWithFrame:CGRectMake(50, 35, 40, 40)];
        myImageV.tag = 35692;
        [whiteV addSubview:myImageV];
        NSMutableArray *imageViews = [NSMutableArray array];
        for (int i = 0; i < 9; i ++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", i]];
            [imageViews addObject:image];
        }
        myImageV.animationImages = imageViews;
        //设置一次动画时长
        myImageV.animationDuration = 0.8;
        //设置帧动画播放次数
        myImageV.animationRepeatCount = 0;
        //开启动画
        [myImageV startAnimating];
        
        //loadingV的渐变动画
        [UIView animateWithDuration:0.2 animations:^{
            loadingV.alpha = 1;
        }];
        
        if (outTime!=0)
        {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(outTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (myImageV)
                {
                    [myImageV stopAnimating];
                }
                if (loadingV)
                {
                    [loadingV removeFromSuperview];
                    loadingV = nil;
                }
                if (outTimeBlock)
                {
                    outTimeBlock();
                }
            });
        }
    }
    return loadingV;
}

- (void)ZDHideLoadFromVC:(UIViewController*)vc
{
    UIView *loadingV = [vc.view viewWithTag:208299];
    UIImageView *myImageV = [loadingV viewWithTag:35692];
    [myImageV stopAnimating];
    [loadingV removeFromSuperview];
    loadingV = nil;
}

- (void)hideLoadFromVC:(UIViewController*)vc
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    NSLog(@"++++++++++++++");
    UIView *loadingV = [window viewWithTag:408922];
    loadingV.hidden = YES;
}

- (void)hideLoadFromVC:(UIViewController*)vc forTime:(float)time WithTitle:(NSString *)title
{
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    UIView *loadingV = [window viewWithTag:408922];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        loadingV.hidden = YES;
    });
}

- (void)showPrompt:(NSString*)prompt
{
    LoadHintV *hintView = [[LoadHintV alloc] initLoadHintType:HINT_TYPE duration:1];
    hintView.message = prompt;
    Sog(@"hintView=%@", hintView);
    [self.view addSubview:hintView];
    [self.view bringSubviewToFront:hintView];
}

- (void)showPromptToView:(UIView*)view prompt:(NSString*)prompt
{
    LoadHintV *hintView = [[LoadHintV alloc] initLoadHintType:HINT_TYPE duration:1];
    hintView.message = prompt;
    Sog(@"hintView=%@", hintView);
    [view addSubview:hintView];
    [view bringSubviewToFront:hintView];
}

- (void)showPrompt:(NSString*)prompt isFromTravel:(BOOL)isFromTravel
{
    LoadHintV *hintView = [[LoadHintV alloc] initLoadHintType:HINT_TYPE duration:1];
    hintView.message = prompt;
    hintView.isFromTravel = isFromTravel;
    Sog(@"hintView=%@", hintView);
    [self.view addSubview:hintView];
    [self.view bringSubviewToFront:hintView];
}

- (void)showPrompt:(NSString*)prompt vc:(UIViewController*)vc
{
    LoadHintV *hintView = [[LoadHintV alloc] initLoadHintType:HINT_TYPE duration:1];
    hintView.message = prompt;
    Sog(@"hintView=%@", hintView);
    [vc.view addSubview:hintView];
    [vc.view bringSubviewToFront:hintView];
}

- (void)showAlertWithTitle:(NSString*)title
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *rogerSetAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }];
    [alertController addAction:rogerSetAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)showPrompt:(NSString*)prompt duration:(CGFloat)duration
{
    LoadHintV *hintView = [[LoadHintV alloc] initLoadHintType:HINT_TYPE duration:duration];
    hintView.message = prompt;
    Sog(@"hintView=%@", hintView);
    [self.view addSubview:hintView];
    [self.view bringSubviewToFront:hintView];
}

- (void)showPrompt:(NSString*)prompt duration:(CGFloat)duration finish:(void (^)(void))completeBlock
{
    LoadHintV *hintView = [[LoadHintV alloc] initLoadHintType:HINT_TYPE duration:duration finish:^{
        completeBlock();
    }];
    hintView.message = prompt;
    Sog(@"hintView=%@", hintView);
    [self.view addSubview:hintView];
    [self.view bringSubviewToFront:hintView];
}

- (void)showAlert:(NSString*)message title:(NSString*)title delegate:(id)delegate
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

#pragma mark -- H5的加载动画
- (void)loadingViewForH5:(UIViewController *)currentVC
{
    UIView *loadingV = nil;
    loadingV = [currentVC.view viewWithTag:88888];
    
    if (loadingV) {
      
        loadingV.hidden = NO;
        
        [currentVC.view addSubview:loadingV];
    }else
    {
        loadingV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        loadingV.backgroundColor = [UIColor whiteColor];
        loadingV.tag = 88888;
       
        UIImageView *myImageV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
        myImageV.center = CGPointMake(loadingV.width/2, loadingV.height/2);
        myImageV.tag = 66666;
        [loadingV addSubview:myImageV];
        NSMutableArray *imageViews = [NSMutableArray array];
        for (int i = 0; i < 9; i ++)
        {
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading_%d", i]];
            [imageViews addObject:image];
        }
        myImageV.animationImages = imageViews;
        //设置一次动画时长
        myImageV.animationDuration = 0.8;
        //设置帧动画播放次数
        myImageV.animationRepeatCount = 0;
        //开启动画
        [myImageV startAnimating];
        
        
        /** 显示文字 */
        UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 160, 40)];
        titleL.tag      = 1100;
        titleL.numberOfLines = 2;
        titleL.text = @"正在拼命加载中...";
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.font = [UIFont systemFontOfSize:14];
        //    self.currentLabl = titleL;
        [loadingV addSubview:titleL];
        
        /** 显示的返回按钮 */
        
        if (![NSStringFromClass(currentVC.class) isEqualToString:@"IONavigationController"]) {
            UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 15, 40, 40)];
            [backButton setImage:[UIImage imageNamed:@"Return"] forState:UIControlStateNormal];
            
            [backButton addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
            
        }
    }
}

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

#pragma mark -- 点击按钮回调

- (void)dismiss:(UIButton *)sender
{
    
}

#pragma mark -- 移除H5的加载动画
- (void)removeH5Loading
{
    
    
}

- (void)showNoDataPrompt:(NSString*)content frame:(CGRect)frame
{
    UIView *promptView = [self.view viewWithTag:10009];
    if ([BaseModel isKong:promptView])
    {
        promptView = [[UIView alloc] initWithFrame:frame];
        promptView.backgroundColor = RGB_COLOR(241, 242, 243, 1);
        promptView.tag = 10009;
        [self.view addSubview:promptView];
        
        UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-145/2.0, 123, 145, 169)];
        //imageV.center = CGPointMake(promptView.width/2.0, (promptView.height/2.0)-20);
        [promptView addSubview:imageV];
        imageV.image = [UIImage imageNamed:@"emptyDataIcon"];
        
        UILabel *titleL = [[UILabel alloc] init];
        titleL.text = content;
        titleL.textAlignment = NSTextAlignmentCenter;
        titleL.textColor = RGB_COLOR(104, 104, 104, 1);
        titleL.frame = CGRectMake(0, imageV.y+imageV.height+21, SCREEN_W, 21);
        //CGRectMake(0, imageV.y+imageV.height+20, promptView.width, 21);
        [promptView addSubview:titleL];
    }
    promptView.hidden = NO;
}

- (void)hideNoDataPrompt
{
    UIView *promptView = [self.view viewWithTag:10009];
    if (![BaseModel isKong:promptView])
    {
        promptView.hidden = YES;
    }
}

- (UIView*)createNoDataPrompt:(CGRect)frame title:(NSString*)title
{
    UIView *promptView = [[UIView alloc] initWithFrame:frame];
    promptView.backgroundColor = RGB_COLOR(241, 242, 243, 1);
    [self.view addSubview:promptView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    imageV.center = CGPointMake(promptView.width/2.0, (promptView.height/2.0)-40);
    [promptView addSubview:imageV];
    imageV.image = [UIImage imageNamed:@"noDataPromptOrder"];
    
    UILabel *titleL = [[UILabel alloc] init];
    titleL.text = title;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = RGB_COLOR(104, 104, 104, 1);
    titleL.frame = CGRectMake(0, imageV.y+imageV.height, promptView.width, 21);
    [promptView addSubview:titleL];
    return promptView;
}

- (UIView*)createNoDataPromptView:(NSString*)title
{
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(0, kNavBarHeight, SCREEN_W, SCREEN_H-kNavBarHeight)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_W/2.0-145/2.0, 123, 145, 169)];
    imageView.image = [UIImage imageNamed:@"emptyDataIcon"];
    [whiteView addSubview:imageView];
    imageView.tag = 98302;
    
    UILabel *contentL = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.y+imageView.height+21, SCREEN_W, 21)];
    contentL.text = title;
    contentL.textColor = RGB_COLOR(143, 153, 160, 1);
    contentL.font = [UIFont systemFontOfSize:14];
    contentL.textAlignment = NSTextAlignmentCenter;
    [whiteView addSubview:contentL];
    contentL.tag = 98301;
    return whiteView;
}

- (void)setLeftBarButtonItem
{
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"topback"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UIViewController *)getCurrentVC  
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;  
}

//颜色转图
+ (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end

