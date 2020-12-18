//
//  IMClient.h
//  WebRTC2SIPDemo
//
//  Created by DongDong on 2019/9/5.
//  Copyright © 2019 qizhi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMClient : NSObject <IMQZClientReceiveMessageDelegate>
+ (IMClient *)sharedInstance;
- (void)onReceived:(NSDictionary *)message;
- (void)connectStatus:(NSInteger)connectStatus;

//国家区号
@property (nonatomic, strong) NSMutableArray *countryCodeList;

/**
 * 通过国家区号获取国家区号国家二字码
 */
- (NSString*)getISOWithCode:(NSString*)code;
@end

NS_ASSUME_NONNULL_END
