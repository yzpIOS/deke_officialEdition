//
//  SVMoreColorVC.h
//  SAVI
//
//  Created by houming Wang on 2019/3/19.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol colorArrayClickDelegate<NSObject>
- (void)colorArrayClick:(NSMutableArray *)array;
@end

@interface SVMoreColorVC : UIViewController
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *firstColorArray;
//@property (nonatomic,copy) void(^colorArrayBlock)(NSMutableArray *array);
@property (nonatomic, weak) id<colorArrayClickDelegate> delegate;
/**
 标记是编辑过来的  1是编辑过来的
 */
@property (nonatomic,assign) NSInteger editInterface;

@end

NS_ASSUME_NONNULL_END
