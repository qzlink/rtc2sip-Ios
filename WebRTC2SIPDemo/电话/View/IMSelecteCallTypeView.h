//
//  IMSelecteCallTypeView.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/26.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSelecteCallTypeView : UIView
@property (nonatomic, strong) void (^inCallBlock)(void);
@property (nonatomic, strong) void (^outCallBlock)(void);
@end

NS_ASSUME_NONNULL_END
