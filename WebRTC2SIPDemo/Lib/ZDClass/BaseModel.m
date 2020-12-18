//
//  BaseModel.m
//  spamao
//
//  Created by Macx on 16/1/21.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "BaseModel.h"
#import <sys/utsname.h>
#import <CommonCrypto/CommonDigest.h>

@implementation BaseModel
+ (NSString*)getStr:(id)value
{
    NSString *str = @"";
    if ([value isKindOfClass:[NSString class]])
    {
        if ([value isEqualToString:@"(null)"]||[value isEqualToString:@"null"])
        {
            str = @"";
        }else
        {
            str = value;
        }
    }else if ([value isKindOfClass:[NSNumber class]])
    {
        str = [NSString stringWithFormat:@"%@", value];
    }else if ([value isKindOfClass:[NSNull class]])///////<null>
    {
        str = @"";
    }else if (value==nil)//(null)
    {
        str = @"";
    }
    
    NSString *tempStr = [NSString stringWithFormat:@"%@", value];
    //NSRange tempRange = [tempStr rangeOfString:@"<(null)>"];
    if ([tempStr isEqualToString:@"<(null)>"])//user<(null)>
    {
        str = @"";
    }
    
    //tempRange = [tempStr rangeOfString:@"<null>"];
    if ([tempStr isEqualToString:@"<null>"])
    {
        str = @"";
    }
    return str;
}

+ (id)getValue:(id)value
{
    if ([value isKindOfClass:[NSString class]])
    {
        return value;
    }else if ([value isKindOfClass:[NSNumber class]])
    {
        return value;
    }else if ([value isKindOfClass:[NSNull class]])
    {
        return nil;
    }
    return nil;
}

+ (NSMutableArray*)getModels:(id)data
{
    Sog(@"error===========================================BaseModel");
    return nil;
}

+ (NSMutableArray*)getModels:(id)data Type:(NSString*)type
{
    Sog(@"error===========================================BaseModel");
    return nil;
}

//+ (NSMutableArray*)getModelsWithRes:(FMResultSet*)res
//{
//    Sog(@"error===========================================BaseModel");
//    return nil;
//}

+ (NSString*)getTwoFormatTime:(NSString*)time
{
    NSString *result = time;
    if ([BaseModel getStr:time].length==1)
    {
        result = [NSString stringWithFormat:@"0%@", time];
    }
    return result;
}

//获取有效时间 "2016-01-27T07:49:08.000Z" "2016-01-27 07:49:08"
+ (NSString*)getNormalDate:(NSString*)date
{
    NSRange rangeA = {0,10};
    NSString * tempStrA = [date substringWithRange:rangeA];
    NSRange rangeB = {11,8};
    NSString * tempStrB = [date substringWithRange:rangeB];
    return [NSString stringWithFormat:@"%@ %@", tempStrA, tempStrB];
}

+ (NSDate*)getDateWithString:(NSString*)string format:(NSString*)format
{
   
    NSString *tempStr = string;
    NSRange range = [string rangeOfString:@"年"];//2017年02月15日
    if (range.location!=NSNotFound&&string.length==11)
    {
        NSString *year = [string substringToIndex:4];
        NSString *month = [string substringWithRange:NSMakeRange(5, 2)];
        NSString *day = [string substringWithRange:NSMakeRange(8, 2)];
        tempStr = [NSString stringWithFormat:@"%@%@%@000000", year,month,day];
    }else
    {
//        NSString *newTempStr = @"";
//        NSString *year = @"";
//        NSString *month = @"";
//        NSString *day = @"";
//        NSRange range_a = [string rangeOfString:@"-"];
//        if (tempStr.length>=4&&range_a.location!=NSNotFound)
//        {
//            year = [tempStr substringToIndex:4];
//            newTempStr = [NSString stringWithFormat:@"%@0101000000", year];
//            if (tempStr.length>=7)
//            {
//                month = [string substringWithRange:NSMakeRange(5, 2)];
//                newTempStr = [NSString stringWithFormat:@"%@%@01000000", year,month];
//                if (tempStr.length>=10)
//                {
//                    day = [string substringWithRange:NSMakeRange(8, 2)];
//                    newTempStr = [NSString stringWithFormat:@"%@%@%@000000", year,month,day];
//                }
//            }
//        }
//        if (newTempStr.length!=0)
//        {
//            tempStr = newTempStr;
//        }
    }
 
    NSDateFormatter *df = [[NSDateFormatter alloc] init];//格式化
    
    [df setDateFormat:format];
    
    //设置时区 中国时区
    [df setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    NSDate *date =[df dateFromString:tempStr];
    Sog(@"date=%@", date);
    return date;
}

+ (NSInteger)ageWithDateOfBirth:(NSDate *)date currentDate:(NSDate*)currentDate
{
    // 出生日期转换 年月日
    NSDateComponents *components1 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:date];
    NSInteger brithDateYear  = [components1 year];
    NSInteger brithDateDay   = [components1 day];
    NSInteger brithDateMonth = [components1 month];
    
    // 获取系统当前 年月日
    NSDateComponents *components2 = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:currentDate];
    NSInteger currentDateYear  = [components2 year];
    NSInteger currentDateDay   = [components2 day];
    NSInteger currentDateMonth = [components2 month];
    
    // 计算年龄
    NSInteger iAge = currentDateYear - brithDateYear - 1;
    if ((currentDateMonth > brithDateMonth) || (currentDateMonth == brithDateMonth && currentDateDay >= brithDateDay)) {
        iAge++;
    }
    return iAge;
}

