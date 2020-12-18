//
//  NSDate+Tool.m
//  IO定制游
//
//  Created by 宋利军 on 17/6/7.
//  Copyright © 2017年 apple. All rights reserved.
//

#import "NSDate+Tool.h"
#import "ZDDataManager.h"

@implementation NSDate (Tool)
+ (NSDate*)getDateWithTimeInterval:(NSTimeInterval)interval
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    return date;
}

+ (NSString*)getCurrentTimeInterval
{
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970]*1000;
    NSString *timeInterval_s = [NSString stringWithFormat:@"%lld", (long long)timeInterval];
    return timeInterval_s;
}

+ (NSString*)getCurrentTimeInterval_10
{
    NSDate *date = [NSDate date];
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    NSString *timeInterval_s = [NSString stringWithFormat:@"%lld", (long long)timeInterval];
    return timeInterval_s;
}

+ (NSString*)getShortDateFormWithTimeInterval:(NSString*)timeInterval
{
    NSString *result_str = @"";
    if (timeInterval.length==0)
    {
        return result_str;
    }
    NSTimeInterval timeInterval_ll = [timeInterval longLongValue];
    if (timeInterval.length==13)
    {
        timeInterval_ll = timeInterval_ll/1000;
    }
    
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval value = currentTime-timeInterval_ll;
    
    NSUInteger day = value/(60*60*24);
    if (day<1)
    {
        NSDate *receivedTimeDate = [NSDate getDateWithTimeInterval:timeInterval_ll];
        result_str = [NSDate getDateAndTimeStrWithDate:receivedTimeDate type:@"HH:mm"];
    }else if(day>=1&&day<2)
    {
        result_str = @"昨天";
    }else
    {
        NSDate *receivedTimeDate = [NSDate getDateWithTimeInterval:timeInterval_ll];
        result_str = [NSDate getDateAndTimeStrWithDate:receivedTimeDate type:@"MM/dd"];
    }
    return result_str;
}

+ (NSDate*)getBeforeOrAfterDateWithInterval:(NSTimeInterval)interval data:(NSDate*)date
{
    //Sog(@"currentDate=%@", currentDate);
    NSTimeInterval timeInterval = [date timeIntervalSince1970];
    //Sog(@"newTimeInterval=%f", newTimeInterval);
    //timeInterval=1496712213
    NSTimeInterval newTimeInterval = timeInterval + interval;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:newTimeInterval];
    return newDate;
}

+ (NSDate*)getDateWithString:(NSString*)string type:(NSString*)type
{
    NSString *dateStr = @"";
    NSString *format = @"yyyyMMddHHmmss";
    if ([type isEqualToString:@"Default"])
    {
        dateStr = string;
    }else
    {
        if (string.length>=10)
        {
            NSString *year = [string substringToIndex:4];
            NSString *month = [string substringWithRange:NSMakeRange(5, 2)];
            NSString *day = [string substringWithRange:NSMakeRange(8, 2)];
            if ([type isEqualToString:@"Bar"])
            {
                //2017-06-09 16:00:00
                NSString *hour = @"00";
                NSString *minute = @"00";
                NSString *second = @"00";
                if (string.length>=16)
                {
                    hour = [string substringWithRange:NSMakeRange(11, 2)];
                    minute = [string substringWithRange:NSMakeRange(14, 2)];
                }
                if (string.length>=19)
                {
                    second = [string substringWithRange:NSMakeRange(17, 2)];
                }
                dateStr = [NSString stringWithFormat:@"%@%@%@%@%@%@", year,month,day,hour,minute,second];
            }else if ([type isEqualToString:@"Slach"])
            {
                dateStr = [NSString stringWithFormat:@"%@%@%@000000", year,month,day];
            }else if ([type isEqualToString:@"Chinese"])
            {
                dateStr = [NSString stringWithFormat:@"%@%@%@000000", year,month,day];
            }
        }
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    
    [df setDateFormat:format];
    
    //设置时区 中国时区
    //[df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    NSDate *resultDate =[df dateFromString:dateStr];
    return resultDate;
}

+ (NSString*)getDateAndTimeStrWithDate:(NSDate*)date type:(NSString*)type
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:type];
    NSString *resultStr = [formatter stringFromDate:date];
    return resultStr;
}

+ (NSString*)getDateWithFormatterFixed:(NSDate*)date
{
    NSString *resultStr = [[ZDDataManager shareManager].formatter stringFromDate:date];
    return resultStr;
}

