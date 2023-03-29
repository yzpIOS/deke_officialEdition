//
//  AJTicker.h
//  AiJiaNew
//
//  Created by Sujiansong on 16/11/24.
//  Copyright © 2016年 aj1g.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AJTicker : NSObject

+ (instancetype)defaultTicker;

- (void)reset;

- (void)startTickerWithButton:(UIButton *)button;

- (BOOL)isTicking;
@property (nonatomic,strong) NSString *kGetAuthCodeMaxTimeInterval;

@property (nonatomic,copy) void (^timeBlock)();
@end
