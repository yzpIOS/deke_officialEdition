//
//  SVcustomModel.m
//  SAVI
//
//  Created by houming Wang on 2018/9/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVcustomModel.h"

@implementation SVcustomModel
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
