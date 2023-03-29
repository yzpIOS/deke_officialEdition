//
//  SVWebViewVC.h
//  SAVI
//
//  Created by houming Wang on 2018/6/21.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVWebViewVC : SVBaseVC

@property (nonatomic,copy) NSString *url;

/**
 * 是否允许转向
 */
@property(nonatomic,assign) BOOL turn;

@end
