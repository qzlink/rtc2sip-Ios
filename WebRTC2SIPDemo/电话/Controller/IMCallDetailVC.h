//
//  IMCallDetailVC.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/11/28.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IMSessionModel;

@interface IMCallDetailVC : UIViewController
@property (nonatomic, strong) IMSessionModel *model;
@property (nonatomic, strong) NSDictionary *dic;

@end

NS_ASSUME_NONNULL_END