+ (NSString*)getDataWithInterval:(NSTimeInterval)value format:(NSString*)format
{
    double interval = value/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter*df = [[NSDateFormatter alloc] init];
    [df setDateFormat:format];
    NSString *dateStr = [df stringFromDate:date];
    return dateStr;
}

+ (NSString*)getDataWithInterval:(NSTimeInterval)value
{
    //这个时间戳后面要去掉3个零
    double interval = value/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:interval];
    NSDateFormatter*df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateStr = [df stringFromDate:date];
    return dateStr;
}

+ (NSString*)getRangeDateSinceNowForInterval:(NSString*)value
{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [value doubleValue]/1000;
    //self.model.tracks.list[row].createdAt/1000;
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

+ (NSString*)getRangeDateSinceNowForFormat:(NSString*)value
{
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
    NSDate *timeDate = [dateFormatter dateFromString:value];
    
    //得到与当前时间差
    NSTimeInterval  timeInterval = [timeDate timeIntervalSinceNow];
    timeInterval = -timeInterval;
    //标准时间和北京时间差8个小时
    timeInterval = timeInterval - 8*60*60;
    long temp = 0;
    NSString *result;
    if (timeInterval < 60) {
        result = [NSString stringWithFormat:@"刚刚"];
    }
    else if((temp = timeInterval/60) <60){
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    }
    
    else if((temp = temp/60) <24){
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    }
    
    else if((temp = temp/24) <30){
        result = [NSString stringWithFormat:@"%ld天前",temp];
    }
    
    else if((temp = temp/30) <12){
        result = [NSString stringWithFormat:@"%ld月前",temp];
    }
    else{
        temp = temp/12;
        result = [NSString stringWithFormat:@"%ld年前",temp];
    }
    return  result;
}

+ (NSString*)getTimeWithType:(NSString*)type date:(NSDate*)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:type];
    NSString *tempDate = [formatter stringFromDate:[NSDate date]];
    if (date)
    {
        tempDate = [formatter stringFromDate:date];
    }
    NSString *timeNow = [[NSString alloc] initWithFormat:@"%@", tempDate];
    return timeNow;
}

//通过date获取星期几
+ (NSString*)getWeekendWithDate:(NSDate*)date
{
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:date];
    NSUInteger weekday = [componets weekday];//a就是星期几，1代表星期日，2代表星期一，后面依次
    Sog(@"weekday=%ld", weekday);
    /**
     NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
     NSDate *now;
     NSDateComponents *comps = [[NSDateComponents alloc] init];
     NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
     NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
     now=[NSDate date];
     comps = [calendar components:unitFlags fromDate:now];
     */
    
    //在这里需要注意的是：星期日是数字1，星期一时数字2，以此类推。。。
    NSString *returnStr = @"周一";
    if (weekday==1)
    {
        returnStr = @"周日";
    }else if (weekday==2)
    {
        returnStr = @"周一";
    }else if (weekday==3)
    {
        returnStr = @"周二";
    }else if (weekday==4)
    {
        returnStr = @"周三";
    }else if (weekday==5)
    {
        returnStr = @"周四";
    }else if (weekday==6)
    {
        returnStr = @"周五";
    }else if (weekday==7)
    {
        returnStr = @"周六";
    }
    //Sog(@"-----------weekday is %d", (int)[comps weekday]);
    return returnStr;
}

+ (NSDate*)getDateWithTimeInterval:(NSTimeInterval)timeInterval
{
    NSDate *currentDate = [NSDate date];
    //Sog(@"currentDate=%@", currentDate);
    NSTimeInterval newTimeInterval = [currentDate timeIntervalSince1970];
    //Sog(@"newTimeInterval=%f", newTimeInterval);
    //timeInterval=1496712213
    newTimeInterval += timeInterval;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:newTimeInterval];
    return newDate;
}

+ (NSDate*)getDateWithTimeInterval:(NSTimeInterval)timeInterval date:(NSDate*)date
{
    NSDate *currentDate = date;
    NSTimeInterval newTimeInterval = [currentDate timeIntervalSince1970];
    newTimeInterval = newTimeInterval+timeInterval;
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:newTimeInterval];
    return newDate;
}

//判断是否为整形
+ (BOOL)isPureInt:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return[scan scanInt:&val] && [scan isAtEnd];
}

//判断是否为浮点形
+ (BOOL)isPureFloat:(NSString*)string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}

