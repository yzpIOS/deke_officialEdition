//
//  SVProductScreeningView.h
//  SAVI
//
//  Created by houming Wang on 2020/12/21.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVProductScreeningView : UIView
@property (nonatomic,strong) NSString * storeId;

// 请求所需要的参数
@property (nonatomic,assign) NSInteger dengji;
@property (nonatomic,assign) NSInteger fenzhu;
@end

NS_ASSUME_NONNULL_END