+ (NSString*)getDateWithFormatterFixed_ss:(NSDate*)date
{
    NSString *resultStr = [[ZDDataManager shareManager].formatter_ss stringFromDate:date];
    return resultStr;
}

+ (NSString*)getWeekendStrWithDate:(NSDate*)date returnType:(NSString*)returnType
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *now = date;
    if (date==nil)
    {
        now = [NSDate date];
    }
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar components:unitFlags fromDate:now];
    //在这里需要注意的是：星期日是数字1，星期一时数字2，以此类推。。。
    NSString *returnStr = @"";
    if ([comps weekday]==1)
    {
        returnStr = @"日";
    }else if ([comps weekday]==2)
    {
        returnStr = @"一";
    }else if ([comps weekday]==3)
    {
        returnStr = @"二";
    }else if ([comps weekday]==4)
    {
        returnStr = @"三";
    }else if ([comps weekday]==5)
    {
        returnStr = @"四";
    }else if ([comps weekday]==6)
    {
        returnStr = @"五";
    }else if ([comps weekday]==7)
    {
        returnStr = @"六";
    }
    if ([returnType isEqualToString:@"0"])
    {
        returnStr = [NSString stringWithFormat:@"周%@", returnStr];
    }else
    {
        returnStr = [NSString stringWithFormat:@"星期%@", returnStr];
    }
    //Sog(@"-----------weekday is %d", (int)[comps weekday]);
    return returnStr;
}

+ (NSString*)getJiTianQianWithInterval:(NSTimeInterval)interval
{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // (后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = interval/1000;
    return [NSDate getShortTimeWithCurrentTime:currentTime createTime:createTime];
}

+ (NSString*)getJiTianQianWithDate:(NSDate*)date
{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 时间戳
    NSTimeInterval createTime = [date timeIntervalSince1970];
    return [NSDate getShortTimeWithCurrentTime:currentTime createTime:createTime];
}

//获取简化过的时间
+ (NSString*)getShortTimeWithCurrentTime:(NSTimeInterval)currentTime createTime:(NSTimeInterval)createTime
{
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    
    NSInteger minute = time/60;
    if (minute<=5)
    {
        return @"刚刚";
    }else if (minute<60&&5<minute)
    {
        return [NSString stringWithFormat:@"%ld分钟前",minute];
    }
    //秒转小时
    NSInteger hours = time/3600;
    if (hours<24)
    {
        return [NSString stringWithFormat:@"%ld小时前",hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%ld天前",days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%ld月前",months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%ld年前",years];
}

+ (NSInteger)howManyDaysInThisMonth:(NSInteger)month
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", date];
    int year = [timeNow intValue];
    if((month == 1)||(month == 3)||(month == 5)||(month == 7)||(month == 8)||(month == 10)||(month == 12))
    {
        return 31;
    }
    if((month == 4)||(month == 6)||(month == 9)||(month == 11))
    {
        return 30;
    }
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
        
    {
        return 28;
    }
    if(year%400 == 0)
    {
        return 29;
    }
    if(year%100 == 0)
    {
        return 28;
    }
    return 29;
}

+ (NSDate*)laterMonth:(NSDate *)date num:(NSUInteger)num
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +num;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSTimeInterval)timePartitionCount:(NSTimeInterval)timeInterval
{
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval tempValue = timeInterval/1000;
    return currentTime-tempValue;
}