//判断身份证的合法性
+ (BOOL)judgeIdentityStringValid:(NSString *)value
{
    /**
    NSString *regex2 = @"";
    if (identityString.length==18)
    {
        regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
        // 正则表达式判断基本 身份证号是否满足格式
        NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        //如果通过该验证，说明身份证格式正确，但准确性还需计算
        if(![identityStringPredicate evaluateWithObject:identityString]) return NO;
    }else if (identityString.length==15)
    {
        表达式有问题
        regex2 = @"^[1-9]\\d{5}\\d{2}((0[1-9])|(10|11|12))(([0-2][1-9])|10|20|30|31)\\d{2}$";
        // 正则表达式判断基本 身份证号是否满足格式
        NSPredicate *identityStringPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
        //如果通过该验证，说明身份证格式正确，但准确性还需计算
        if(![identityStringPredicate evaluateWithObject:identityString])
        {
            return NO;
        }else
        {
            return YES;
        }
    }else
    {
        return NO;
    }
    //if (identityString.length != 18) return NO;

    //将前17位加权因子保存在数组里
    NSArray *idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
    
    //这是除以11后，可能产生的11位余数、验证码，也保存成数组
    NSArray *idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
    
    //用来保存前17位各自乖以加权因子后的总和
    NSInteger idCardWiSum = 0;
    for(int i = 0;i < 17;i++) {
        NSInteger subStrIndex = [[identityString substringWithRange:NSMakeRange(i, 1)] integerValue];
        NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
        idCardWiSum+= subStrIndex * idCardWiIndex;
    }
    
    //计算出校验码所在数组的位置
    NSInteger idCardMod=idCardWiSum%11;
    //得到最后一位身份证号码
    NSString *idCardLast= [identityString substringWithRange:NSMakeRange(17, 1)];
    //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
    if(idCardMod==2) {
        if(![idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"]) {
            return NO;
        }
    }
    else{
        //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
        if(![idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]]) {
            return NO;
        }
    }
    return YES;
     */
    value = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length =0;
    
    if (!value) {
        
        return NO;
        
    }else {
        
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41",@"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    
    BOOL areaFlag =NO;
    
    for (NSString *areaCode in areasArray) {
        
        if ([areaCode isEqualToString:valueStart2]) {
            
            areaFlag = YES;
            
            break;
            
        }
        
    }
    
    if (!areaFlag) {
        return NO;
    }
    //生日部分的编码
    NSRegularExpression *regularExpression;
    
    NSUInteger numberofMatch;
    
    NSInteger year =0;
    if (length==15)
    {
        year = [value substringWithRange:NSMakeRange(8,2)].intValue +1900;
        
        if (year %400 ==0 || (year %100 !=0 && year %4 ==0)) {
            
            regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
                                 
                                                                    options:NSRegularExpressionCaseInsensitive
                                 
                                                                      error:nil];//测试出生日期的合法性
            
        }else {
            
            regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
                                 
                                                                    options:NSRegularExpressionCaseInsensitive
                                 
                                                                      error:nil];//测试出生日期的合法性
            
        }
        //numberofMatch:匹配到得字符串的个数
        numberofMatch = [regularExpression numberOfMatchesInString:value
                         
                                                           options:NSMatchingReportProgress
                         
                                                             range:NSMakeRange(0, value.length)];
        
        if(numberofMatch >0) {
            return YES;
        }else {
            return NO;
        }
    }else if (length==18)
    {
        year = [value substringWithRange:NSMakeRange(6,4)].intValue;
        
        if (year %400 ==0 || (year %100 !=0 && year %4 ==0)) {
            
            //原来的@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
            regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                 
                                                                    options:NSRegularExpressionCaseInsensitive
                                 
                                                                      error:nil];//测试出生日期的合法性
            
        }else {
            
            regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}(19|20)[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                 
                                                                    options:NSRegularExpressionCaseInsensitive
                                 
                                                                      error:nil];//测试出生日期的合法性
            
        }
        
        numberofMatch = [regularExpression numberOfMatchesInString:value
                         
                                                           options:NSMatchingReportProgress
                         
                                                             range:NSMakeRange(0, value.length)];
        //验证校验位
        if(numberofMatch >0) {
            
            int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
            
            int Y = S %11;
            NSString *M =@"F";
            NSString *JYM =@"10X98765432";
            M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
            if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                return YES;// 检测ID的校验位
            }else {
                return NO;
            }
        }else
        {
            return NO;
        }
    }else
    {
        return NO;
    }
}

+(BOOL)isIncludeSpecialCharact: (NSString *)str
{
    //***需要过滤的特殊字符：~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€。
    NSRange urgentRange = [str rangeOfCharacterFromSet: [NSCharacterSet characterSetWithCharactersInString: @"~￥#&*<>《》()[]{}【】^@/￡¤￥|§¨「」『』￠￢￣~@#￥&*（）——+|《》$_€"]];
    if (urgentRange.location == NSNotFound)
    {
        return NO;
    }
    return YES;
}

+ (BOOL)isABC:(NSString*)value
{
    NSString *regex =@"[a-zA-Z]*";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    if (![pred evaluateWithObject:value])
    {
        return NO;
    }
    return YES;
}

//获取当前时间戳 13位
+ (NSNumber *)getCurrentTimestamp
{
    double timeStamp = ceil([[NSDate date] timeIntervalSince1970] * 1000);
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setGeneratesDecimalNumbers:false];
    NSNumber *timeNumber = [NSNumber numberWithDouble:timeStamp];
    NSString *timeString = [formatter stringFromNumber:timeNumber];
    
    // NSTimeInterval is defined as double
    return [NSNumber numberWithLongLong:[timeString longLongValue]];
}

+ (NSInteger)isOvertimeInterval:(NSString*)value
{
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = [value doubleValue]/1000;
    //self.model.tracks.list[row].createdAt/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    //秒转天数
    NSInteger days = time/3600/24;
    //转分钟 用于调试
    //NSInteger days = time/60;
    return days;
}

//判断最后一个字符是不是我要裁剪的字符 是:裁剪
+ (NSString*)cutChar:(NSString*)targetData sourceData:(NSString*)sourceData
{
    NSString *cutResult = @"";
    NSString *tempSourceData = [BaseModel getStr:sourceData];
    NSString *tempTargettData = [BaseModel getStr:targetData];
    if (tempSourceData.length!=0&&tempTargettData.length!=0)
    {
        NSString *lastStr = [sourceData substringFromIndex:sourceData.length-1];
        if ([lastStr isEqualToString:targetData])
        {
            cutResult = [sourceData substringToIndex:sourceData.length-1];
        }else
        {
            cutResult = sourceData;
        }
    }
    return cutResult;
}

