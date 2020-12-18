//
//  NSDate+Tool.h
//  IO定制游
//
//  Created by 宋利军 on 17/6/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Tool)
/** 时间戳转NSDate时间
 interval 时间戳 10位 以秒为单位
 */
+ (NSDate*)getDateWithTimeInterval:(NSTimeInterval)interval;

/** 获取当前时间戳 13位 精确到毫秒
 */
+ (NSString*)getCurrentTimeInterval;
/** 获取当前时间戳 10位 精确到秒
 */
+ (NSString*)getCurrentTimeInterval_10;
/** 时间戳转时间格式 比如:昨天
 */
+ (NSString*)getShortDateFormWithTimeInterval:(NSString*)timeInterval;

/** 获取date一定时间前或时间后的时间
 interval 比如一个小时后传:3600*1 一个小时前传:-3600*1
 */
+ (NSDate*)getBeforeOrAfterDateWithInterval:(NSTimeInterval)interval data:(NSDate*)date;


/** 年月日时分秒字符串转NSDate时间 20170901122300
 string 默认的类型:20170901122300 注意时间格式和lenth
 type Default:20170901122300 Chinese:2017年12月01日 Slach:2017/06/09 Bar:2017-06-09 16:00:00
 */
+ (NSDate*)getDateWithString:(NSString*)string type:(NSString*)type;


/** date按格式转年月日时分秒字符串
 type yyyy-MM-dd HH:mm:ss
 */
+ (NSString*)getDateAndTimeStrWithDate:(NSDate*)date type:(NSString*)type;

/** 固定格式 时间格式化 单列 节省电能损耗 yyyy-MM-dd HH:mm:ss
 */
+ (NSString*)getDateWithFormatterFixed:(NSDate*)date;

/** 固定格式 时间格式化 单列 节省电能损耗 yyyy-MM-dd HH:mm
 */
+ (NSString*)getDateWithFormatterFixed_ss:(NSDate*)date;

/** 判断date是星期几
 returnType 0:周一 1:星期一
 */
+ (NSString*)getWeekendStrWithDate:(NSDate*)date returnType:(NSString*)returnType;


/** 通过时间戳返回 几天前 几小时前 刚刚等
 
 */
+ (NSString*)getJiTianQianWithInterval:(NSTimeInterval)interval;


/** 通过时间返回 几天前 几小时前 刚刚等
 
 */
+ (NSString*)getJiTianQianWithDate:(NSDate*)date;

/** 判断一个月有多少天
 */

/** 该日期的多少月之后
 * date:该日期
 *num:多少月之后
 */
+ (NSDate*)laterMonth:(NSDate *)date num:(NSUInteger)num;

/** 返回该时间戳与现在的时间相隔多少秒
 *timeInterval:时间戳 13位
 */
+ (NSTimeInterval)timePartitionCount:(NSTimeInterval)timeInterval;

/**通过时间秒(100秒)获取固定的时间格式(01:40)
 */
+ (NSString*)getFormatTimeForTimeCount:(NSUInteger)timeCount;
/**判断是24小时制还是12小时制
 */
+ (NSString*)getFormat24Or12;
/**【0：:00-12:00为上午】、【12:00-18:00为下午】、【18:00-24:00为晚上】
 */
+ (NSString*)getForenoonOfEvening;
/**10进制的时间转化成60进制的时间格式
 */
+ (NSString*)getTimeFormWithTimeCount:(NSInteger)timeCount;
@end
