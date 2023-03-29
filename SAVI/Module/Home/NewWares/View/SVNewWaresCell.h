//
//  SVNewWaresCell.h
//  SAVI
//
//  Created by Sorgle on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVNewWaresCell : UITableViewCell
//款号
@property (weak, nonatomic) IBOutlet UITextField *barcode;
//商品名字
@property (weak, nonatomic) IBOutlet UITextField *waresName;
//选择分类按钮
@property (weak, nonatomic) IBOutlet UILabel *waresClassLabel;
@property (weak, nonatomic) IBOutlet UIView *waresClassView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

//扫一扫按钮
@property (weak, nonatomic) IBOutlet UIButton *scanButton;



@end
