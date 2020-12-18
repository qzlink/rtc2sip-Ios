//
//  BaseVC.m
//  spamao
//
//  Created by apple on 16/1/16.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseVC.h"

@interface BaseVC () <UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate>
{
    LoadHintV *loadView;
}
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation BaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (float)getSlidablyHeight:(HEIGHT_TYPE)type Height:(CGFloat)height
//{
//    float tempHeight = 0;
//    if (type==NV_TYPE)
//    {
//        tempHeight = SCREEN_H + 1 - (NV_H + STATUS_H);
//    }else if (type==ALL_TYPE)
//    {
//        tempHeight = SCREEN_H + 1 - (NV_H + TABBAR_H + STATUS_H);
//    }else if (type==NONE_YPTE)
//    {
//        tempHeight = SCREEN_H + 1;
//    }else if (type==TAB_TYPE)
//    {
//        tempHeight = SCREEN_H - TABBAR_H;
//        Sog(@"tempHeight=%f", tempHeight);
//        if (height>tempHeight)
//        {
//            return SCREEN_H + height-tempHeight;
//        }else
//        {
//            return SCREEN_H + 1;
//        }
//    }
//    if (height>tempHeight)
//    {
//        return height;
//    }
//    return tempHeight;
//}

- (void)showMessage:(NSString*)message
{
    LoadHintV *hintView = [[LoadHintV alloc] initLoadHintType:HINT_TYPE duration:0.5];
    hintView.message = message;
    [self.view addSubview:hintView];
}

- (void)showMessage_A
{
    [self showMessage:@"网络连接错误，请检查网络！"];
}

//- (void)showLoadInterval:(NSNumber*)interval
//{
//    Sog(@"creat=NSTimer");
//    loadView = [[LoadHintV alloc] initLoadHintType:LOAD_TYPE duration:0.5];
//    [[UIView getTopController:self].view addSubview:loadView];
//    _loadTimer = [NSTimer scheduledTimerWithTimeInterval:[interval doubleValue] target:self selector:@selector(hideLoad) userInfo:nil repeats:NO];
//}
//
//- (void)showLoad:(LoadCancelBlcok)cancelBlock
//{
//    loadView = [[LoadHintV alloc] initLoadHintType:LOADCANCEL_TYPE duration:0.5];
//    loadView.loadCancelBlock = cancelBlock;
//    [[UIView getTopController:self].view addSubview:loadView];
//}

- (void)hideLoad
{
    [_loadTimer invalidate];
    [loadView stopAnimation];
    [loadView removeFromSuperview];
    loadView = nil;
}

//-(void)setLeftNVBackButtonType:(NSString*)backType
//{
//    //注意不自定义会重叠颜色 UIBarButtonItem匹配的图片不是@2x，而是@1x
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, NV_H, NV_H);
//    //setImage是原比例 setBackgroundImage会拉伸适应button的frame
//    [backBtn setImage:[UIImage imageNamed:@"Return"] forState:UIControlStateNormal];
//    if ([backType isEqualToString:@"dismiss"])
//    {
//        [backBtn addTarget:self action:@selector(dismissBack:) forControlEvents:UIControlEventTouchUpInside];
//    }else if ([backType isEqualToString:@"pop"])
//    {
//        [backBtn addTarget:self action:@selector(popBack:) forControlEvents:UIControlEventTouchUpInside];
//    }
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    self.navigationItem.leftBarButtonItem = barButton;
//}

- (void)dismissBack:(id)sender
{
    Sog(@"dismissReturn");
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)popBack:(id)sender
{
    Sog(@"popReturn");
    [self.navigationController popViewControllerAnimated:YES];
}