+ (BOOL)isValidateMobile:(NSString*)mobile area:(NSString*)area
{
    //由于号段实时更新 做了如下调整
    //11位 并且为全数字 1开头
    if ([BaseModel getStr:mobile].length==0)
    {
        return NO;
    }
    if ([[BaseModel getStr:area] isEqualToString:@"+86"]||
        [BaseModel getStr:area].length==0)
    {
        if (mobile.length==11)
        {
            //是否为纯数字
            if ([BaseModel isPureInt:mobile])
            {
                //判断是否为1开头
                NSString *subStr = [mobile substringToIndex:1];
                if ([subStr isEqualToString:@"1"])
                {
                    return YES;
                }else
                {
                    return NO;
                }
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
    }else
    {
        if (mobile.length>=6&&mobile.length<=15)
        {
            if ([BaseModel isPureInt:mobile])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else
        {
            return NO;
        }
    }
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    Sog(@"error===========================================BaseModel");
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        Sog(@"error===========================================BaseModel");
    }
    return self;
}

- (NSMutableDictionary*)getMDic
{
    Sog(@"error===========================================BaseModel");
    return nil;
}

+ (NSMutableArray*)getModelMDicMArr:(id)data
{
    Sog(@"error===========================================BaseModel");
    return nil;
}

+ (BOOL)archiveModel:(NSString*)fileName data:(NSMutableArray*)data
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.archiver", fileName]];
    if ([data isKindOfClass:[NSArray class]]||
        [data isKindOfClass:[NSMutableArray class]])
    {
        return [NSKeyedArchiver archiveRootObject:data toFile:newPath];
    }else
    {
        return [NSKeyedArchiver archiveRootObject:[NSMutableArray array] toFile:newPath];
    }
}

+ (NSMutableArray*)unArchiveModel:(NSString*)fileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.archiver", fileName]];
    NSArray *tempArr = [NSKeyedUnarchiver unarchiveObjectWithFile:newPath];
    return [NSMutableArray arrayWithArray:tempArr];
}

+ (BOOL)archiveMDic:(NSString*)fileName MDic:(NSMutableDictionary*)MDic
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.archiver", fileName]];
    if ([MDic isKindOfClass:[NSDictionary class]]||
        [MDic isKindOfClass:[NSMutableDictionary class]])
    {
        return [NSKeyedArchiver archiveRootObject:MDic toFile:newPath];
    }else
    {
        return [NSKeyedArchiver archiveRootObject:[NSMutableDictionary dictionary] toFile:newPath];
    }
}

+ (NSMutableDictionary*)unArchiveMDic:(NSString*)fileName
{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *newPath = [path stringByAppendingString:[NSString stringWithFormat:@"/%@.archiver", fileName]];
    NSDictionary *tempDic = [NSKeyedUnarchiver unarchiveObjectWithFile:newPath];
    return [NSMutableDictionary dictionaryWithDictionary:tempDic];
}

+ (BOOL)isKong:(id)value
{
    BOOL result = NO;
    if ([value isKindOfClass:[NSNull class]]||value==Nil||value==NULL||value==nil)
    {
        result = YES;
    }
    if ([value isKindOfClass:[NSString class]])
    {
        NSString *tempStr = [NSString stringWithFormat:@"%@", value];
        if ([tempStr isEqualToString:@"<null>"]||
            [tempStr isEqualToString:@"(null)"]||
            [tempStr isEqualToString:@"<(null)>"]||tempStr.length == 0)
        {
            result = YES;
        }
    }
    return result;
}

+ (NSString*)getDate2:(NSString*)value
{
    NSString *result = [BaseModel getStr:value];
    if (result.length<2)
    {
        NSInteger num = [value integerValue];
        if (num<10)
        {
            result = [NSString stringWithFormat:@"0%@", value];
        }
    }
    return result;
}

+ (NSString*)getHideStr:(NSString*)value prefix:(NSUInteger)prefix suffix:(NSUInteger)suffix
{
    NSString *resultStr = @"";
    if (prefix<=value.length)
    {
        NSString *prefix_t = [value substringToIndex:prefix];
        NSString *suffix_t = @"";
        if (value.length>prefix)
        {
            NSUInteger cutStr = value.length-prefix;
            if (cutStr>prefix)
            {
                suffix_t = [value substringFromIndex:value.length-suffix];
                //中间有*号
                NSMutableString *middle = [NSMutableString string];
                for (int i = 0 ; i < value.length-prefix-suffix; i ++)
                {
                    [middle appendString:@"*"];
                }
                resultStr = [NSString stringWithFormat:@"%@%@%@", prefix_t, middle, suffix_t];
            }else
            {
                NSMutableString *middle = [NSMutableString string];
                for (int i = 0 ; i < value.length-prefix; i ++)
                {
                    [middle appendString:@"*"];
                }
                //Sog(@"middle=%@", middle);
                resultStr = [NSString stringWithFormat:@"%@%@%@", prefix_t, middle, suffix_t];
            }
        }
    }else
    {
        resultStr = value;
    }
    return resultStr;
}

+ (NSString *)transform:(NSString *)chinese type:(NSString*)type
{
    if ([chinese isEqualToString:@"曾"])
    {
        return @"Zeng";
    }
    NSMutableString *pinyin = [chinese mutableCopy];
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform((__bridge CFMutableStringRef)pinyin, NULL, kCFStringTransformStripCombiningMarks, NO);
    NSString *resultStr = @"";
    if ([type isEqualToString:@"0"])
    {
        resultStr = [pinyin uppercaseString];
    }else if ([type isEqualToString:@"1"])
    {
        resultStr = [pinyin lowercaseString];
    }else if ([type isEqualToString:@"2"])
    {
        resultStr = [pinyin capitalizedString];
    }
    //首字母大写
    return resultStr;
}

