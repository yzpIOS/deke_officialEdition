//
//  SVSinglePieceView.h
//  SAVI
//
//  Created by Sorgle on 2017/6/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSinglePieceView : UIView

//商品名
@property (weak, nonatomic) IBOutlet UILabel *waresName;
//件数
@property (weak, nonatomic) IBOutlet UITextField *number;

//备注
@property (weak, nonatomic) IBOutlet UITextField *note;

//退货原因
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;


@property (weak, nonatomic) IBOutlet UIButton *exitButton;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;


@end
