//
//  SVSaviTool.h
//  SAVI
//
//  Created by Sorgle on 17/4/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface SVSaviTool : AFHTTPSessionManager

+(instancetype)sharedSaviTool;

//CET请求
+(void)GET:(NSString *)urlStr parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//POST请求
+(void)POST:(NSString *)urlStr parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//PUT请求
+(void)PUT:(NSString *)urlStr parameters:(id)parameters success:(void(^)(id responseObject))success failure:(void(^)(NSError *error))failure;

//网络监听
-(void)AFNetworkStatus;

@end
