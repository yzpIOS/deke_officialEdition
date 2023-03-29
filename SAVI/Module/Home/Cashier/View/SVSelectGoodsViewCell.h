//
//  SVSelectGoodsViewCell.h
//  SAVI
//
//  Created by hashakey on 2017/5/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVSelectedGoodsModel.h"

@interface SVSelectGoodsViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon_addImage;

@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
//给cell标记
@property (nonatomic, strong) NSIndexPath *indexPatch;
//用模型赋值
@property (nonatomic, strong) SVSelectedGoodsModel *goodsModel;
//计算件数的block
@property (nonatomic, copy) void(^countChangeBlock)(SVSelectedGoodsModel * model,NSIndexPath *indexPatch);
//动图block
@property (nonatomic,copy)  void(^shopCartBlock)(UIImageView *imageView);
@property (weak, nonatomic) IBOutlet UIButton *addButton;

@property (weak, nonatomic) IBOutlet UILabel *countText;

@property (nonatomic, copy)void(^multiPriceBlock)(SVSelectedGoodsModel *model);

@property (weak, nonatomic) IBOutlet UIButton *addNumberBtn;


//@property (weak, nonatomic) IBOutlet UITextField *countText;
@end
