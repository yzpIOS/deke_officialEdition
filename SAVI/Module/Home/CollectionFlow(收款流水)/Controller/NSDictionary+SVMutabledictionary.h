//
//  NSDictionary+SVMutabledictionary.h
//  SAVI
//
//  Created by 杨忠平 on 2020/5/26.
//  Copyright © 2020 Sorgle. All rights reserved.
//

//#import <AppKit/AppKit.h>


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (SVMutabledictionary)
-(NSMutableDictionary *)mutableDicDeepCopy;
@end

NS_ASSUME_NONNULL_END