//-(void)setRightNVBackButton:(NVRightBlock)nvRightBlock ImageNames:(NSString*)imageNames,...NS_REQUIRES_NIL_TERMINATION
//{
//    NSMutableArray *imageNames_MArr = [NSMutableArray array];
//    NSString *other = nil;
//    va_list args;//用于指向第一个参数
//    if (imageNames)
//    {
//        [imageNames_MArr addObject:imageNames];
//        //对args进行初始化，让它指向可变参数表里面的第一个参数
//        va_start(args, imageNames);
//        while((other = va_arg(args, NSString*)))
//        {
//            //获取指定类型的值
//            [imageNames_MArr addObject:other];
//        }
//        va_end(args);//将args关闭
//    }
//    if (imageNames_MArr.count == 0)
//    {
//        return;
//    }
//
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    backBtn.frame = CGRectMake(0, 0, NV_H, NV_H);
//    [backBtn setBackgroundImage:[UIImage imageNamed:imageNames_MArr[0]] forState:UIControlStateNormal];
//    if (imageNames_MArr.count == 2)
//    {
//        [backBtn setBackgroundImage:[UIImage imageNamed:imageNames_MArr[1]] forState:UIControlStateSelected];
//    }
//    [backBtn addTarget:self action:@selector(nvRightBackClick:) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    [backBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
//    self.navigationItem.rightBarButtonItem = barButton;
//    _nvRightBlock = nvRightBlock;
//}

- (void)nvRightBackClick:(UIButton *)sender
{
    if (_nvRightBlock)
    {
        _nvRightBlock(sender);
    }
}

- (void)eatFruit:(NSString*)fruit otherFruit:(NSString*)firstFruit,...NS_REQUIRES_NIL_TERMINATION
{
    NSString *other = nil;
    va_list args;//用于指向第一个参数
    NSMutableArray *fruits = [NSMutableArray array];
    [fruits addObject:fruit];
    if (firstFruit)
    {
        [fruits addObject:firstFruit];
        va_start(args, firstFruit);//对args进行初始化，让它指向可变参数表里面的第一个参数
        while((other = va_arg(args, NSString*)))
        {   //获取指定类型的值
            [fruits addObject:other];
        }
        va_end(args);//将args关闭
    }
     NSLog(@"%@", fruits);
}

// unicode转中文
- (NSString *)replaceUnicode:(NSString *)unicodeStr {
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    NSString *tempStr3 = [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"];
}

- (float)getFloat:(NSString*)originalString
{
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    //字符串扫描
    NSScanner *scanner = [NSScanner scannerWithString:originalString];
    //扫描查找的数字
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    while (![scanner isAtEnd])
    {
        //搜索到数字 然后把数字前的字符串提取出来 如果找到的字符串没用 第二个参数可以设置为空
        [scanner scanUpToCharactersFromSet:numbers intoString:&tempStr];
        //在当前位置查找数字 有数字就把相连接的数字拿出来
        //这些数字可以是一串33\0，输出330，中间有空格会跳到下个循环，前面有空格不会跳循环，也可以是一个
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    float number = [numberString floatValue];
    return number;
}

- (BOOL)isValidateMobile:(NSString*)mobile area:(NSString*)area
{
    //由于号段实时更新 做了如下调整
    //11位 并且为全数字 1开头
    if ([BaseModel getStr:mobile].length==0)
    {
        return NO;
    }
    if ([[BaseModel getStr:area] isEqualToString:@"+86"]||
        [BaseModel getStr:area].length==0)
    {
        if (mobile.length==11)
        {
            if ([BaseModel isPureInt:mobile])
            {
                //判断是否为1开头
                NSString *subStr = [mobile substringToIndex:1];
                if ([subStr isEqualToString:@"1"])
                {
                    return YES;
                }else
                {
                    return NO;
                }
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
    }else
    {
        if (mobile.length>=6&&mobile.length<=15)
        {
            if ([BaseModel isPureInt:mobile])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
    }
    
//    //手机号以13， 15，18开头，八个 \d 数字字符
//    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
//    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
//    return [phoneTest evaluateWithObject:mobile];
}

- (BOOL)isPureNumandCharacters:(NSString *)string
{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if(string.length > 0)
    {
        return NO;
    }
    return YES;
}

- (BOOL)validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}

- (BOOL)ascllPasswdIsValidate:(NSString*)password
{
    if ([BaseModel getStr:password].length>=6&&
        [BaseModel getStr:password].length<=16)
    {
        NSInteger strlen = [password length];
        NSInteger datalen = [[password dataUsingEncoding:NSUTF8StringEncoding] length];
        if (strlen != datalen) {
            return NO;
        }
        return YES;
    }else
    {
        return NO;
    }
}

- (BOOL)validateQQ:(NSString *)userQQ
{
    NSString *passWordRegex = @"[1-9][0-9]{4,}";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:userQQ];
}

- (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (BOOL) validateABC123:(NSString *)text
{
    NSString *textRegex = @"^[A-Za-z0-9]+$";
    NSPredicate *textTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",textRegex];
    return [textTest evaluateWithObject:text];
}

- (BOOL) validateSFZ:(NSString*)text
{
    BOOL result = YES;
    if (text.length==18)
    {
        NSString *charLast = [text substringFromIndex:text.length-1];
        NSString *charFirst = [text substringToIndex:text.length-1];
        if (![BaseModel isPureInt:charFirst])
        {
            result = NO;
        }else
        {
            //如果最后一个字符是字母
            if (![BaseModel isPureInt:charLast])
            {
                //不是X或x
                if (!([charLast isEqualToString:@"X"]||[charLast isEqualToString:@"x"]))
                {
                    result = NO;
                }
            }
        }
    }else if (text.length==15)
    {
        if (![BaseModel isPureInt:text])
        {
            result = NO;
        }
    }
    else
    {
        result = NO;
    }
    return result;
}

- (NSInteger)intervalTime:(NSString*)selectDate
{
    NSDateFormatter *formater_o = [[NSDateFormatter alloc] init];
    [formater_o setLocale:[NSLocale currentLocale]];
    [formater_o setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate* date_o = [formater_o dateFromString:selectDate];
    
    //两个时间相隔多少秒
    NSTimeInterval timeInterval_o = [date_o timeIntervalSinceNow];
    NSInteger hour = (timeInterval_o/60/60);
    return hour;
}

- (void)setupForDismissKeyboard:(NSLayoutConstraint*)lc
{
    _contentViewTopLC_P = lc;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //创建单机手势响应者
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissKeyboard)];
    __weak UIViewController *weakSelf = self;
    //创建主线程队列
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    //监听键盘弹出添加手势响应者
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.view addGestureRecognizer:tapGR];
    }];
    //监听键盘隐藏移除手势响应者
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.view removeGestureRecognizer:tapGR];
    }];
}

