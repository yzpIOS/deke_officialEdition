//
//  SVBulletFrameView.h
//  SAVI
//
//  Created by houming Wang on 2021/5/8.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVBulletFrameView : UIView
@property (weak, nonatomic) IBOutlet UIButton *stopBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *cleanBtn;

@end

NS_ASSUME_NONNULL_END
