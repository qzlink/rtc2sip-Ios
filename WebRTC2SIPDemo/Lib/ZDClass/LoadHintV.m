//
//  LoadHintV.m
//  spamao
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "LoadHintV.h"

#define LH_FRAME_W 160
#define LH_FRAME_H 178
#define MESSAGE_W 200
#define hintL_H 27
#define FONT_SIZE 17

@interface LoadHintV ()
/**灰色层*/
@property (nonatomic, strong) UIView *grayLayer;
/**灰色框*/
@property (nonatomic, strong) UIView *grayFrame;
/**hint*/
@property (nonatomic, strong) UILabel *hintL;
/**加载动画*/
@property (nonatomic, strong) UIImageView *animationIV;
/**取消加载*/
@property (nonatomic, strong) UIButton *cancelLoadBtn;
@end

@implementation LoadHintV

- (id)initLoadHintType:(LOADHINT_TYPE)type duration:(CGFloat)duration
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    if (self)
    {
        if (type==HINT_TYPE)
        {
            //灰色框
            _grayFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 42)];
            _grayFrame.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
            [self addSubview:_grayFrame];
            _grayFrame.layer.cornerRadius = 5.0;
            _grayFrame.layer.masksToBounds = YES;
            _grayFrame.backgroundColor = RGB_COLOR(38, 38, 38, 0.6);
            
            //hint
            _hintL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MESSAGE_W, 27)];
            _hintL.center = CGPointMake(_grayFrame.width/2, _grayFrame.height/2);
            [_grayFrame addSubview:_hintL];
            _hintL.textColor = [UIColor whiteColor];
            _hintL.textAlignment = NSTextAlignmentCenter;
            //-Bold 粗体
            _hintL.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
            _hintL.numberOfLines = 0;
            
            __weak typeof (self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //渐变隐藏动画
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    weakSelf.alpha = 0;
                } completion:^(BOOL finished) {
                    [weakSelf removeFromSuperview];
                }];
            });
        }else
        {
            //创建灰色层
            _grayLayer = [[UIView alloc] initWithFrame:self.bounds];
            [self addSubview:_grayLayer];
            _grayLayer.backgroundColor = RGB_COLOR(0, 0, 0, 0.45);
            
            //灰色框
            _grayFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LH_FRAME_W, 138.5)];
            _grayFrame.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
            [self addSubview:_grayFrame];
            _grayFrame.layer.cornerRadius = 5.0;
            _grayFrame.layer.masksToBounds = YES;
            _grayFrame.backgroundColor = RGB_COLOR(92, 88, 88, 1);
            
            //加载动画
            _animationIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
            [_grayFrame addSubview:_animationIV];
            _animationIV.frame = CGRectMake(0, 0, 118, 118);
            _animationIV.center = CGPointMake(_grayFrame.width/2, 70);
            
            //hint
            _hintL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 27)];
            _hintL.center = _animationIV.center;
            [_grayFrame addSubview:_hintL];
            _hintL.text = @"正在加载...";
            _hintL.textAlignment = NSTextAlignmentCenter;
            _hintL.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
            if (type==LOADCANCEL_TYPE)
            {
                //取消加载
                _cancelLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, LH_FRAME_W, 40)];
                [_grayFrame addSubview:_cancelLoadBtn];
                _cancelLoadBtn.center = CGPointMake(_animationIV.center.x, 159);
                [_cancelLoadBtn setTitle:@"取消加载" forState:UIControlStateNormal];
                [_cancelLoadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_cancelLoadBtn setBackgroundImage:[self imageWithColor:RGB_COLOR(92, 88, 88, 1)] forState:UIControlStateNormal];
                _cancelLoadBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
                [_cancelLoadBtn addTarget:self action:@selector(cancelLoad:) forControlEvents:UIControlEventTouchUpInside];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 138.5, LH_FRAME_W, 0.5)];
                [_grayFrame addSubview:lineView];
                lineView.backgroundColor = [UIColor blackColor];
                _grayFrame.height = 178;
            }
            [self startAnimation];
        }
    }
    return self;
}

