//
//  SVModuleModel.m
//  SAVI
//
//  Created by houming Wang on 2019/4/3.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVModuleModel.h"

@implementation SVModuleModel
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
