//
//  SVStoreLineView.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/30.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVStoreLineView : UIView
//支出类名
@property (nonatomic, strong) UILabel *namelabel;
//颜色view
@property (nonatomic, strong) UIView *colorView;
//金额
@property (nonatomic, strong) UILabel *moneylabel;
//排行数
@property (nonatomic, strong) UILabel *taglabel;

//底部内容
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic,assign) NSInteger state;

////NS_ENUM，定义状态等普通枚举
//typedef NS_ENUM(NSUInteger, TTGState) {
//    TTGStateOK = 0,
//    TTGStateError,
//    TTGStateUnknow
//};
@end

NS_ASSUME_NONNULL_END
