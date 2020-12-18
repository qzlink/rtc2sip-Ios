//
//  IMSelectInternationalCodeVC.h
//  加密通讯
//
//  Created by 萌芽科技 on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class IMInternationalCodeModel;

@interface IMSelectInternationalCodeVC : UIViewController
@property (nonatomic, strong) void (^selectCodeBlock)(IMInternationalCodeModel *model);
@property (nonatomic, assign) BOOL isAutoBack;

//网络获取的
@property (nonatomic, strong) NSMutableArray *countryData;
@end

NS_ASSUME_NONNULL_END
