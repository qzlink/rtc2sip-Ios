//
//  LoadHintV.h
//  spamao
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LOADHINT_TYPE)
{
    HINT_TYPE,
    LOAD_TYPE,
    LOADCANCEL_TYPE
};

@interface LoadHintV : UIView
@property (nonatomic, copy) NSString *message;
@property (nonatomic, assign) BOOL isFromTravel;
@property (nonatomic, strong) LoadCancelBlcok loadCancelBlock;

- (id)initLoadHintType:(LOADHINT_TYPE)type duration:(CGFloat)duration;

- (id)initLoadHintType:(LOADHINT_TYPE)type duration:(CGFloat)duration finish:(void (^)(void))completeBlock;
//停止旋转动画
- (void)stopAnimation;

@end
