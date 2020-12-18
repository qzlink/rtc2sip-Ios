//
//  IMFriendModel.h
//  加密通讯
//
//  Created by apple on 2018/12/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMFriendModel : BaseModel
//昵称
@property (nonatomic, copy) NSString *nick;
//userid
@property (nonatomic, copy) NSString *userid;

@property (nonatomic, copy) NSString *userip;

//头像
//@property (nonatomic, copy) NSString *headimg;
//手机号
@property (nonatomic, copy) NSString *number;
//邮箱
@property (nonatomic, copy) NSString *email;
//是否已经邀请过
@property (nonatomic, assign) BOOL isInvited;
//是否我们的用户
@property (nonatomic, assign) BOOL isMyUser;
//是否为好友
@property (nonatomic, assign) BOOL isFriend;
@property (nonatomic, assign) NSRange searchRange;
//首字母
@property (nonatomic, copy) NSString *firstChar;
//好友申请备注
@property (nonatomic, copy) NSString *remark;
//申请时间
@property (nonatomic, copy) NSString *time;
//颜色值 0或者空字符串说明有头像 1~8代码不同的a颜色值
@property (nonatomic, assign) NSUInteger colorIndex;
//是否隐藏
@property (nonatomic, assign) BOOL isHide;

@property (nonatomic, assign) NSRange textRange;
@property (nonatomic, assign) NSRange remarkRange;
@property (nonatomic, assign) BOOL isSearchRemark;
//是否选择
@property (nonatomic, assign) BOOL isSelected;
//add:添加 reduce:减除
@property (nonatomic, copy) NSString *addOrReduce;
//是否不可变 YES:不能再选择或取消了
//@property (nonatomic, assign) BOOL isImmutable;
//状态
@property (nonatomic, copy) NSString *callstate;
//uuid
@property (nonatomic, copy) NSString *uuid;

+ (NSMutableArray*)getModels:(id)data isAddFirstChar:(BOOL)isAddFirstChar isRemovePrivateLinkMan:(BOOL)isRemovePrivateLinkMan;

+ (NSMutableArray*)getModelsForNewFriends:(id)data;

+ (NSMutableArray*)getModelsForLinkman:(id)data isAddRemark:(BOOL)isAddRemark;
@end
