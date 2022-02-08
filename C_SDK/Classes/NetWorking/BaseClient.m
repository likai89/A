//
//  BaseClient.m
//  网络请求
//
//  Created by 李洞洞 on 10/4/17.
//  Copyright © 2017年 Minte. All rights reserved.
//

#import "BaseClient.h"

@implementation BaseClient

+ (instancetype)shareClient
{
    static BaseClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //Clicent对象被创建时 属性Manager应该被创建 并初始化 否则manager为空 无法进行网络请求
        client = [[self alloc]initWithBaseURL:Main_Url];
    });
    return client;
}
#pragma mark -- 自定义构造方法
- (instancetype)initWithBaseURL:(NSString *)baseUrl
{
    if (self = [super init]) {
        _baseURL = baseUrl;
        _manager = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFJSONRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.responseSerializer.acceptableContentTypes = [[NSSet alloc]initWithObjects:@"text/html",@"application/json",@"application/xml",@"text/plain",@"text/javascript", nil];
        //manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
        
        [_manager.requestSerializer setHTTPShouldHandleCookies:NO];
        //允许非权威机构颁发的证书
        _manager.securityPolicy.allowInvalidCertificates = YES;
        //不验证域名一致性
        _manager.securityPolicy.validatesDomainName = NO;
        
//        [self setFeildHandleToken];
    }
    return self;
}
- (void)setFeildHandleToken
{
//    [_manager.requestSerializer setValue:[TFUserTool getUser].token forHTTPHeaderField:@"Access-Token"];
//    [_manager.requestSerializer setValue:[TFUserTool getUser].token forHTTPHeaderField:@"X-CSRFToken"];
    LDLog(@"--%@--",[TFUserTool getUser].token);
    //🐎勒个壁
    if([TFUserTool getUser].token.length){
//        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@",[TFUserTool getUser].token] forHTTPHeaderField:@"Authorization"];
        ///强总 正式服的token
//        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@",@"169d4844de6f0868c4ca5db2f8de7b7e82a6fe24"] forHTTPHeaderField:@"Authorization"];
        ///测试服token  f246a0fb1df15476654c472ad76ac4cb4c516bd6
//        [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@",@"f246a0fb1df15476654c472ad76ac4cb4c516bd6"] forHTTPHeaderField:@"Authorization"];
    }
    [_manager.requestSerializer setValue:[NSString stringWithFormat:@"Token %@",@"f246a0fb1df15476654c472ad76ac4cb4c516bd6"] forHTTPHeaderField:@"Authorization"];
}
- (void)cleanToken
{
    [_manager.requestSerializer setValue:nil forHTTPHeaderField:@"Authorization"];
    LDLog(@"退出登录清除token%@",_manager.requestSerializer.HTTPRequestHeaders);
}
#pragma mark -- 公共的请求方法

+ (NSURL *)httpType:(BASE_TYPE)type andURL:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucBlock andFailBlock:(httpFailBlock)failBlock
{
   
    if (![url isEqualToString:Post_Wechat_Authorization_Api] || ![url isEqualToString:Post_users_user_register_Api] || ![url isEqualToString:Post_users_user_get_SMS_Api] || ![url isEqualToString:Get_Media_Config_Api] ) {
        [[BaseClient shareClient] setFeildHandleToken];
    }
    if ([url isEqualToString:Get_Media_Config_Api]) {
        [[BaseClient shareClient] cleanToken];
    }
   // NSLog(@"+++%@+++",[[BaseClient shareClient].manager.requestSerializer HTTPRequestHeaders]);
    
    if ([ISNull isNilOfSender:url]) {
        //url为空
#if 1
        //测试代码 上线就注销
        NSError * error = [[NSError alloc]initWithDomain:@"url为空" code:9999 userInfo:nil];
        NSLog(@"请求地址为空");
        failBlock(nil,error);
#endif
        return nil;
    }
    if ([self netIsReachability]) {
        //有网 判断请求的类型 调用不同的方法
        if (type == GET) {
            return [self requestGETWithURL:url andParam:param andSuccessBlock:sucBlock andFailBlock:failBlock];
        }else if (type == POST){
            return [self requestPOSTWithURL:url andParam:param andSuccessBlock:sucBlock andFailBlock:failBlock];
        }else if (type == PUT){
            return [self requestPUTWithURL:url andParam:param andSuccessBlock:sucBlock andFailBlock:failBlock];
        }else{
            return [self requestDELETEWithURL:url andParam:param andSuccessBlock:sucBlock andFailBlock:failBlock];
        }
    }else{
        NSLog(@"当前无网");
        [MBProgressHUD showError:@"当前无网络连接"];
        return nil;
    }
    return nil;
}
#pragma mark -- 检查当前的网络状态
+ (BOOL)netIsReachability
{
    //yes有网络 no 无网络
    return [[Reachability reachabilityForInternetConnection]isReachable];
}
#pragma mark -- GET方法的封装
+ (NSURL *)requestGETWithURL:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucBlock andFailBlock:(httpFailBlock)failBlock
{
    BaseClient * client = [BaseClient shareClient];
    NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL,url];
    signUrl = [signUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * returnUrl = [NSURL URLWithString:signUrl];
    //进行网络请求
    [client.manager GET:signUrl parameters:param headers:@{} progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                           //此处的responseObject是id类型啊?
        NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        //NSLog(@"接口返回数据(可直接在json格式化工具中查看) -- %@",str);
        //这为什么要回主线程执行呢?
        dispatch_async(dispatch_get_main_queue(), ^{
            if (responseObject == nil) {
                NSError * error = [[NSError alloc]initWithDomain:@"网络请求数据为空" code:999 userInfo:nil];
                failBlock(returnUrl,error);
            }else{
                id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if (object == nil) {//暂时判定这种情况是xml字符串
                    sucBlock(returnUrl,str);
                }else{
                    if ([object[@"code"] intValue] == 402) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:VipExpire402Noti object:nil];
                    }else{
                        sucBlock(returnUrl,object);//其他情况就是json
                    }
                }
            }
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                 LDLog(@"账号在异地登录了 你被踢下线了.....");
                 [[NSNotificationCenter defaultCenter] postNotificationName:AccountReloginNoti object:nil];
             }
             failBlock(returnUrl,error);
         });
    }];
    //block有迟延 调用方法时 立刻拿到接口
    return returnUrl;
}

