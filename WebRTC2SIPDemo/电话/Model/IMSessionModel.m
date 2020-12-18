//
//  IMSessionModel.m
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/12/4.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import "IMSessionModel.h"

@implementation IMSessionModel
+ (NSMutableArray*)getModels:(id)data
{
    NSMutableArray *tempMArr = [NSMutableArray array];
    for (int i = 0; i < ((NSArray*)data).count; i ++)
    {
        NSDictionary *dic = ((NSArray*)data)[i];
        IMSessionModel *model = [[IMSessionModel alloc] init];
        model.call_date = [BaseModel getStr:dic[@"call_date"]];
        model.conference_uuid = [BaseModel getStr:dic[@"conference_uuid"]];
        model.conference_name = [BaseModel getStr:dic[@"conference_name"]];
        [tempMArr addObject:model];
    }
    return tempMArr;
}
@end
