//
//  SVCustormPaymentModel.m
//  SAVI
//
//  Created by houming Wang on 2018/11/1.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVCustormPaymentModel.h"

@implementation SVCustormPaymentModel

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
    
    if (oldValue == [NSNull null]) {
        
        if ([oldValue isKindOfClass:[NSArray class]]) {
            
            return  @[];
            
        }else if([oldValue isKindOfClass:[NSDictionary class]]){
            
            return @{};
            
        }else{
            
            return @"";
            
        }
        
    }
    
    return oldValue;
    
}

@end
