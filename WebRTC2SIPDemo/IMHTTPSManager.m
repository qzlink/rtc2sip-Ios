//
//  IMHTTPSManager.m
//  加密通讯
//
//  Created by apple on 2018/12/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "IMHTTPSManager.h"

@implementation IMHTTPSManager
+ (IMHTTPSManager *)sharedInstance
{
    static IMHTTPSManager *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[IMHTTPSManager alloc] init];
    });
    return instance;
}

- (AFHTTPSessionManager *)manager
{
    if (_manager==nil)
    {
        _manager = [IMHTTPSManager httpsRequsetManager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFJSONResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    _manager.requestSerializer.timeoutInterval = 60.0;
    return _manager;
}

- (AFHTTPSessionManager *)HManager
{
    if (_HManager==nil)
    {
        _HManager = [IMHTTPSManager httpsRequsetManager];
        _HManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _HManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _HManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", @"text/plain", nil];
    }
    _HManager.requestSerializer.timeoutInterval = 60.0;
    return _HManager;
}

/** 公共GET接口 用于监听登录
 *  requestType HTTP:表单格式 JSON:json格式
 */
+ (NSURLSessionDataTask *)GET:(NSString *)URLString VC:(UIViewController*)VC
                  requestType:(NSString*)requestType time:(NSTimeInterval)time
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    NSString *url = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [IMHTTPSManager sharedInstance].manager;
    manager.requestSerializer.timeoutInterval = time;
    if ([requestType isEqualToString:@"HTTP"])
    {
        manager = [IMHTTPSManager sharedInstance].HManager;
    }
    NSURLSessionDataTask *task = [manager GET:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![BaseModel isKong:responseObject])
        {
            //NSString *retcode = [BaseModel getStr:responseObject[@"retcode"]];
            if (success)
            {
                success(task,responseObject);
            }
        }else
        {
            if (failure)
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"解析错误", NSLocalizedDescriptionKey, @"服务器返回空包", NSLocalizedFailureReasonErrorKey, @"",NSLocalizedRecoverySuggestionErrorKey,nil];
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
                failure(task,error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            failure(task,error);
        }
    }];
    return task;
}

/** 公共POST接口 用于监听登录
 *  requestType HTTP:表单格式 JSON:json格式
 */
+ (NSURLSessionDataTask *)POST:(NSString *)URLString parameters:(id)parameters VC:(UIViewController*)VC
                   requestType:(NSString*)requestType time:(NSTimeInterval)time
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    //_weak UIViewController *weakVC = VC;
    NSString *url = [URLString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [IMHTTPSManager sharedInstance].manager;
    manager.requestSerializer.timeoutInterval = time;
    if ([requestType isEqualToString:@"HTTP"])
    {
        manager = [IMHTTPSManager sharedInstance].HManager;
    }
    NSURLSessionDataTask *task = [manager POST:url parameters:parameters headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (![BaseModel isKong:responseObject])
        {
            NSString *retcode = [BaseModel getStr:responseObject[@"retcode"]];
            /**
             if ([retcode isEqualToString:@"202"]&&VC&&
             ![[IOSingleData ioDataManager].allVC isKindOfClass:[IOMineLoginVC class]])
             {
             if (success)
             {
             success(task,responseObject);
             }
             if (weakVC)
             {
             IOLoginRemindView *view = [IOLoginRemindView remindView];
             view.loginCallBack = ^(){
             IOMineLoginVC *loginVC = [[IOMineLoginVC alloc] initWithOprate:PopBack];
             [weakVC.navigationController pushViewController:loginVC animated:YES];
             };
             [view showInController:weakVC];
             }
             }else
             {
             if (success)
             {
             success(task,responseObject);
             }
             }
             */
            if (success)
            {
                success(task,responseObject);
            }
        }else
        {
            if (failure)
            {
                NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"解析错误", NSLocalizedDescriptionKey, @"服务器返回空包", NSLocalizedFailureReasonErrorKey, @"",NSLocalizedRecoverySuggestionErrorKey,nil];
                NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
                failure(task,error);
            }
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure)
        {
            failure(task,error);
        }
    }];
    return task;
}

+ (AFHTTPSessionManager *)httpsRequsetManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // 2.设置非校验证书模式
    NSUInteger currentHttp = 1;
    if (currentHttp == 2) {
        //免证书模式 下个版本再使用证书
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
        return manager;
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeCertificate];
        
        securityPolicy.allowInvalidCertificates = YES;//是否允许使用自签名证书
        securityPolicy.validatesDomainName = NO;//是否需要验证域名，默认YES
        
        manager.securityPolicy = securityPolicy;
        [manager setSessionDidReceiveAuthenticationChallengeBlock:^NSURLSessionAuthChallengeDisposition(NSURLSession *session, NSURLAuthenticationChallenge *challenge, NSURLCredential *__autoreleasing *_credential) {
            
            SecTrustRef serverTrust = [[challenge protectionSpace] serverTrust];
            
            /**
             *  导入多张CA证书
             */
            NSString *cerPath = [[NSBundle mainBundle] pathForResource:@"huilvDi" ofType:@"cer"];//自签名证书
            
            NSData* caCert = [NSData dataWithContentsOfFile:cerPath];
            
            NSArray *cerArray = @[caCert];
            
            manager.securityPolicy.pinnedCertificates = cerArray;
            SecCertificateRef caRef = SecCertificateCreateWithData(NULL, (__bridge CFDataRef)caCert);
            
            NSCAssert(caRef != nil, @"caRef is nil");
            
            
            
            NSArray *caArray = @[(__bridge id)(caRef)];
            
            NSCAssert(caArray != nil, @"caArray is nil");
            
            
            
            OSStatus status = SecTrustSetAnchorCertificates(serverTrust, (__bridge CFArrayRef)caArray);
            
            SecTrustSetAnchorCertificatesOnly(serverTrust,NO);
            
            NSCAssert(errSecSuccess == status, @"SecTrustSetAnchorCertificates failed");
            
            
            
            NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
            
            __autoreleasing NSURLCredential *credential = nil;
            
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                
                if ([manager.securityPolicy evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:challenge.protectionSpace.host]) {
                    
                    credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
                    
                    if (credential) {
                        
                        disposition = NSURLSessionAuthChallengeUseCredential;
                        
                    } else {
                        
                        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                        
                    }
                    
                } else {
                    
                    disposition = NSURLSessionAuthChallengeCancelAuthenticationChallenge;
                    
                }
                
            } else {
                
                disposition = NSURLSessionAuthChallengePerformDefaultHandling;
                
            }
            return disposition;
            
        }];
    }
    else
    {
        manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        manager.securityPolicy.allowInvalidCertificates = YES;
        [manager.securityPolicy setValidatesDomainName:NO];
    }
    return manager;
}
@end