+ (NSString*)transformChinessName:(NSString*)value
{
    NSString *resultStr = @"";
    NSArray *values = [value componentsSeparatedByString:@" "];
    if (values.count>1)
    {
        NSString *tempStr_A = @"";
        for (int i = 0; i < values.count; i ++)
        {
            NSString *tempStr = values[i];
            if (i>0)
            {
                tempStr = [BaseModel transform:tempStr type:@"1"];
            }
            tempStr_A = [NSString stringWithFormat:@"%@%@", tempStr_A,tempStr];
        }
        resultStr = tempStr_A;
    }else if (values.count==1)
    {
        resultStr = [values firstObject];
    }
    return resultStr;
}

//判断是否有中文
+(BOOL)IsChinese:(NSString *)str
{
    NSString *match = @"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:str];
}

+ (BOOL)IsContainNum:(NSString *)str
{
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[0-9]数字的个数，只要count>0，说明str中包含数字
    if (count > 0)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)IsContainLetter:(NSString *)str
{
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    if (count > 0) {
        return YES;
    }
    return NO;
}

+ (NSString *)md5:(NSString *)str
{
    // This is the md5 call
    const char *cStr = [str UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, strlen(cStr), result);
    NSString *resultStr = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
                           result[0], result[1], result[2], result[3],
                           result[4], result[5], result[6], result[7],
                           result[8], result[9], result[10], result[11],
                           result[12], result[13], result[14], result[15]
                           ];
    return [resultStr lowercaseString];

}

+(NSString *)timestampForMD5
{
    NSString *timestamp = [BaseModel getStr:[BaseModel getCurrentTimestamp]];
    //Sog(@"timestamp==%@", timestamp);
    NSString *cutStr = [timestamp substringFromIndex:timestamp.length-5];
    NSInteger value = 0;
    for (int i = 0; i < cutStr.length; i ++)
    {
        NSString *tempStr = [cutStr substringWithRange:NSMakeRange(i, 1)];
        value += [tempStr integerValue];
    }
    return [NSString stringWithFormat:@"%d", (int)value*2];
}

+ (NSString *)timestampForMD5WithTime:(NSString*)tempValue
{
    NSString *timestamp = tempValue;
    NSString *cutStr = [timestamp substringFromIndex:timestamp.length-5];
    NSInteger value = 0;
    for (int i = 0; i < cutStr.length; i ++)
    {
        NSString *tempStr = [cutStr substringWithRange:NSMakeRange(i, 1)];
        value += [tempStr integerValue];
    }
    return [NSString stringWithFormat:@"%d", (int)value*2];
}

+ (NSString*)getUUID
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    Sog(@"cfstring======%@", cfstring);
    NSString *uuidStr = [NSString stringWithFormat:@"%@", cfstring];
    CFRelease(cfstring);
    CFRelease(uuid);
    return uuidStr;
}

+(BOOL)isContainsEmoji:(NSString *)string
{
    if ([BaseModel isNineNumber:string])
    {
        return NO;
    }
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}

//+ (BOOL)isInputRuleAndNumber:(NSString *)str
//{
//    NSString *other = @"➋➌➍➎➏➐➑➒";     //九宫格的输入值
//    unsigned long len=str.length;
//    for(int i=0;i<len;i++)
//    {
//        unichar a=[str characterAtIndex:i];
//        if(!((isalpha(a))//判断字符变量c是否为字母或数字
//             //||(isalnum(a))
//             //             ||((a=='_') || (a == '-')) //判断是否允许下划线，昵称可能会用上
//             //||((a==' '))                 //判断是否允许控制
//             //||((a >= 0x4e00 && a <= 0x9fa6))
//             ||([other rangeOfString:str].location != NSNotFound)
//             ))
//            return NO;
//    }
//    return YES;
//}

+ (BOOL)isNineNumber:(NSString*)str
{
    NSString *other = @"➋➌➍➎➏➐➑➒";
    if ([other rangeOfString:str].location != NSNotFound)
    {
        return YES;
    }
    return NO;
}

+ (BOOL)isContainsNineNumber:(NSString *)string
{
    NSArray *numbers = @[@"➋", @"➌", @"➍", @"➎", @"➏", @"➐", @"➑", @"➒", ];
    BOOL isFound = NO;
    for (NSString *str in numbers)
    {
        if ([string rangeOfString:str].location != NSNotFound)
        {
            isFound = YES;
            break;
        }
    }
    return isFound;
}

+ (BOOL)isBetween:(NSString*)fristChar lastChar:(NSString*)lastChar targetStr:(NSString*)targetStr
{
    NSString *targetStr_temp = [BaseModel getStr:targetStr];
    NSString *fristChar_temp = [BaseModel getStr:fristChar];
    NSString *lastChar_temp = [BaseModel getStr:lastChar];
    
    BOOL isBetween = YES;
    for(int i =0; i < [targetStr_temp length]; i++)
    {
        NSString *temp = [BaseModel getStr:[targetStr_temp substringWithRange:NSMakeRange(i, 1)]];
        //如果小于fristChar_temp
        if ([temp compare:fristChar_temp]==NSOrderedAscending)
        {
            isBetween = NO;
            break;
        }
        //如果比最大的还要大
        if ([temp compare:lastChar_temp]==NSOrderedDescending)
        {
            isBetween = NO;
            break;
        }
    }
    return isBetween;
}

+ (NSString*)getCharWithNum:(int)num
{
    NSString *string = @"";
    for (int i = 0; i < num; i ++)
    {
        if (string.length==0)
        {
            string = @"\\";
        }else
        {
            string = [NSString stringWithFormat:@"%@\\", string];
        }
    }
    return string;
}

