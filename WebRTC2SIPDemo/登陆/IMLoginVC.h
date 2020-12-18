//
//  IMLoginVC.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/9/26.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMLoginVC : UIViewController
@property (nonatomic, strong) void (^loginSuccessBlock)(void);
@end

NS_ASSUME_NONNULL_END