- (void)setupForDismissKeyboardWithVC:(UIViewController*)VC
{
    _dismissKeyboardVC = VC;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    //创建单机手势响应者
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDismissKeyboard)];
    __weak UIViewController *weakSelf = self;
    //创建主线程队列
    NSOperationQueue *mainQueue = [NSOperationQueue mainQueue];
    //监听键盘弹出添加手势响应者
    [nc addObserverForName:UIKeyboardWillShowNotification object:nil queue:mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.view addGestureRecognizer:tapGR];
    }];
    //监听键盘隐藏移除手势响应者
    [nc addObserverForName:UIKeyboardWillHideNotification object:nil queue:mainQueue usingBlock:^(NSNotification * _Nonnull note) {
        [weakSelf.view removeGestureRecognizer:tapGR];
    }];
}

- (void)tapDismissKeyboard
{
    Sog(@"tapDismissKeyboard");
    //此method会将self.view里所有的subview的first responder都resign掉
    [self.view endEditing:YES];
    if (_dismissKeyboardVC)
    {
        [_dismissKeyboardVC.view endEditing:YES];
    }
    if (_contentViewTopLC_P)
    {
        _contentViewTopLC_P.constant = 0;
    }
}

//- (void)addHeadImage
//{
//    //创建灰色层
//    _grayLayer = [[UIView alloc] initWithFrame:self.view.bounds];
//    [[UIView getTopController:self].view addSubview:_grayLayer];
//    _grayLayer.backgroundColor = RGB_COLOR(0, 0, 0, 0.45);
//    //添加点击手势 处理空白点击
//    UITapGestureRecognizer*tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(removeGrayLayer)];
//    [_grayLayer addGestureRecognizer:tapGesture];
//
//    //从相册添加
//    UIButton *photoBtn = [[UIButton alloc] initWithFrame:CGRectMake(-136, (SCREEN_H/2)-136/2, 136, 136)];
//    [photoBtn setBackgroundImage:[UIImage imageNamed:@"create_photo"] forState:UIControlStateNormal];
//    [photoBtn addTarget:self action:@selector(addImageDispatcher:) forControlEvents:UIControlEventTouchUpInside];
//    [_grayLayer addSubview:photoBtn];
//
//    //创建动画
//    [UIView transitionWithView:photoBtn duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        [photoBtn t_setX:(SCREEN_W/2)-136];
//    } completion:^(BOOL finished) {
//    }];
//
//    //判断是否支持相机
//    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
//    {
//        //从摄像机添加
//        UIButton *cameraBtn = [[UIButton alloc] initWithFrame:CGRectMake(SCREEN_W+136, (SCREEN_H/2)-136/2, 136, 136)];
//        cameraBtn.tag = 1;
//        [cameraBtn setBackgroundImage:[UIImage imageNamed:@"create_camera"] forState:UIControlStateNormal];
//        [cameraBtn addTarget:self action:@selector(addImageDispatcher:) forControlEvents:UIControlEventTouchUpInside];
//        [_grayLayer addSubview:cameraBtn];
//        [UIView transitionWithView:cameraBtn duration:0.5 options:UIViewAnimationOptionCurveEaseIn animations:^{
//            [cameraBtn t_setX:SCREEN_W/2];
//        } completion:^(BOOL finished) {
//        }];
//    }
//}

