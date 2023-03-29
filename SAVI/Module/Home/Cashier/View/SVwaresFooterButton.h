//
//  SVwaresFooterButton.h
//  SAVI
//
//  Created by Sorgle on 17/5/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVwaresFooterButton : UIView

@property (nonatomic, assign) NSInteger sumCount;

@property (nonatomic, assign) double money;

@property (weak, nonatomic) IBOutlet UIView *waresView;
//件数
@property (weak, nonatomic) IBOutlet UILabel *sumCountlbl;
//总价
@property (weak, nonatomic) IBOutlet UILabel *moneylbl;
@property (weak, nonatomic) IBOutlet UILabel *symbollbl;

//挂单
@property (weak, nonatomic) IBOutlet UIButton *orderButton;
//结算
@property (weak, nonatomic) IBOutlet UIButton *settlementButton;


@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end
