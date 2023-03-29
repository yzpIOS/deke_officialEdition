//
//  SVNavMemberView.h
//  SAVI
//
//  Created by 杨忠平 on 2020/3/4.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVNavMemberView : UIView
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property(nonatomic, assign) CGSize intrinsicContentSize;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

NS_ASSUME_NONNULL_END
