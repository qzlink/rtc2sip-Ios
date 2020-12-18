//
//  UIViewController+Tool.h
//  IO定制游
//
//  Created by 宋利军 on 16/7/20.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IMFriendModel.h"

@interface UIViewController (Tool)
- (void)pushVC:(UIViewController*)vc animated:(BOOL)animated;
/**加载动画
 *param vc 自定义添加到哪个控制器下面 如果为空 会默认加到tabbar上 
 *需要注意的是loadingToVC和hideLoadFromVC所对应的参数要统一
 */
- (void)removeLoadinView;
- (void)loadingToVC:(UIViewController*)vc;
- (void)loadingViewForH5:(UIViewController *)currentVC;
- (void)removeH5Loading;
/** outTime:超时时间 0:不超时一直加载中
 */
- (UIView*)ZDLoadingToVC:(UIViewController*)vc title:(NSString*)title outTime:(NSUInteger)outTime outTimeBlock:(void (^)(void))outTimeBlock;
- (void)hideLoadFromVC:(UIViewController*)vc forTime:(float)time WithTitle:(NSString *)title;
/**显示提示 自动隐藏
 *param prompt 提示内容
 */
- (void)showPrompt:(NSString*)prompt;
- (void)showPrompt:(NSString*)prompt vc:(UIViewController*)vc;
- (void)showAlertWithTitle:(NSString*)title;
- (void)showPrompt:(NSString*)prompt isFromTravel:(BOOL)isFromTravel;
- (void)showPromptToView:(UIView*)view prompt:(NSString*)prompt;
/**显示提示 自动隐藏
 *param prompt 提示内容
 *param duration 持续时间
 */
- (void)showPrompt:(NSString*)prompt duration:(CGFloat)duration;

- (void)showPrompt:(NSString*)prompt duration:(CGFloat)duration finish:(void (^)(void))completeBlock;

- (void)showAlert:(NSString*)message title:(NSString*)title delegate:(id)delegate;

- (void)hideLoadFromVC:(UIViewController*)vc;
- (void)ZDHideLoadFromVC:(UIViewController*)vc;

//获取当前屏幕显示的viewcontroller
+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController*)rootViewController;

/**当列表内容为空 显示内容
 content 显示内容
 空盒子
 */
- (void)showNoDataPrompt:(NSString*)content frame:(CGRect)frame;
- (void)hideNoDataPrompt;

//没有搜索到数据的提示
- (UIView*)createNoDataPrompt:(CGRect)frame title:(NSString*)title;
//族群参观模式进群
- (void)visitModeToChat:(NSString*)groupId;
//空数据视图
- (UIView*)createNoDataPromptView:(NSString*)title;
- (void)setLeftBarButtonItem;
- (BOOL)canRecord;

//拨打国际小号
- (void)callWithModel:(IMFriendModel*)model;
/**
 * isSmallNum_t:对方的号码是否为小号
 */
- (void)callWithNum:(NSString *)num isDomestic:(BOOL)isDomestic calleeNick:(NSString*)calleeNick isSmallNum_t:(BOOL)isSmallNum_t calleeISO:(NSString*)calleeISO calleeUserid:(NSString*)calleeUserid;
//显示套餐视图
- (void)showPackageViewWithIsOnce:(BOOL)isOnce;

- (UIViewController *)getCurrentVC;

//颜色转图
+ (UIImage *)imageWithColor:(UIColor *)color;
@end