#pragma mark --POST 方法的封装

+ (NSURL *)requestPOSTWithURL:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucBlock andFailBlock:(httpFailBlock)failBlock
{
    
    BaseClient * client = [BaseClient shareClient];
    NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL,url];
    if ([url containsString:@"https://sandbox.itunes.apple.com/verifyReceipt"]) {
        signUrl = url;
    }else{
        signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL,url];
    }
//    NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL,url];
    
    signUrl = [signUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSURL * retureUrl = [NSURL URLWithString:signUrl];
    
   [client.manager POST:signUrl parameters:param headers:@{} progress:^(NSProgress * _Nonnull uploadProgress) {
       
   } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       
       NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
       
       LDLog(@"接口返回数据(可直接在json格式化工具中查看)*************%@",str);
       dispatch_async(dispatch_get_main_queue(), ^{
       
       if (responseObject == nil) {
           
           NSError * error = [[NSError alloc]initWithDomain:@"返回数据为空" code:9999 userInfo:nil];
           
           failBlock(retureUrl,error);
           
           
       }else
       {
           id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
           if ([object[@"code"] intValue] == 402) {
               [[NSNotificationCenter defaultCenter] postNotificationName:VipExpire402Noti object:nil];
           }else{
               sucBlock(retureUrl,object);
           }
       }
           
       });
   } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       dispatch_async(dispatch_get_main_queue(), ^{
           if ([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
               LDLog(@"账号在异地登录了 你被踢下线了.....");
               [[NSNotificationCenter defaultCenter] postNotificationName:AccountReloginNoti object:nil];
           }
           failBlock(retureUrl,error);
       });
       
   }];
    
    return retureUrl;
}

#pragma mark -- PUT 方法的封装

+ (NSURL *)requestPUTWithURL:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucBlock andFailBlock:(httpFailBlock)failBlock
{
    BaseClient * client = [BaseClient shareClient];
    NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL,url];
    signUrl = [signUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * returnURL = [NSURL URLWithString:signUrl];
    
    [client.manager PUT:signUrl parameters:param headers:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
        
        if (responseObject == nil) {
            NSError * error = [[NSError alloc]initWithDomain:@"请求数据为空" code:9999 userInfo:nil];
            failBlock(returnURL,error);
        }else
        {
            id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([object[@"code"] intValue] == 402) {
                [[NSNotificationCenter defaultCenter] postNotificationName:VipExpire402Noti object:nil];
            }else{
                NSString * str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                LDLog(@"接口返回数据(可直接在json格式化工具中查看)*************%@",str);
                sucBlock(returnURL,object);
            }
        }
        });
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                LDLog(@"账号在异地登录了 你被踢下线了.....");
                [[NSNotificationCenter defaultCenter] postNotificationName:AccountReloginNoti object:nil];
            }
            failBlock(returnURL,error);
        });
        
    }];
    return returnURL;
}
+ (NSURL *)requestDELETEWithURL:(NSString *)url andParam:(NSDictionary *)param andSuccessBlock:(httpSuccessBlock)sucBlock andFailBlock:(httpFailBlock)failBlock
{
    BaseClient * client = [BaseClient shareClient];
    NSString * signUrl = [NSString stringWithFormat:@"%@%@",client.baseURL,url];
    signUrl = [signUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL * returnURL = [NSURL URLWithString:signUrl];
    
    [client.manager DELETE:signUrl parameters:param headers:@{} success:^(NSURLSessionDataTask *task, id responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
        
        if (responseObject == nil) {
            NSError * error = [[NSError alloc]initWithDomain:@"请求数据为空" code:9999 userInfo:nil];
            failBlock(returnURL,error);
        }else
        {
            id object = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([object[@"code"] intValue] == 402) {
                [[NSNotificationCenter defaultCenter] postNotificationName:VipExpire402Noti object:nil];
            }else{
                sucBlock(returnURL,object);
            }
          }
        });
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([error.localizedDescription isEqualToString:@"Request failed: unauthorized (401)"]) {
                LDLog(@"账号在异地登录了 你被踢下线了.....");
                [[NSNotificationCenter defaultCenter] postNotificationName:AccountReloginNoti object:nil];
            }
            failBlock(returnURL,error);
        });
    }];
    return returnURL;
}
#pragma mark - 取消请求
+ (void)cancelHttpRequestOperation
{
    BaseClient * client = [BaseClient shareClient];
    [client.manager.operationQueue cancelAllOperations];
    //取消manager队列中所有的任务
}




@end































