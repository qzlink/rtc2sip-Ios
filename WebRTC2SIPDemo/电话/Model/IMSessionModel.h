//
//  IMSessionModel.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/12/4.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMSessionModel : BaseModel
@property (nonatomic, copy) NSString *call_date;

@property (nonatomic, copy) NSString *conference_uuid;

@property (nonatomic, copy) NSString *conference_name;
@end

NS_ASSUME_NONNULL_END
