//
//  SVEjectPriceView.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/23.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVEjectPriceView : UIView
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic, copy)void(^dictBlock)(NSDictionary *dict);


@end

NS_ASSUME_NONNULL_END
