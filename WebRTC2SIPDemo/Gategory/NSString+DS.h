//
//  NSString+DS.h
//  HuiLvLibDemo
//
//  Created by 宋利军 on 16/5/12.
//  Copyright © 2016年 宋利军. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (DS)

/** 根据text内容返回宽度(宽度内部额外加10.0,最好只在单行文本上使用) */
- (CGFloat)widthWithSize:(CGSize)size textFont:(CGFloat)font;

- (CGSize)sizeWithMaxSize:(CGSize)maxSize textFont:(CGFloat)font;

//获取拼音首字母(传入汉字字符串, 返回大写拼音首字母)
- (NSString *)firstCharactor;

- (NSString *)firstCharactor_A;

/**
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/**
 * @brief 把字典转换成格式化的JSON格式的字符串
 * @param dic 字典
 * @return 返回格式化的JSON格式的字符串
 */
+ (NSString *)jsonStringWithDictionary:(NSDictionary *)dic;

- (NSString *)createTime:(NSString *) dataString;
//计算字符长度 一个汉字2个字符
-  (int)charNumber;

+(NSString *)replaceHtmlStr:(NSString *)str;

//显示隐藏的手机号码规则
-(NSString *)hideTelephoneNumber;
//超过一万 显示
-(NSString *)showCountFormat;
//超过一万四舍五入显示
-(NSString *)showCeilFormat;
//中文格式
-(NSString *)showChineseCountFormat;
//颜色值转换 转换类型：#ab8f9c  ab8f9c
+ (UIColor*)hexColor:(NSString*)hexColor;
//去除html类型的字符串
+(NSString *)filterHTML:(NSString *)html;

/**
 获取url的所有参数
 @param url 需要提取参数的url
 @return NSDictionary
 */
+ (NSDictionary *)parameterWithURL:(NSURL *)url;
//urlencoded 转码解码
+ (NSString *)encodeToPercentEscapeString:(NSString *)input;
+ (NSString *)decodeFromPercentEscapeString:(NSString *)input;

//是否包含特殊字符
+ (BOOL)isSpecialString:(NSString*)value;
@end
