//
//  SVDateSelectionXib.h
//  SAVI
//
//  Created by Sorgle on 2017/8/22.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVDateSelectionXib : UIView

//显示日期的laber
@property (weak, nonatomic) IBOutlet UILabel *oneDaylbl;
@property (weak, nonatomic) IBOutlet UILabel *twoDaylbl;

//添加事件的View
@property (weak, nonatomic) IBOutlet UIView *oneViewButton;
@property (weak, nonatomic) IBOutlet UIView *twoViewButton;

@property (weak, nonatomic) IBOutlet UIButton *button;

@end
