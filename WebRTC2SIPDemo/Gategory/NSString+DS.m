//
//  NSString+DS.m
//  HuiLvLibDemo
//
//  Created by 宋利军 on 16/5/12.
//  Copyright © 2016年 宋利军. All rights reserved.
//

#import "NSString+DS.h"
//#import "NSDate+HLExtension.h"
//#import "NSCalendar+HLExtension.h"

@implementation NSString (DS)

/** 根据text内容返回宽度(宽度内部额外加10.0,最好只在单行文本上使用) */
- (CGFloat)widthWithSize:(CGSize)size textFont:(CGFloat)font {
    return [self boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size.width + 10.0;
}

- (CGSize)sizeWithMaxSize:(CGSize)maxSize textFont:(CGFloat)font {
    CGSize tempSize = [self boundingRectWithSize:maxSize
                                         options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil].size;
    return CGSizeMake(tempSize.width + 5.0, tempSize.height + 5.0);
}

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor {
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:self];
    //先转换为带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    //转化为大写拼音
    NSString *pinYin = [str capitalizedString];
    if (![pinYin isKindOfClass:[NSNull class]])
    {
        if(pinYin.length!=0)
        {
            //获取并返回首字母
            if (self.length>0)
            {
                //过滤曾姓多音字
                NSString *tempStr = [self substringToIndex:1];
                //如果是汉字
                if ([BaseModel IsChinese:tempStr])
                {
                    if ([tempStr isEqualToString:@"曾"])
                    {
                        return @"Z";
                    }
                    if ([tempStr isEqualToString:@"长"])
                    {
                        return @"C";
                    }
                }else if ([BaseModel isPureInt:tempStr])
                {
                    return @"#";
                }else if ([BaseModel isABC:tempStr])
                {
                    
                }else//特殊字符
                {
                    return @"#";
                }
            }
            return [pinYin substringToIndex:1];
        }else
        {
            return @"#";
        }
    }else
    {
        //获取并返回首字母
        return @"#";
    }
}

//快速获取首字母 不转大小写
- (NSString *)firstCharactor_A
{
    if ([BaseModel getStr:self].length!=0)
    {
        //转成了可变字符串
        NSMutableString *str = [NSMutableString stringWithString:[self substringToIndex:1]];
        //先转换为带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
        //再转换为不带声调的拼音
        CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
        if ([BaseModel getStr:self].length!=0)
        {
            return [str substringToIndex:1];
        }else
        {
            return @"z";
        }
    }else
    {
        return @"z";
    }
}

