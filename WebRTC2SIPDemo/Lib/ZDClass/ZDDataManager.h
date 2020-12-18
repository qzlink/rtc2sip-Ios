//
//  ZDDataManager.h
//  MOXIN
//
//  Created by DongDong on 2019/7/16.
//  Copyright © 2019 mengya. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZDDataManager : NSObject
+ (ZDDataManager*)shareManager;
//固定格式 yyyy-MM-dd HH:mm:ss
@property (nonatomic, strong) NSDateFormatter *formatter;
//固定格式 yyyy-MM-dd HH:mm
@property (nonatomic, strong) NSDateFormatter *formatter_ss;
@end

NS_ASSUME_NONNULL_END