- (id)initLoadHintType:(LOADHINT_TYPE)type duration:(CGFloat)duration finish:(void (^)(void))completeBlock
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
    if (self)
    {
        if (type==HINT_TYPE)
        {
            //灰色框
            _grayFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 240, 42)];
            _grayFrame.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
            [self addSubview:_grayFrame];
            _grayFrame.layer.cornerRadius = 5.0;
            _grayFrame.layer.masksToBounds = YES;
            _grayFrame.backgroundColor = RGB_COLOR(38, 38, 38, 1);
            
            //hint
            _hintL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MESSAGE_W, 27)];
            _hintL.center = CGPointMake(_grayFrame.width/2, _grayFrame.height/2);
            [_grayFrame addSubview:_hintL];
            _hintL.textColor = [UIColor whiteColor];
            _hintL.textAlignment = NSTextAlignmentCenter;
            //-Bold 粗体
            _hintL.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
            _hintL.numberOfLines = 0;
        
            __weak typeof (self) weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //渐变隐藏动画
                [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                    weakSelf.alpha = 0;
                } completion:^(BOOL finished) {
                    completeBlock();
                    [weakSelf removeFromSuperview];
                }];
            });
        }else
        {
            //创建灰色层
            _grayLayer = [[UIView alloc] initWithFrame:self.bounds];
            [self addSubview:_grayLayer];
            _grayLayer.backgroundColor = RGB_COLOR(0, 0, 0, 0.45);
            
            //灰色框
            _grayFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LH_FRAME_W, 138.5)];
            _grayFrame.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
            [self addSubview:_grayFrame];
            _grayFrame.layer.cornerRadius = 5.0;
            _grayFrame.layer.masksToBounds = YES;
            _grayFrame.backgroundColor = RGB_COLOR(92, 88, 88, 1);
            
            //加载动画
            _animationIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"loading"]];
            [_grayFrame addSubview:_animationIV];
            _animationIV.frame = CGRectMake(0, 0, 118, 118);
            _animationIV.center = CGPointMake(_grayFrame.width/2, 70);
            
            //hint
            _hintL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 27)];
            _hintL.center = _animationIV.center;
            [_grayFrame addSubview:_hintL];
            _hintL.text = @"正在加载...";
            _hintL.textAlignment = NSTextAlignmentCenter;
            _hintL.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
            if (type==LOADCANCEL_TYPE)
            {
                //取消加载
                _cancelLoadBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, LH_FRAME_W, 40)];
                [_grayFrame addSubview:_cancelLoadBtn];
                _cancelLoadBtn.center = CGPointMake(_animationIV.center.x, 159);
                [_cancelLoadBtn setTitle:@"取消加载" forState:UIControlStateNormal];
                [_cancelLoadBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [_cancelLoadBtn setBackgroundImage:[self imageWithColor:RGB_COLOR(92, 88, 88, 1)] forState:UIControlStateNormal];
                _cancelLoadBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:FONT_SIZE];
                [_cancelLoadBtn addTarget:self action:@selector(cancelLoad:) forControlEvents:UIControlEventTouchUpInside];
                
                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 138.5, LH_FRAME_W, 0.5)];
                [_grayFrame addSubview:lineView];
                lineView.backgroundColor = [UIColor blackColor];
                _grayFrame.height = 178;
            }
            [self startAnimation];
        }
    }
    return self;
}

-(void)setIsFromTravel:(BOOL)isFromTravel
{
    _isFromTravel = isFromTravel;
    if (isFromTravel) {
        _grayFrame.backgroundColor = [UIColor purpleColor];
    }
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)cancelLoad:(id)sender
{
    Sog(@"cancelLoad");
    if (_loadCancelBlock)
    {
        _loadCancelBlock();
    }
    [self stopAnimation];
    [self removeFromSuperview];
}

- (void)setMessage:(NSString *)message
{
    _hintL.text = message;
    //根据内容设置frame
    CGSize size = [_hintL sizeThatFits:CGSizeMake(MESSAGE_W, MAXFLOAT)];
    _hintL.height = size.height;
    _grayFrame.height = _hintL.height+20;
    _hintL.center = CGPointMake(_grayFrame.width/2.0, _grayFrame.height/2.0);
    _grayFrame.center = CGPointMake(SCREEN_W/2, SCREEN_H/2);
}

//停止旋转动画
- (void)stopAnimation
{
    [_animationIV.layer removeAnimationForKey:@"rotateAnimation"];
}

//开始旋转动画
- (void)startAnimation
{
    //旋转动画
    CABasicAnimation* rotate =  [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //动画结束后不变回初始化状态
    rotate.removedOnCompletion = FALSE;
    //使用动画后不再返回原位置
    rotate.fillMode = kCAFillModeForwards;
    //动画属性的目标值
    [rotate setToValue: [NSNumber numberWithFloat: M_PI / 2]];
    
    //循环次数 零：一次 HUGE_VALF：永久
    rotate.repeatCount = HUGE_VALF;
    
    //持续时间 控制速度
    rotate.duration = 0.5;
    //是否保留上次动画的值
    rotate.cumulative = TRUE;
    //动画播放类型
    rotate.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [_animationIV.layer addAnimation:rotate forKey:@"rotateAnimation"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event
{
    Sog(@"touchesBegan");
}
@end
