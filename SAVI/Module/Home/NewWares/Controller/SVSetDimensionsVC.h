//
//  SVSetDimensionsVC.h
//  SAVI
//
//  Created by houming Wang on 2019/3/21.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVColorOneModel;
@class SVSizeTwoModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVSetDimensionsVC : UIViewController
@property (nonatomic,copy) void (^selectArrayBlock)(NSMutableArray *array,NSInteger selectIndex,SVColorOneModel*oneModel,SVSizeTwoModel *twoModel,NSString *spec_name);
//@property (nonatomic,strong) UIButton *selectBtn;
@property (nonatomic,assign) NSInteger selectIndex;
@property (nonatomic,strong) NSMutableArray *selectColorArray;
@property (nonatomic,strong) NSMutableArray *selectBtnArray;
@property (nonatomic,strong) NSMutableArray *sizeTwoArray;
@property (nonatomic,strong) NSMutableArray *firstSizeArray;
@property (nonatomic,strong) NSString *attri_group;
/**
 标记是编辑过来的  1是编辑过来的
 */
@property (nonatomic,assign) NSInteger editInterface;
@end

NS_ASSUME_NONNULL_END
