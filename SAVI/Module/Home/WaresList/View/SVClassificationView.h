//
//  SVClassificationView.h
//  SAVI
//
//  Created by houming Wang on 2021/1/20.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVClassificationView : UIView
@property (nonatomic,copy) void (^confirmBlock)(NSMutableArray *oneSelectModelArray,NSMutableArray *twoSelectModelArray);

@property (nonatomic, strong) NSMutableArray *bigNameArr;
@property (nonatomic, strong) NSMutableArray *bigIDArr;
@property (nonatomic,strong) NSMutableArray * categaryArray;
@property (weak, nonatomic) IBOutlet UIButton *ClassifiedManagement;
@end

NS_ASSUME_NONNULL_END