/**
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    Sog(@"jsonString == %@", jsonString);
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

/**
 * @brief 把字典转换成格式化的JSON格式的字符串
 * @param dic 字典
 * @return 返回格式化的JSON格式的字符串
 */
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dic
{
    if (!dic.count) {
        return nil;
    }
    /** 旧的方法
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&error];
    
    if (error) {
        NSLog(@"json压缩失败: %@", error);
        return nil;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonStr;
     */
    // NSJSONWritingSortedKeys这个枚举类型只适用iOS11所以我是使用下面写法解决的
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingSortedKeys error:&error];
    
    NSString *jsonString;
    if (!jsonData) {
        Sog(@"%@",error);
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

- (NSString *)createTime:(NSString *) dataString
{
    /**
    // 只创建一次常用的2个对象
    static NSDateFormatter *fmt = nil;
    if (fmt == nil) {
        fmt = [[NSDateFormatter alloc] init];
    }
    
    static NSCalendar *calendar = nil;
    if (calendar == nil) {
        calendar = [NSCalendar hl_calendar];
    }
    
    // 获得帖子的日期对象
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    
    NSDate *createdAtDate = [fmt dateFromString:dataString];
    
    
    
    // 判断处理
    if (createdAtDate.hl_isThisYear) {
        if (createdAtDate.hl_isToday)
        {
            // 今天
            NSCalendarUnit unit = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
            NSDateComponents *cmps = [calendar components:unit fromDate:createdAtDate toDate:[NSDate date] options:0];
            
            if (cmps.hour >= 1)
            {
                // 时间间隔 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前", cmps.hour];
            } else if (cmps.minute >= 1)
            {
                // 1小时 > 时间间隔 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前", cmps.minute];
            } else { // 时间间隔 < 1分钟
                return @"刚刚";
            }
        } else if (createdAtDate.hl_isYesterday)
        {
            // 昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:createdAtDate];
        } else { // 今年的其他天（除开今天、昨天）
            fmt.dateFormat = @"YYYY-MM-dd HH";
            return [NSString stringWithFormat:@"%@点",[fmt stringFromDate:createdAtDate]];
        }
    } else { // 非今年
        return self;
    }
     */
    return @"";
}

-  (int)charNumber
{
    int strlength = 0;
    char* p = (char*)[self cStringUsingEncoding:NSUTF8StringEncoding];
    for (int i=0 ; i<[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding] ;i++) {
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


+(NSString *)replaceHtmlStr:(NSString *)str
{
    //<br><br/> 替换成换行符号
    if ([BaseModel isKong:str]) {
        return @"";
    }
    
    if (!str.length) {
        return @"";
    }
    
    NSMutableString *bookStr = [[NSMutableString alloc]initWithString:str];
    [bookStr replaceOccurrencesOfString:@"<br>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, bookStr.length)];
    [bookStr replaceOccurrencesOfString:@"<br/>" withString:@"\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, bookStr.length)];
    return bookStr;
}

-(NSString *)hideTelephoneNumber
{
    if (![BaseModel isKong:self]) {
        if (self.length) {
            
            if (self.length > 5 && self.length < 11) {
                //显示规则 13***23 中间是剩余的位置用*代替
                NSInteger number = self.length - 4;
                return [self stringByReplacingCharactersInRange:NSMakeRange(2, number) withString:[self specialStarStr:number]];
            }else if (self.length >= 11){
                //显示规则 131***2323 中间是剩余的位置用*代替
                NSInteger number = self.length - 7;
                return [self stringByReplacingCharactersInRange:NSMakeRange(3, number) withString:[self specialStarStr:number]];
            }
            
            return self;
        }
        
        return @"";
    }
    
    return @"";
}

#pragma mark -- 获取*字符串
-(NSString *)specialStarStr:(NSInteger)number
{
    NSMutableString *mutableStr = [NSMutableString string];
    for (NSInteger i = 0; i < number; i++) {
        [mutableStr appendString:@"*"];
    }
    
    return mutableStr;
}

//超过一万 显示
-(NSString *)showCountFormat
{
    if ([self isKindOfClass:[NSNull class]] || self.length == 0 || [self intValue] < 0) {
        return @"0";
    }
    
    NSInteger count = [self integerValue];
    if (count > 10000) {
        return [NSString stringWithFormat:@"%.1fw",count/10000.f];
    }
    return self;
}

//超过一万四舍五入显示
-(NSString *)showCeilFormat
{
    if ([self isKindOfClass:[NSNull class]] || self.length == 0) {
        return @"0";
    }
    
    NSInteger count = [self integerValue];
    if (count > 100000) {
        count = count/100;
        if (count%10 >= 5 ) {
            count = count + 10 - count%10;
        }
        return [NSString stringWithFormat:@"%.1fw",count/100.f];
    }
    return self;
}

//中文格式
-(NSString *)showChineseCountFormat
{
    if ([self isKindOfClass:[NSNull class]] || self.length == 0 || [self intValue] < 0) {
        return @"0";
    }
    
    NSInteger count = [self integerValue];
    if (count > 10000) {
        return [NSString stringWithFormat:@"%.1f万",count/10000.f];
    }
    
    return self;
}

//颜色值转换
+ (UIColor*)hexColor:(NSString*)hexColor {
    
    unsigned int red, green, blue, alpha;
    NSRange range;
    range.length = 2;
    @try {
        if ([hexColor hasPrefix:@"#"]) {
            hexColor = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
        }
        range.location = 0;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&red];
        range.location = 2;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&green];
        range.location = 4;
        [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&blue];
        
        if ([hexColor length] > 6) {
            range.location = 6;
            [[NSScanner scannerWithString:[hexColor substringWithRange:range]] scanHexInt:&alpha];
        }
    }
    @catch (NSException * e) {
        //        [MAUIToolkit showMessage:[NSString stringWithFormat:@"颜色取值错误:%@,%@", [e name], [e reason]]];
        //        return [UIColor blackColor];
    }
    
    return [UIColor colorWithRed:(float)(red/255.0f) green:(float)(green/255.0f) blue:(float)(blue/255.0f) alpha:(float)(1.0f)];
}

+(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        [scanner scanUpToString:@"<" intoString:nil];
        [scanner scanUpToString:@">" intoString:&text];
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return html;
}

/**
 获取url的所有参数
 @param url 需要提取参数的url
 @return NSDictionary
 */
+ (NSDictionary *)parameterWithURL:(NSURL *)url
{
    NSMutableDictionary *parm = [[NSMutableDictionary alloc]init];
    //传入url创建url组件类
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url.absoluteString];
    
    //回调遍历所有参数，添加入字典
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [parm setObject:obj.value forKey:obj.name];
    }];
    return parm;
}

+ (NSString *)encodeToPercentEscapeString:(NSString *)input
{
    // Encode all the reserved characters, per RFC 3986
    /**
    NSString *outputStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)input,NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",kCFStringEncodingUTF8));
    return outputStr;
     */
    NSString *result = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)input ,NULL ,CFSTR("!*'();:@&=+$,/?%#[]") ,kCFStringEncodingUTF8));
    return result;
}

+ (NSString *)decodeFromPercentEscapeString:(NSString *)input
{
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+"
                               withString:@" "
                                  options:NSLiteralSearch
                                    range:NSMakeRange(0, [outputStr length])];
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

+ (BOOL)isSpecialString:(NSString*)value
{
    BOOL isFound = NO;
    NSString *string = @"~,￥,#,&,*,<,>,《,》,(,),[,],{,},【,】,^,@,/,￡,¤,,|,§,¨,「,」,『,』,￠,￢,￣,（,）,——,+,|,$,_,€,¥";
    NSArray *stringList = [string componentsSeparatedByString:@","];
    for (NSInteger i = 0; i < stringList.count; i ++)
    {
        //判断字符串中是否含有特殊符号
        if ([value rangeOfString:stringList[i]].location != NSNotFound)
        {
            isFound = YES;
            break;
        }
    }
    return isFound;
}
@end
