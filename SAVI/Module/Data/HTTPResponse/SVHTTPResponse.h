//
//  SVHTTPResponse.h
//  SAVI
//
//  Created by 杨忠平 on 2022/11/22.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVHTTPResponse : NSObject
//@property (nonatomic, copy) NSString *code;
@property (nonatomic,assign) NSInteger code;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, strong) id data;
@property (nonatomic, strong) NSString* msg;
@property (nonatomic, copy) NSError *error;

+ (id)responseWithObject:(id)aObject;
+ (id)responseWithError:(NSError *)aError;
@end

NS_ASSUME_NONNULL_END
