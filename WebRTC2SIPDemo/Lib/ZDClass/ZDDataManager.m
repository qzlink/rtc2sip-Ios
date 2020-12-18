//
//  ZDDataManager.m
//  MOXIN
//
//  Created by DongDong on 2019/7/16.
//  Copyright © 2019 mengya. All rights reserved.
//

#import "ZDDataManager.h"

@implementation ZDDataManager
+ (ZDDataManager*)shareManager
{
    static ZDDataManager *manager = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (NSDateFormatter*)formatter
{
    if (_formatter==nil)
    {
        NSDateFormatter *formatter_z = [[NSDateFormatter alloc ] init];
        [formatter_z setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _formatter = formatter_z;
    }
    return _formatter;
}

- (NSDateFormatter*)formatter_ss
{
    if (_formatter_ss==nil)
    {
        NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        _formatter_ss = formatter;
    }
    return _formatter_ss;
}
@end
