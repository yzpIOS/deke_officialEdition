//
//  SVStoreTopView.h
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVStoreTopView : UIView
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UIView *chongzhiView;
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *money;


@property (weak, nonatomic) IBOutlet UILabel *storeName;
@property (weak, nonatomic) IBOutlet UILabel *storeTotleMoney;
@property (weak, nonatomic) IBOutlet UILabel *storeNum;
@property (weak, nonatomic) IBOutlet UILabel *storeGite;

@end

NS_ASSUME_NONNULL_END
