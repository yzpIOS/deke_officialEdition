//
//  SVCheckFooterButton.h
//  SAVI
//
//  Created by Sorgle on 2017/10/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVCheckFooterButton : UIView

//盘点总数
@property (weak, nonatomic) IBOutlet UILabel *sumLabel;
//盘点按钮
@property (weak, nonatomic) IBOutlet UIButton *inventoryButton;

@end
