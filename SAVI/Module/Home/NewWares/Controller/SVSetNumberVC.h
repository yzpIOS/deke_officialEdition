//
//  SVSetNumberVC.h
//  SAVI
//
//  Created by houming Wang on 2019/3/22.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVSetNumberVC : UIViewController
@property (nonatomic,strong) NSMutableArray *colorArray;
@property (nonatomic,strong) NSMutableArray *sizeArray;

@property (nonatomic,strong) NSMutableArray *numberArray;
@property (nonatomic,strong) NSString *borcodeStr;
@property (nonatomic,strong) NSMutableArray *specsDiffArray;

@property (nonatomic,strong) NSMutableArray *arraydataResult2;
/**
 标记是编辑过来的  1是编辑过来的
 */
@property (nonatomic,assign) NSInteger editInterface;
@property (nonatomic,copy) void(^textArrayBlock)(NSMutableArray *array);

@property (nonatomic,strong) NSMutableArray *ItemNumberArray;
@end

NS_ASSUME_NONNULL_END