+ (NSString*)getFormatTimeForTimeCount:(NSUInteger)timeCount
{
    NSString *tempStr = @"00:00";
    if (timeCount<10)
    {
        tempStr = [NSString stringWithFormat:@"00:0%d", (int)timeCount];
    }else
    {
        if (timeCount>=10&&timeCount<=60)
        {
            tempStr = [NSString stringWithFormat:@"00:%d", (int)timeCount];
        }else
        {
            NSUInteger min = timeCount/60;
            NSUInteger s = timeCount%60;
            NSUInteger h = timeCount/(60*60);
            if (h>0)
            {
                if (h<10)
                {
                    if (min<10)
                    {
                        if (s<10)
                        {
                            tempStr = [NSString stringWithFormat:@"0%d:0%d:0%d", (int)h, (int)min, (int)s];
                        }else
                        {
                            tempStr = [NSString stringWithFormat:@"0%d:0%d:%d", (int)h, (int)min, (int)s];
                        }
                    }else
                    {
                        if (s<10)
                        {
                            tempStr = [NSString stringWithFormat:@"0%d:%d:0%d", (int)h, (int)min, (int)s];
                        }else
                        {
                            tempStr = [NSString stringWithFormat:@"0%d:%d:%d", (int)h, (int)min, (int)s];
                        }
                    }
                }else
                {
                    if (min<10)
                    {
                        if (s<10)
                        {
                            tempStr = [NSString stringWithFormat:@"%d:0%d:0%d", (int)h, (int)min, (int)s];
                        }else
                        {
                            tempStr = [NSString stringWithFormat:@"%d:0%d:%d", (int)h, (int)min, (int)s];
                        }
                    }else
                    {
                        if (s<10)
                        {
                            tempStr = [NSString stringWithFormat:@"%d:%d:0%d", (int)h, (int)min, (int)s];
                        }else
                        {
                            tempStr = [NSString stringWithFormat:@"%d:%d:%d", (int)h, (int)min, (int)s];
                        }
                    }
                }
            }else
            {
                if (min<10)
                {
                    if (s<10)
                    {
                        tempStr = [NSString stringWithFormat:@"0%d:0%d", (int)min, (int)s];
                    }else
                    {
                        tempStr = [NSString stringWithFormat:@"0%d:%d", (int)min, (int)s];
                    }
                }else
                {
                    if (s<10)
                    {
                        tempStr = [NSString stringWithFormat:@"%d:0%d", (int)min, (int)s];
                    }else
                    {
                        tempStr = [NSString stringWithFormat:@"%d:%d", (int)min, (int)s];
                    }
                }
            }
        }
    }
    return tempStr;
}

+ (NSString*)getFormat24Or12
{
    NSString *value = @"24";
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    if (hasAMPM)
    {
        value = @"12";
    }
    return value;
}

+ (NSString*)getForenoonOfEvening
{
    NSString *value = @"上午";
    if ([[NSDate getFormat24Or12] isEqualToString:@"24"])
    {
        NSString *HH = [NSDate getDateAndTimeStrWithDate:[NSDate date] type:@"HH"];
        if ([HH integerValue]>=0&&[HH integerValue]<12)
        {
            value = @"上午";
        }else if ([HH integerValue]>=12&&[HH integerValue]<18)
        {
            value = @"下午";
        }else
        {
            value = @"晚上";
        }
    }else
    {
        NSString *aa = [NSDate getDateAndTimeStrWithDate:[NSDate date] type:@"aa"];
        if ([aa isEqualToString:@"上午"])
        {
            value = @"上午";
        }else
        {
            NSString *HH = [NSDate getDateAndTimeStrWithDate:[NSDate date] type:@"HH"];
            if ([HH integerValue]<6)
            {
                value = @"下午";
            }else
            {
                value = @"晚上";
            }
        }
    }
    return value;
}

+ (NSString*)getTimeFormWithTimeCount:(NSInteger)timeCount
{
    NSString *timeForm = @"00:00";
    if (timeCount<60)
    {
        if (timeCount<10)
        {
            timeForm = [NSString stringWithFormat:@"00:0%ld", timeCount];
        }else
        {
            timeForm = [NSString stringWithFormat:@"00:%ld", timeCount];
        }
    }else
    {
        NSUInteger minute = timeCount/60;
        if (minute<60)
        {
            NSUInteger second = timeCount%60;
            NSString *minute_s = @"00";
            if (minute<10)
            {
                minute_s = [NSString stringWithFormat:@"0%ld", minute];
            }else
            {
                minute_s = [NSString stringWithFormat:@"%ld", minute];
            }
            if (second<10)
            {
                timeForm = [NSString stringWithFormat:@"%@:0%ld", minute_s, second];
            }else
            {
                timeForm = [NSString stringWithFormat:@"%@:%ld", minute_s, second];
            }
        }else
        {
            NSUInteger hour = timeCount/(60*60);
            NSString *hour_s = @"00";
            if (hour<10)
            {
                hour_s = [NSString stringWithFormat:@"0%ld", hour];
            }else
            {
                hour_s = [NSString stringWithFormat:@"%ld", hour];
            }
            NSUInteger minute_a = (timeCount%(60*60))/60;
            NSString *minute_s = @"00";
            if (minute_a<10)
            {
                minute_s = [NSString stringWithFormat:@"0%ld", minute_a];
            }else
            {
                minute_s = [NSString stringWithFormat:@"%ld", minute_a];
            }
            NSUInteger second = (timeCount%(60*60))%60;
            if (second<10)
            {
                timeForm = [NSString stringWithFormat:@"%@:%@:0%ld", hour_s, minute_s, second];
            }else
            {
                timeForm = [NSString stringWithFormat:@"%@:%@:%ld", hour_s, minute_s, second];
            }
        }
    }
    return timeForm;
}
@end
