//
//  SVSetUserdItemsView.h
//  SAVI
//
//  Created by 杨忠平 on 2019/11/13.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVSetUserdItemsView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (nonatomic,strong) NSMutableArray *dataArray;

@property (nonatomic, copy)void(^sureBlock)();
@property (nonatomic, copy)void(^removeDataArrayBlock)();
@end

NS_ASSUME_NONNULL_END