//添加图片的分发器
- (void)addImageDispatcher:(UIButton*)sender
{
    
}

- (void)removeGrayLayer
{
    [_grayLayer removeFromSuperview];
}

#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //确定
    if (buttonIndex==1)
    {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if([[UIApplication sharedApplication] canOpenURL:url])
        {
           [[UIApplication sharedApplication] openURL:url];
        }
    }
}

#pragma mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    Sog(@"imagePickerControllerDidCancel");
    [self removeGrayLayer];
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
}

- (void)loginAndRegisterWithInfos:(NSArray*)infos Url:(NSString*)url isAuto:(BOOL)isAuto
{
    
}

- (CGFloat) getCellScaleRate:(CGFloat)cellWidth
{
    return (SCREEN_W-30)/2/cellWidth;
}

- (UIImage*)originalImage:(UIImage*)image inset:(CGFloat)inset
{
    UIGraphicsBeginImageContext(image.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //添加红色线框
    //    CGContextSetLineWidth(context, 2);
    CGContextSetStrokeColorWithColor(context, [UIColor clearColor].CGColor);
    CGRect rect = CGRectMake(inset, inset, image.size.width - inset * 2.0f, image.size.height - inset * 2.0f);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    
    [image drawInRect:rect];
    CGContextAddEllipseInRect(context, rect);
    CGContextStrokePath(context);
    UIImage *newimg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimg;
}

+ (void)hideAllKeyBoard
{
    for (UIWindow* window in [UIApplication sharedApplication].windows)
    {
        for (UIView* view in window.subviews)
        {
            [BaseVC dismissAllKeyBoardInView:view];
        }
    }
}

+ (BOOL)dismissAllKeyBoardInView:(UIView *)view
{
    if([view isFirstResponder])
    {
        [view resignFirstResponder];
        return YES;
    }
    for(UIView *subView in view.subviews)
    {
        if([BaseVC dismissAllKeyBoardInView:subView])
        {
            return YES;
        }
    }
    return NO;
}

#pragma mark 控制器只支持竖屏, 浏览图片时支持横屏
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    // 根据状态栏判断
//    //Sog(@"NV_supportedInterfaceOrientations--");
//    if ([IOSingleData ioDataManager].isHorizontal)
//    {
//        Sog(@"->UIInterfaceOrientationMaskAllButUpsideDown");
//        return UIInterfaceOrientationMaskAllButUpsideDown;
//    } else
//    {
//        Sog(@"->UIInterfaceOrientationMaskPortrait");
//        return UIInterfaceOrientationMaskPortrait;
//    }
//}

//- (void)delayCall:(id)sender
//{
//    IOMineLoginVC  *login = [[IOMineLoginVC alloc]initWithOprate:SelfDismissBack];
//    [self presentViewController:login animated:YES completion:nil];
//}

+ (SIZEMODE)getSizeMode
{
    SIZEMODE sizeMode = MODE_320;
    if (SCREEN_W==320)
    {
        sizeMode = MODE_320;
    }else if (SCREEN_W==375)
    {
        sizeMode = MODE_375;
    }else if (SCREEN_W==414)
    {
        sizeMode = MODE_414;
    }
    return sizeMode;
}

- (void)setNaviBarHideOrShow:(BOOL)isHide
{
    [self.navigationController setNavigationBarHidden:isHide];
    self.navigationController.navigationBar.hidden = isHide;
}
@end
