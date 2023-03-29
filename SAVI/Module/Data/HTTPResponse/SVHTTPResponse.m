//
//  SVHTTPResponse.m
//  SAVI
//
//  Created by 杨忠平 on 2022/11/22.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVHTTPResponse.h"

@implementation SVHTTPResponse
+ (id)responseWithObject:(id)aObject
{
    
    SVHTTPResponse *response = [SVHTTPResponse mj_objectWithKeyValues:aObject];
    
    return response;
}


+ (id)responseWithError:(NSError *)aError
{
    
    SVHTTPResponse *response = [[[self class] alloc] init];
    response.code = PSResponseStatusFailedCode;
    response.content = [aError localizedDescription];
    response.error = aError;
    
    
    
    return response;
}

@end
