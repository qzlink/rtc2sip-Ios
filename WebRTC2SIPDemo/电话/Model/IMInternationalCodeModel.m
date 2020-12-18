//
//  IMInternationalCodeModel.m
//  加密通讯
//
//  Created by 萌芽科技 on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import "IMInternationalCodeModel.h"

@implementation IMInternationalCodeModel
+ (NSMutableArray*)getModels:(id)data
{
    NSMutableArray *tempMArr = [NSMutableArray array];
    for (int i = 0; i < ((NSArray*)data).count; i ++)
    {
        if (i==0)
        {
            continue;
        }
        IMInternationalCodeModel *model = [[IMInternationalCodeModel alloc] init];
        NSArray *newData = (NSArray*)data;
        NSString *value = newData[i];
        NSArray *valueArr = [value componentsSeparatedByString:@","];
        for (int j = 0; j < valueArr.count; j ++)
        {
            NSString *value_a = valueArr[j];
            value_a = [value_a stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            value_a = [value_a stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            if (j==0)
            {
                model.countryName = value_a;
            }else if (j==1)
            {
                model.countryName_cn = value_a;
            }else if (j==2)
            {
                model.countryShortName = value_a;
                if (value_a.length!=0)
                {
                    model.firstChar = [value_a substringToIndex:1];
                }
            }else if (j==3)
            {
                model.code = value_a;
            }
        }
        [tempMArr addObject:model];
    }
    return tempMArr;
}

+ (NSMutableArray*)getModelWithData:(NSArray*)data
{
    NSMutableArray *tempMArr = [NSMutableArray array];
    for (int i = 0; i < data.count; i ++)
    {
        IMInternationalCodeModel *model = [[IMInternationalCodeModel alloc] init];
        NSDictionary *dic = data[i];
        model.countryName = [BaseModel getStr:dic[@"country_us"]];
        //中文名
        model.countryName_cn = [BaseModel getStr:dic[@"country_cn"]];
        //区号
        model.code = [BaseModel getStr:dic[@"prefix"]];
        //简称
        model.countryShortName = [BaseModel getStr:dic[@"iso"]];
        if (model.countryShortName.length!=0)
        {
            model.firstChar = [model.countryShortName substringToIndex:1];
        }
        [tempMArr addObject:model];
    }
    return tempMArr;
}

+ (NSMutableArray*)getModelWithPriceData:(NSArray*)data
{
    NSMutableArray *tempMArr = [NSMutableArray array];
    for (int i = 0; i < data.count; i ++)
    {
        IMInternationalCodeModel *model = [[IMInternationalCodeModel alloc] init];
        NSDictionary *dic = data[i];
        model.countryName = [BaseModel getStr:dic[@"country_us"]];
        //中文名
        model.countryName_cn = [BaseModel getStr:dic[@"country_cn"]];
        //区号
        //model.code = [BaseModel getStr:dic[@"prefix"]];
        //简称
        model.countryShortName = [BaseModel getStr:dic[@"iso"]];
        if (model.countryShortName.length!=0)
        {
            model.firstChar = [model.countryShortName substringToIndex:1];
        }
        [tempMArr addObject:model];
    }
    return tempMArr;
}
@end
