//
//  IMInternationalCodeModel.h
//  加密通讯
//
//  Created by 萌芽科技 on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMInternationalCodeModel : BaseModel
//国家,中文名,代号,国家（或地区）码
//@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, copy) NSString *countryName;
//中文名
@property (nonatomic, copy) NSString *countryName_cn;
//区号
@property (nonatomic, copy) NSString *code;
//简称 CN ISO
@property (nonatomic, copy) NSString *countryShortName;
@property (nonatomic, copy) NSString *firstChar;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) NSRange searchRange;

+ (NSMutableArray*)getModelWithData:(NSArray*)data;
//用于推荐套餐
+ (NSMutableArray*)getModelWithPriceData:(NSArray*)data;
@end

NS_ASSUME_NONNULL_END
