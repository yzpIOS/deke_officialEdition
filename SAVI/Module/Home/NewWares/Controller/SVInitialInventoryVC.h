//
//  SVInitialInventoryVC.h
//  SAVI
//
//  Created by houming Wang on 2019/3/29.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVInitialInventoryVC : UIViewController
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *sizeArray;
/**
 标记是编辑过来的  1是编辑过来的
 */
@property (nonatomic,assign) NSInteger editInterface;
@property (nonatomic,strong) NSMutableArray *numberArray;
@property (nonatomic,strong) NSMutableArray *specsDiffArray;
@property (nonatomic,copy) void (^stockBlock)(NSMutableArray *array);
@property (nonatomic,strong) NSMutableArray *arraydataResult2;
@end

NS_ASSUME_NONNULL_END