+ (NSString *)UIUtilsFomateJsonWithDictionary:(NSDictionary *)dic format:(NSString*)format isLayer:(BOOL)isLayer
{
    NSArray *keys = [dic allKeys];
    NSString *string = @"{";
    for (NSString *key in keys)
    {
        NSString *value = [dic objectForKey:key];
        if ([value isKindOfClass:[NSString class]])
        {
            if (string.length==1)
            {
                string = [NSString stringWithFormat:@"%@%@\"%@%@\":%@\"%@%@\"", string, format, key, format, format, value,format];
            }else
            {
                string = [NSString stringWithFormat:@"%@,%@\"%@%@\":%@\"%@%@\"", string, format, key, format, format, value, format];
            }
        }else if ([value isKindOfClass:[NSNumber class]])
        {
            if (string.length==1)
            {
                string = [NSString stringWithFormat:@"%@%@\"%@%@\":%@", string, format, key, format, value];
            }else
            {
                string = [NSString stringWithFormat:@"%@,%@\"%@%@\":%@", string, format, key, format, value];
            }
        }
        else if ([value isKindOfClass:[NSArray class]])
        {
            NSString *newValue = [BaseModel UIUtilsFomateJsonWithArray:(NSArray*)value format:format isLayer:isLayer];
            if (string.length==1)
            {
                string = [NSString stringWithFormat:@"%@%@\"%@%@\":%@", string, format, key, format, newValue];
            }else
            {
                string = [NSString stringWithFormat:@"%@,%@\"%@%@\":%@", string, format, key, format, newValue];
            }
        }else if ([value isKindOfClass:[NSDictionary class]])
        {
            if (isLayer)
            {
                NSString *newValue = [BaseModel UIUtilsFomateJsonWithDictionary:(NSDictionary*)value format:[self getCharWithNum:(int)(format.length*2+1)] isLayer:isLayer];
                if (string.length==1)
                {
                    string = [NSString stringWithFormat:@"%@%@\"%@%@\":%@\"%@%@\"", string, format, key, format, format, newValue, format];
                }else
                {
                    string = [NSString stringWithFormat:@"%@,%@\"%@%@\":%@\"%@%@\"", string, format, key, format, format, newValue, format];
                }
            }else
            {
                NSString *newValue = [BaseModel UIUtilsFomateJsonWithDictionary:(NSDictionary*)value format:format isLayer:isLayer];
                if (string.length==1)
                {
                    string = [NSString stringWithFormat:@"%@%@\"%@%@\":%@", string, format, key, format, newValue];
                }else
                {
                    string = [NSString stringWithFormat:@"%@,%@\"%@%@\":%@", string, format, key, format, newValue];
                }
            }
        }
    }
    string = [NSString stringWithFormat:@"%@}",string];
    return string;
}

+ (NSString *)UIUtilsFomateJsonWithArray:(NSArray *)arr format:(NSString*)format isLayer:(BOOL)isLayer
{
    NSString *string = @"[";
    for (id value in (NSArray*)arr)
    {
        if ([value isKindOfClass:[NSString class]]||
            [value isKindOfClass:[NSNumber class]]||
            [BaseModel isKong:value])
        {
            if (string.length==1)
            {
                string = [NSString stringWithFormat:@"%@%@\"%@%@\"", string, format, [BaseModel getStr:value], format];
            }else
            {
                string = [NSString stringWithFormat:@"%@,%@\"%@%@\"", string, format, [BaseModel getStr:value], format];
            }
        }else if ([value isKindOfClass:[NSArray class]])
        {
            NSString *newValue = [BaseModel UIUtilsFomateJsonWithArray:(NSArray*)value format:format isLayer:isLayer];
            if (string.length==1)
            {
                string = [NSString stringWithFormat:@"%@%@", string, newValue];
            }else
            {
                string = [NSString stringWithFormat:@"%@,%@", string, newValue];
            }
        }else if ([value isKindOfClass:[NSDictionary class]])
        {
            if (isLayer)
            {
                NSString *newValue = [BaseModel UIUtilsFomateJsonWithDictionary:(NSDictionary*)value format:[self getCharWithNum:(int)(format.length*2+1)] isLayer:YES];
                if (string.length==1)
                {
                    string = [NSString stringWithFormat:@"%@%@\"%@%@\"", string, format, newValue, format];
                }else
                {
                    string = [NSString stringWithFormat:@"%@,%@\"%@%@\"", string, format, newValue, format];
                }
            }else
            {
                NSString *newValue = [BaseModel UIUtilsFomateJsonWithDictionary:(NSDictionary*)value format:format isLayer:YES];
                if (string.length==1)
                {
                    string = [NSString stringWithFormat:@"%@%@", string, newValue];
                }else
                {
                    string = [NSString stringWithFormat:@"%@,%@", string, newValue];
                }
            }
        }
    }
    string = [NSString stringWithFormat:@"%@]", string];
    return string;
}

