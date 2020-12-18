//
//  IMHTTPSManager.h
//  加密通讯
//
//  Created by apple on 2018/12/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IMHTTPSManager : NSObject
+ (IMHTTPSManager *)sharedInstance;
//请求方式:json格式 超时时间30s 初始值基本都是默认的
@property (nonatomic, strong) AFHTTPSessionManager *manager;
//表单格式
@property (nonatomic, strong) AFHTTPSessionManager *HManager;
/** 公共GET接口 用于监听登录
 *  requestType HTTP:表单格式 JSON:json格式
 */
+ (NSURLSessionDataTask *)GET:(NSString *)URLString VC:(UIViewController*)VC
                  requestType:(NSString*)requestType time:(NSTimeInterval)time
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
/** 公共POST接口 用于监听登录
 *  requestType HTTP:表单格式 JSON:json格式
 */
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters VC:(UIViewController*)VC
                   requestType:(NSString*)requestType time:(NSTimeInterval)time
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;
@end
