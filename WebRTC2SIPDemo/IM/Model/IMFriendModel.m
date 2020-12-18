//
//  IMFriendModel.m
//  加密通讯
//
//  Created by apple on 2018/12/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IMFriendModel.h"

@implementation IMFriendModel
+ (NSMutableArray*)getModels:(id)data isAddFirstChar:(BOOL)isAddFirstChar isRemovePrivateLinkMan:(BOOL)isRemovePrivateLinkMan
{
    NSMutableArray *tempMArr = [NSMutableArray array];
    for (NSDictionary *dic in (NSArray*)data)
    {
        IMFriendModel *model = [[IMFriendModel alloc] init];
        model.nick = [BaseModel getStr:dic[@"name"]];
        model.userid = [BaseModel getStr:dic[@"userid"]];
        model.userip = [BaseModel getStr:dic[@"toip"]];
        model.remark = [BaseModel getStr:dic[@"remark"]];
        if (isAddFirstChar)
        {
//            if (model.remark.length!=0)
//            {
//                model.firstChar = [model.nick firstCharactor];
//            }else
//            {
//                model.firstChar = [model.nick firstCharactor];
//            }
        }
        NSString *private_val = [BaseModel getStr:dic[@"private_val"]];
        if ([private_val isEqualToString:@"yes"])
        {
            model.isHide = YES;
        }
        if (isRemovePrivateLinkMan)
        {
            if (!model.isHide)
            {
                [tempMArr addObject:model];
            }
        }else
        {
            [tempMArr addObject:model];
        }
    }
    return tempMArr;
}

+ (NSMutableArray*)getModelsForNewFriends:(id)data
{
    NSMutableArray *tempMArr = [NSMutableArray array];
    for (NSDictionary *dic in (NSArray*)data)
    {
        IMFriendModel *model = [[IMFriendModel alloc] init];
        model.nick = [BaseModel getStr:dic[@"nick"]];
        model.userid = [BaseModel getStr:dic[@"friendid"]];
        model.userip = [BaseModel getStr:dic[@"toip"]];
        
        model.remark = [BaseModel getStr:dic[@"remark"]];
        model.time = [BaseModel getStr:dic[@"time"]];
        [tempMArr addObject:model];
    }
    return tempMArr;
}

+ (NSMutableArray*)getModelsForLinkman:(id)data isAddRemark:(BOOL)isAddRemark
{
    NSMutableArray *tempMArr = [NSMutableArray array];
    for (NSDictionary *dic in (NSArray*)data)
    {
        IMFriendModel *model = [[IMFriendModel alloc] init];
        model.nick = [BaseModel getStr:dic[@"name"]];
        model.userid = [BaseModel getStr:dic[@"userid"]];
        //model.userip = [BaseModel getStr:[UD objectForKey:UDUserHost]];
        model.number = [BaseModel getStr:dic[@"phone"]];
        model.email = [BaseModel getStr:dic[@"email"]];
        if (isAddRemark)
        {
//            model.remark = [FMBaseDataManager getFriendRemark:model.userid];
        }
        [tempMArr addObject:model];
    }
    return tempMArr;
}
@end
