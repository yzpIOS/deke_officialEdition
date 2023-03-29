//
//  SVSaviTool.m
//  SAVI
//
//  Created by Sorgle on 17/4/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSaviTool.h"

//#define HOST @"http://120.24.234.146:81"

@implementation SVSaviTool

+(instancetype)sharedSaviTool{
    static SVSaviTool *manager = nil;
    static dispatch_once_t Token;
    dispatch_once(&Token, ^{
        manager = [[self alloc] init];
        //申明请求的数据是json类型(requestSerializer/请求序列化器）
//       AFJSONResponseSerializer* jsonResponeSerializer = [AFJSONResponseSerializer serializer];
//        jsonResponeSerializer.removesKeysWithNullValues = YES;
//        manager.responseSerializer = jsonResponeSerializer;
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        //请求超时设定
        manager.requestSerializer.timeoutInterval = 30.0f;
        //responseSerializer/响应序列化器
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/javascript",@"text/json",@"text/html", nil];
        // ((AFJSONResponseSerializer *)manager.responseSerializer).removesKeysWithNullValues = YES;
       // AFHTTPResponseSerializer.removesKeysWithNullValues = YES;
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        //manager = [[AFHTTPSessionManager alloc]initWithBaseURL:url sessionConfiguration:config];
       
   
    });
    return manager;
}

//GET请求
+(void)GET:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//POST请求
+(void)POST:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
    }];
    
}
+ (void)PUT:(NSString *)urlStr parameters:(id)parameters success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    
    [[SVSaviTool sharedSaviTool] PUT:urlStr parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            
            failure(error);
        }
        
    }];
}
-(void)AFNetworkStatus{
    //创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    /*枚举里面四个状态  分别对应 未知 无网络 数据 WiFi
     typedef NS_ENUM(NSInteger, AFNetworkReachabilityStatus) {
     AFNetworkReachabilityStatusUnknown          = -1,      未知
     AFNetworkReachabilityStatusNotReachable     = 0,       无网络
     AFNetworkReachabilityStatusReachableViaWWAN = 1,       蜂窝数据网络
     AFNetworkReachabilityStatusReachableViaWiFi = 2,       WiFi
     };
     */
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //这里是监测到网络改变的block 可以写成switch方便
        //在里面可以随便写事件
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                //未知网络状态
                break;
            case AFNetworkReachabilityStatusNotReachable:
                
//                [SVProgressHUD showErrorWithStatus:@"无网络"];
//                //用延迟来移除提示框
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [SVProgressHUD dismiss];
//                });
//                [SVTool TextButtonAction:self.view withSing:@"没网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                
//                [SVProgressHUD showInfoWithStatus:@"当前为非WiFi网络"];
//                //用延迟来移除提示框
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [SVProgressHUD dismiss];
//                });
//                [SVTool TextButtonAction:self.view withSing:@"当前为非wifi网络"];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                
//                [SVProgressHUD showInfoWithStatus:@"当前WiFi网络"];
//                //用延迟来移除提示框
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    [SVProgressHUD dismiss];
//                });
//                [SVTool TextButtonAction:self.view withSing:@"当前wifi网络"];
                break;
                
            default:
                break;
        }
    }];
}

@end
