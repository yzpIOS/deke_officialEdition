//
//  NSObject+Model.h
//  SAVI
//
//  Created by luhoun on 16/7/5.
//  Copyright © 2016年 Hanymore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)

+(instancetype)modelWithDict:(NSDictionary *)dict;

+(NSDictionary*)dictionaryWithObject:(id)obj;

+(NSMutableArray*)arrayWithObject:(NSArray*)arrs;

@end