+ (NSString *)getProvinceNameWithProvinceId:(NSString*)provinceId
{
    NSString *provinceName = @"中国";
    if ([provinceId isEqualToString:@"110000"])
    {
        provinceName = @"北京";
    }else if ([provinceId isEqualToString:@"120000"])
    {
        provinceName = @"天津";
    }else if ([provinceId isEqualToString:@"130000"])
    {
        provinceName = @"河北";
    }else if ([provinceId isEqualToString:@"140000"])
    {
        provinceName = @"山西";
    }else if ([provinceId isEqualToString:@"150000"])
    {
        provinceName = @"内蒙古";
    }else if ([provinceId isEqualToString:@"210000"])
    {
        provinceName = @"辽宁";
    }else if ([provinceId isEqualToString:@"220000"])
    {
        provinceName = @"吉林";
    }else if ([provinceId isEqualToString:@"230000"])
    {
        provinceName = @"黑龙江";
    }else if ([provinceId isEqualToString:@"310000"])
    {
        provinceName = @"上海";
    }else if ([provinceId isEqualToString:@"320000"])
    {
        provinceName = @"江苏";
    }else if ([provinceId isEqualToString:@"330000"])
    {
        provinceName = @"浙江";
    }else if ([provinceId isEqualToString:@"340000"])
    {
        provinceName = @"安徽";
    }else if ([provinceId isEqualToString:@"350000"])
    {
        provinceName = @"福建";
    }else if ([provinceId isEqualToString:@"360000"])
    {
        provinceName = @"江西";
    }else if ([provinceId isEqualToString:@"370000"])
    {
        provinceName = @"山东";
    }else if ([provinceId isEqualToString:@"410000"])
    {
        provinceName = @"河南";
    }else if ([provinceId isEqualToString:@"420000"])
    {
        provinceName = @"湖北";
    }else if ([provinceId isEqualToString:@"430000"])
    {
        provinceName = @"湖南";
    }else if ([provinceId isEqualToString:@"440000"])
    {
        provinceName = @"广东";
    }else if ([provinceId isEqualToString:@"450000"])
    {
        provinceName = @"广西";
    }else if ([provinceId isEqualToString:@"460000"])
    {
        provinceName = @"海南";
    }else if ([provinceId isEqualToString:@"500000"])
    {
        provinceName = @"重庆";
    }else if ([provinceId isEqualToString:@"510000"])
    {
        provinceName = @"四川";
    }else if ([provinceId isEqualToString:@"520000"])
    {
        provinceName = @"贵州";
    }else if ([provinceId isEqualToString:@"530000"])
    {
        provinceName = @"云南";
    }else if ([provinceId isEqualToString:@"540000"])
    {
        provinceName = @"西藏";
    }else if ([provinceId isEqualToString:@"610000"])
    {
        provinceName = @"陕西";
    }else if ([provinceId isEqualToString:@"620000"])
    {
        provinceName = @"甘肃";
    }else if ([provinceId isEqualToString:@"630000"])
    {
        provinceName = @"青海";
    }else if ([provinceId isEqualToString:@"640000"])
    {
        provinceName = @"宁夏";
    }else if ([provinceId isEqualToString:@"650000"])
    {
        provinceName = @"新疆";
    }else if ([provinceId isEqualToString:@"710000"])
    {
        provinceName = @"台湾";
    }else if ([provinceId isEqualToString:@"810000"])
    {
        provinceName = @"香港";
    }else if ([provinceId isEqualToString:@"820000"])
    {
        provinceName = @"澳门";
    }
    return provinceName;
}

+ (NSString*)getFileSizeStr:(long long)size
{
    NSString *sizeStr = @"0K";
    if (size>0)
    {
        if (size<1024)
        {
            CGFloat size_kb = size/1024.0;
            sizeStr = [NSString stringWithFormat:@"%0.2fK", size_kb];
        }else
        {
            //M
            NSUInteger size_kb = size/1024;
            if (size_kb>1024)
            {
                CGFloat size_mb = size_kb/1024.0;
                sizeStr = [NSString stringWithFormat:@"%0.2fM", size_mb];
            }else
            {
                sizeStr = [NSString stringWithFormat:@"%ldK", size_kb];
            }
        }
    }
    return sizeStr;
}

