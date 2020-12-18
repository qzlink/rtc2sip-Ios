//
//  IMInternationalMessageModel.h
//  加密通讯
//
//  Created by 萌芽科技 on 2019/1/22.
//  Copyright © 2019年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMInternationalMessageModel : NSObject
//@[@"phoneNum",@"code", @"targetPhoneNum",@"targetCode",@"messageDirection",@"name",@"content",@"sendStatus",@"messageId",@"extra"];
//@property (nonatomic, copy) NSString *phoneNum;
//@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *targetPhoneNum;
@property (nonatomic, copy) NSString *targetCode;
//对方国家简称
@property (nonatomic, copy) NSString *targetCountryShortName;

//@property (nonatomic, assign) IMMessageDirection messageDirection;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
//消息的发送状态 -1:发送失败 0:发送中 1:发送成功 2:对方已读 *
@property (nonatomic, copy) NSString *sendStatus;
@property (nonatomic, copy) NSString *messageId;
@property (nonatomic, copy) NSString *extra;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, copy) NSString *time;
//时间格式
@property (nonatomic, copy) NSString *time_form;
@end

NS_ASSUME_NONNULL_END
