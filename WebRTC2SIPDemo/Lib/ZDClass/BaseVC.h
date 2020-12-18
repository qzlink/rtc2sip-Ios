//
//  BaseVC.h
//  spamao
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^NVRightBlock)(UIButton *button);

/**加载时的取消*/
typedef void(^LoadCancelBlcok)();

typedef NS_ENUM(NSInteger, HEIGHT_TYPE)
{
    NV_TYPE,//只有一个navigation 内容高度为全屏高度-NV_H-STATUS_H
    TAB_TYPE,//只有一个tabbar 特殊情况 内容高度为全屏高度
    ALL_TYPE,//status、navigation、tabbar
    NONE_YPTE//全屏
};

//尺寸模式
typedef NS_ENUM(NSInteger, SIZEMODE)
{
    //宽度 暂时没有适配ipad
    MODE_320 = 1,
    MODE_375,
    MODE_414
};

//登录成功后的操作
typedef NS_ENUM(NSUInteger, LoginedOprate)
{
    NVDismissBack,//NV返回类型 不要用这个
    SelfDismissBack,
    PopBack
};

@interface BaseVC : UIViewController
@property (nonatomic, strong) NVRightBlock nvRightBlock;

/**用于标识VC
 */
@property (nonatomic, copy) NSString *flag;

/*
 获取可滑动高度
 如果要让ScrollView顺利垂直滑动的话必须注意一点
 @param hasNV 是否存在navigation tabbar
 @param Height 内容总高度 contentView里面的控件maxY
 @return scrollView的内容视图高度>scrollView的高度+1-状态栏的高度-导航栏的高度-tabBar的高度
 */
- (float)getSlidablyHeight:(HEIGHT_TYPE)type Height:(CGFloat)height;


//<------------LoadHintV------------>(1)Start
/**显示信息
 @param message 提示信息
 */
- (void)showMessage:(NSString*)message;

/**message:网络连接错误，请检查网络！
 */
- (void)showMessage_A;
/**显示加载动画
 @param interval 请求加载时间 也就是动画运行时间
 */
- (void)showLoadInterval:(NSNumber*)interval;
- (void)showLoad:(LoadCancelBlcok)cancelBlock;
/**隐藏加载
 */
- (void)hideLoad;
/**超时后的处理
 */
@property (nonatomic, strong) NSTimer *loadTimer;
//<------------LoadHintV------------>(1)End



//<------------NV自定义返回按钮------------>(2)Start
/**添加左边的NV自定义返回按钮
 *param backType dismiss pop
 */
- (void)setLeftNVBackButtonType:(NSString*)backType;

/**添加右边的NV自定义返回按钮
 */
- (void)setRightNVBackButton:(NVRightBlock)nvRightBlock ImageNames:(NSString*)imageNames,...NS_REQUIRES_NIL_TERMINATION;
//<------------NV自定义返回按钮------------>(2)End



//可变参
- (void)eatFruit:(NSString*)fruit otherFruit:(NSString*)firstFruit,...NS_REQUIRES_NIL_TERMINATION;

//unicode转中文
- (NSString *)replaceUnicode:(NSString *)unicodeStr;

/**从字符串originalString里面获取float
 */
- (float)getFloat:(NSString*)originalString;

/**判断有效合法的手机号
 @param  mobile 输入的手机号码
 @return 返回是否合法
 */
- (BOOL)isValidateMobile:(NSString*)mobile area:(NSString*)area;
//数字 字母 字母数字组合
- (BOOL) validatePassword:(NSString *)passWord;
//ASCII码字符
-(BOOL)ascllPasswdIsValidate:(NSString*)password;

- (BOOL) validateQQ:(NSString *)userQQ;

- (BOOL) validateEmail:(NSString *)email;
//正则表达式 判断 英文和数字
- (BOOL) validateABC123:(NSString *)text;
//判断身份证的合法性
- (BOOL) validateSFZ:(NSString*)text;

/**间隔天数 负数为当前时间距之后的时间 正数反之
 *param selectDate 选择的天数
 */
- (NSInteger)intervalTime:(NSString*)selectDate;


/**
 *点击空白处Dismiss键盘(空白处还包括没有响应的控件)
 @param lc 如果不为空，在退出键盘是就调整视图的高度
 */
- (void)setupForDismissKeyboard:(NSLayoutConstraint*)lc;
/**约束contentView视图的top*/
@property (nonatomic, weak) NSLayoutConstraint *contentViewTopLC_P;
- (void)setupForDismissKeyboardWithVC:(UIViewController*)VC;
@property (nonatomic, weak) UIViewController *dismissKeyboardVC;

//灰色层 从相册和摄像机添加
@property (nonatomic, strong) UIView *grayLayer;

/**添加头像图片*/
- (void)addHeadImage;
/**删除灰色层*/
- (void)removeGrayLayer;
#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info;


/**登录与注册 参数1:num 参数2:password 参数3:code(验证码)
 @param infos
 @param url 请求接口
 @param isAuto 是否是自动登录
 */
- (void)loginAndRegisterWithInfos:(NSArray*)infos Url:(NSString*)url isAuto:(BOOL)isAuto;

/**获取collectionView的cell的缩放比例
 @param width 为cell的宽度 一行有两个Cell
 @return 缩放比例
 */
- (CGFloat) getCellScaleRate:(CGFloat)cellWidth;

/**裁剪图片为圆形
 @param image 要裁剪的图片
 @param inset 等距内边距
 @return 返回被切的圆
 */
- (UIImage*)originalImage:(UIImage*)image inset:(CGFloat)inset;

//全局隐藏所有键盘
+ (void)hideAllKeyBoard;

//--------------------以下方法不一定适合所有项目--------------------

//token失效 延时去登录页面
- (void)delayCall:(id)sender;

+ (SIZEMODE)getSizeMode;

//隐藏NaviBar
- (void)setNaviBarHideOrShow:(BOOL)isHide;


@end