+ (NSString*)getIphoneType
{
    NSString *iphoneType = @"";
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    if ([platform isEqualToString:@"iPhone1,1"])
    {
        iphoneType = @"iPhone 2G";
    }else if ([platform isEqualToString:@"iPhone1,2"])
    {
        iphoneType = @"iPhone 3G";
    }else if ([platform isEqualToString:@"iPhone2,1"])
    {
        iphoneType = @"iPhone 3GS";
    }else if ([platform isEqualToString:@"iPhone3,1"]||
              [platform isEqualToString:@"iPhone3,2"]||
              [platform isEqualToString:@"iPhone3,3"]){
        iphoneType = @"iPhone 4";
    }else if ([platform isEqualToString:@"iPhone4,1"])
    {
        iphoneType = @"iPhone 4S";
    }else if ([platform isEqualToString:@"iPhone5,1"]||
              [platform isEqualToString:@"iPhone5,2"])
    {
        iphoneType = @"iPhone 5";
    }else if ([platform isEqualToString:@"iPhone5,3"]||
              [platform isEqualToString:@"iPhone5,4"])
    {
        iphoneType = @"iPhone 5c";
    }else if ([platform isEqualToString:@"iPhone6,1"]||
              [platform isEqualToString:@"iPhone6,2"])
    {
        iphoneType = @"iPhone 5s";
    }else if ([platform isEqualToString:@"iPhone7,1"])
    {
        iphoneType = @"iPhone 6 Plus";
    }else if ([platform isEqualToString:@"iPhone7,2"])
    {
        iphoneType = @"iPhone 6";
    }else if ([platform isEqualToString:@"iPhone8,1"])
    {
        iphoneType = @"iPhone 6s";
    }else if ([platform isEqualToString:@"iPhone8,2"])
    {
        iphoneType = @"iPhone 6s Plus";
    }else if ([platform isEqualToString:@"iPhone8,4"])
    {
        iphoneType = @"iPhone SE";
    }else if ([platform isEqualToString:@"iPhone9,1"])
    {
        iphoneType = @"iPhone 7";
    }else if ([platform isEqualToString:@"iPhone9,2"])
    {
        iphoneType = @"iPhone 7 Plus";
    }else if ([platform isEqualToString:@"iPhone10,1"]||
              [platform isEqualToString:@"iPhone10,4"])
    {
        iphoneType = @"iPhone 8";
    }else if ([platform isEqualToString:@"iPhone10,2"]||
              [platform isEqualToString:@"iPhone10,5"])
    {
        iphoneType = @"iPhone 8 Plus";
    }else if ([platform isEqualToString:@"iPhone10,3"]||
              [platform isEqualToString:@"iPhone10,6"])
    {
        iphoneType = @"iPhone X";
    }else if ([platform isEqualToString:@"iPhone11,2"])
    {
        iphoneType = @"iPhone XS";
    }else if ([platform isEqualToString:@"iPhone11,6"])
    {
        iphoneType = @"iPhone XS Max";
    }else if ([platform isEqualToString:@"iPhone11,8"])
    {
        iphoneType = @"iPhone XR";
    }
    else if ([platform isEqualToString:@"iPod1,1"])
    {
        iphoneType = @"iPod Touch 1G";
    }else if ([platform isEqualToString:@"iPod2,1"])
    {
        iphoneType = @"iPod Touch 2G";
    }else if ([platform isEqualToString:@"iPod3,1"])
    {
        iphoneType = @"iPod Touch 3G";
    }else if ([platform isEqualToString:@"iPod4,1"])
    {
        iphoneType = @"iPod Touch 4G";
    }else if ([platform isEqualToString:@"iPod5,1"])
    {
        iphoneType = @"iPod Touch 5G";
    }else if ([platform isEqualToString:@"iPad1,1"])
    {
        iphoneType = @"iPad 1G";
    }else if ([platform isEqualToString:@"iPad2,1"]||
              [platform isEqualToString:@"iPad2,2"]||
              [platform isEqualToString:@"iPad2,3"]||
              [platform isEqualToString:@"iPad2,4"])
    {
        iphoneType = @"iPad 2";
    }else if ([platform isEqualToString:@"iPad2,5"]||
              [platform isEqualToString:@"iPad2,6"]||
              [platform isEqualToString:@"iPad2,7"])
    {
        iphoneType = @"iPad Mini 1G";
    }else if ([platform isEqualToString:@"iPad3,1"]||
              [platform isEqualToString:@"iPad3,2"]||
              [platform isEqualToString:@"iPad3,3"])
    {
        iphoneType = @"iPad 3";
    }else if ([platform isEqualToString:@"iPad3,4"]||
              [platform isEqualToString:@"iPad3,5"]||
              [platform isEqualToString:@"iPad3,6"])
    {
        iphoneType = @"iPad 4";
    }else if ([platform isEqualToString:@"iPad4,1"]||
              [platform isEqualToString:@"iPad4,2"]||
              [platform isEqualToString:@"iPad4,3"])
    {
        iphoneType = @"iPad Air";
    }else if ([platform isEqualToString:@"iPad4,4"]||
              [platform isEqualToString:@"iPad4,5"]||
              [platform isEqualToString:@"iPad4,6"])
    {
        iphoneType = @"iPad Mini 2G";
    }else if ([platform isEqualToString:@"iPad4,7"]||
              [platform isEqualToString:@"iPad4,8"]||
              [platform isEqualToString:@"iPad4,9"])
    {
        iphoneType = @"iPad Mini 3";
    }else if ([platform isEqualToString:@"iPad5,1"]||
              [platform isEqualToString:@"iPad5,2"])
    {
        iphoneType = @"iPad Mini 4";
    }else if ([platform isEqualToString:@"iPad5,3"]||
              [platform isEqualToString:@"iPad5,4"])
    {
        iphoneType = @"iPad Air 2";
    }else if ([platform isEqualToString:@"iPad6,3"]||
              [platform isEqualToString:@"iPad6,4"])
    {
        iphoneType = @"iPad Pro 9.7";
    }else if ([platform isEqualToString:@"iPad6,7"]||
              [platform isEqualToString:@"iPad6,8"])
    {
        iphoneType = @"iPad Pro 12.9";
    }
    else if ([platform isEqualToString:@"i386"]||
             [platform isEqualToString:@"x86_64"])
    {
        iphoneType = @"iPhone Simulator";
    }
    return iphoneType;
}

+ (int)charNumber:(NSString*)value
{
    int strlength = 0;
    char* p = (char*)[value cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i=0 ; i<[value lengthOfBytesUsingEncoding:NSUTF8StringEncoding] ;i++) {
        if (*p) {
            if(*p == '\xe4' || *p == '\xe5' || *p == '\xe6' || *p == '\xe7' || *p == '\xe8' || *p == '\xe9')
            {
                strlength--;
            }
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}

+ (UIColor *)getHeadColorImageWithNumber:(NSUInteger)number
{
    NSUInteger r = number;
    UIColor *color = nil;
    if (r==1)
    {
        color = RGB_COLOR(190, 230, 224, 1);
    }else if (r==2)
    {
        color = RGB_COLOR(205, 235, 186, 1);
    }else if (r==3)
    {
        color = RGB_COLOR(242, 213, 242, 1);
    }else if (r==4)
    {
        color = RGB_COLOR(178, 220, 255, 1);
    }else if (r==5)
    {
        color = RGB_COLOR(247, 216, 182, 1);
    }else if (r==6)
    {
        color = RGB_COLOR(208, 206, 242, 1);
    }else if (r==7)
    {
        color = RGB_COLOR(246, 175, 171, 1);
    }else if (r==8)
    {
        color = RGB_COLOR(251, 232, 147, 1);
    }else
    {
        color = RGB_COLOR(190, 230, 224, 1);
    }
    return color;
}

+ (NSString*)getHeadUrlWithUserid:(NSString*)userid
{
    return nil;//[NSString stringWithFormat:@"%@head/%@_s.jpg", APP_Head_url, userid];
}
@end
