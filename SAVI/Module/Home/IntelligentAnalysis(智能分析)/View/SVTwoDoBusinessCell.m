//
//  SVTwoDoBusinessCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/30.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVTwoDoBusinessCell.h"
#import "SVStoreLineView.h"
#import "SVShopOverviewModel.h"
#import "SVShopReportModel.h"
#import "SVStoreCategaryModel.h"
#import "SVErectLineView.h"

@interface SVTwoDoBusinessCell()
@property (weak, nonatomic) IBOutlet UIView *fatherView;
@property (weak, nonatomic) IBOutlet UILabel *textName;

@end
@implementation SVTwoDoBusinessCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
 

}

#pragma mark - 竖立放
- (void)setMemberAnalysisArray:(NSMutableArray *)memberAnalysisArray
{
    _memberAnalysisArray = memberAnalysisArray;
     self.textName.text = @"新增会员统计";
    CGFloat maxX = 0;
    //    if (self.fatherView.subviews.count > 0) {
    //        [self.fatherView removeFromSuperview];
    //    }
    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.memberAnalysisArray.count ; i++) {
        NSDictionary *dict = self.memberAnalysisArray[i];
        if ([dict[@"addnum"] floatValue] == 0) {//数据为0时
            
        }else{
              SVErectLineView *rankingsV = [[SVErectLineView alloc]initWithFrame:CGRectMake(maxX, 0, 40, self.fatherView.height)];
            rankingsV.namelabel.text = dict[@"adddate"];
            rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",[dict[@"addnum"]floatValue]];
            if (self.order_receivable != 0) {
                float twoWide = 210 * [dict[@"addnum"] floatValue] / self.order_receivable;
                
                
                rankingsV.namelabel.frame = CGRectMake(0, self.fatherView.height - 30, 30, 30);
                
              
                rankingsV.colorView.frame = CGRectMake(0, self.fatherView.height - 30, 15, 0);
                
                [UIView animateWithDuration:1 animations:^{
                    rankingsV.colorView.height = -twoWide;
                }];
//                rankingsV.colorView.width = 15;
                rankingsV.moneylabel.frame = CGRectMake(0, self.fatherView.height - 30 -twoWide, 30, -30);
               // rankingsV.moneylabel.centerX = rankingsV.colorView.centerX;
                
                
                //  maxY = maxY;
                maxX = CGRectGetMaxX(rankingsV.frame);
                [self.fatherView addSubview:rankingsV];
            }
        }
    }
}



- (void)setDataList:(NSMutableArray *)dataList
{
    self.textName.text = @"门店营业统计";
    _dataList = dataList;
    CGFloat maxY = 0;
//    if (self.fatherView.subviews.count > 0) {
//        [self.fatherView removeFromSuperview];
//    }
    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.dataList.count ; i++) {
      
        SVShopOverviewModel *model = self.dataList[i];

        if ([model.order_receivable floatValue] == 0) {//数据为0时

        }else{

            SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
            rankingsV.namelabel.text = model.sv_us_name;
            rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",model.order_receivable.floatValue];
            if (self.order_receivable != 0) {
                 float twoWide = 210 * [model.order_receivable floatValue] / self.order_receivable;
                
                [UIView animateWithDuration:1 animations:^{
                    rankingsV.colorView.width = twoWide;
                }];
                rankingsV.colorView.height = 15;
                rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                //  maxY = maxY;
                maxY = CGRectGetMaxY(rankingsV.frame);
                [self.fatherView addSubview:rankingsV];
            }
        }
    }
    
}

- (void)setFatherDataList:(NSMutableArray *)FatherDataList
{
    _FatherDataList = FatherDataList;
    CGFloat maxY = 0;
    self.textName.text = @"会员充值排行";
    //    if (self.fatherView.subviews.count > 0) {
    //        [self.fatherView removeFromSuperview];
    //    }
    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.FatherDataList.count ; i++) {
        
        SVShopOverviewModel *model = self.FatherDataList[i];
  
        if ([model.order_receivable floatValue] == 0) {//数据为0时
     
        }else{

             SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
         //   rankingsV.tag = i+1;
            
            rankingsV.namelabel.text = model.sv_mr_name;
            rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",model.order_receivable.floatValue];
            
            if (self.order_receivable != 0) {
                float twoWide = 210 * [model.order_receivable floatValue] / self.order_receivable;
                
                [UIView animateWithDuration:1 animations:^{
                    rankingsV.colorView.width = twoWide;
                }];
                rankingsV.colorView.height = 15;
                rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                //  maxY = maxY;
                maxY = CGRectGetMaxY(rankingsV.frame);
                [self.fatherView addSubview:rankingsV];
            }
        }
        
        
        
    }
}

- (void)setChongzhiList:(NSMutableArray *)chongzhiList
{
    _chongzhiList = chongzhiList;
    
    CGFloat maxY = 0;
    self.textName.text = @"会员充值排行";
    //    if (self.fatherView.subviews.count > 0) {
    //        [self.fatherView removeFromSuperview];
    //    }
    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.chongzhiList.count ; i++) {
        
        SVShopReportModel *model = self.chongzhiList[i];
        
        
        //        SVRankingsView *rankingsOneV = (SVRankingsView *)[V5 viewWithTag:1];
        if ([model.sv_mrr_money floatValue] == 0) {//数据为0时
            //改变frame
            //            rankingsV.colorView.backgroundColor = [UIColor whiteColor];
            //
            //             float twoWide = 180 * 800 / 800;
            ////            [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) {
            ////                make.size.with.mas_equalTo(0.5);
            //            [UIView animateWithDuration:1 animations:^{
            //                rankingsV.size = CGSizeMake(twoWide, 15);
            //            }];
            
        }else{
            
          //  maxY = 48*i + 1;
            
            //  [self.fatherView removeFromSuperview];
             SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
           // rankingsV.tag = i+1;
            
            rankingsV.namelabel.text = model.sv_mr_name;
            rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",model.sv_mrr_money.floatValue];
            
//            float twoWide = 210 * [model.sv_mrr_money floatValue] / self.order_receivable;
//            NSLog(@"twoWide = %f",twoWide);
//
//            [UIView animateWithDuration:1 animations:^{
//                rankingsV.colorView.width = twoWide;
//            }];
//            rankingsV.colorView.height = 15;
//            rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
//            rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
//            //  maxY = maxY;
//            maxY = CGRectGetMaxY(rankingsV.frame);
//            [self.fatherView addSubview:rankingsV];
            
            if (self.order_receivable != 0) {
                float twoWide = 210 * [model.sv_mrr_money floatValue] / self.order_receivable;
                
                [UIView animateWithDuration:1 animations:^{
                    rankingsV.colorView.width = twoWide;
                }];
                rankingsV.colorView.height = 15;
                rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                //  maxY = maxY;
                maxY = CGRectGetMaxY(rankingsV.frame);
                [self.fatherView addSubview:rankingsV];
            }
        }
        
        
        
    }
    
}

- (void)setShopArray:(NSMutableArray *)shopArray
{
    _shopArray = shopArray;
    
    self.textName.text = @"商品销售排行";
  //  _shopArray = shopArray;
    CGFloat maxY = 0;
    //    if (self.fatherView.subviews.count > 0) {
    //        [self.fatherView removeFromSuperview];
    //    }
    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.shopArray.count ; i++) {
        
        SVShopOverviewModel *model = self.shopArray[i];
        
        
        //        SVRankingsView *rankingsOneV = (SVRankingsView *)[V5 viewWithTag:1];
        if ([model.count floatValue] == 0) {//数据为0时
            //改变frame
            //            rankingsV.colorView.backgroundColor = [UIColor whiteColor];
            //
            //             float twoWide = 180 * 800 / 800;
            ////            [rankingsV.colorView mas_updateConstraints:^(MASConstraintMaker *make) {
            ////                make.size.with.mas_equalTo(0.5);
            //            [UIView animateWithDuration:1 animations:^{
            //                rankingsV.size = CGSizeMake(twoWide, 15);
            //            }];
            
        }else{
           // maxY = 48*i + 1;
            // maxY = 48*i + 1;
            
            //  [self.fatherView removeFromSuperview];
          SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
            rankingsV.namelabel.text = model.sv_mr_name;
            rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",[model.count floatValue]];
            
            float twoWide = 210 * [model.count floatValue] / self.order_receivable;
            
            [UIView animateWithDuration:1 animations:^{
                rankingsV.colorView.width = twoWide;
            }];
            rankingsV.colorView.height = 15;
            rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
            rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
            //  maxY = maxY;
            maxY = CGRectGetMaxY(rankingsV.frame);
            
            //  maxY = maxY;
            [self.fatherView addSubview:rankingsV];
        }
        
        
        
    }
}

- (void)setCatageryArray:(NSMutableArray *)catageryArray
{
    _catageryArray = catageryArray;
    self.textName.text = @"商品分类排行";
    //  _shopArray = shopArray;
    CGFloat maxY = 0;
    //    if (self.fatherView.subviews.count > 0) {
    //        [self.fatherView removeFromSuperview];
    //    }
    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.catageryArray.count ; i++) {
        
        SVStoreCategaryModel *model = self.catageryArray[i];
        
        
        //        SVRankingsView *rankingsOneV = (SVRankingsView *)[V5 viewWithTag:1];
        if ([model.category_num floatValue] == 0) {//数据为0时
    
        }else{
          //  maxY = 48*i + 1;
            // maxY = 48*i + 1;
            
            //  [self.fatherView removeFromSuperview];
             SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
            rankingsV.namelabel.text = model.sv_pc_name;
            rankingsV.moneylabel.text = [NSString stringWithFormat:@"%.2f",[model.category_num floatValue]];
            float twoWide = 210 * [model.category_num floatValue] / self.order_receivable;
         
            [UIView animateWithDuration:1 animations:^{
                rankingsV.colorView.width = twoWide;
            }];
            rankingsV.colorView.height = 15;
            
            rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
            rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
            //  maxY = maxY;
            maxY = CGRectGetMaxY(rankingsV.frame);
            
            //  maxY = maxY;
            [self.fatherView addSubview:rankingsV];
        }
        
        
        
    }
}


- (void)setMemberCountArray:(NSMutableArray *)memberCountArray
{
    _memberCountArray = memberCountArray;
    self.textName.text = @"各门店会员数";
    
    CGFloat maxY = 0;
    [self.fatherView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    for (int i = 0; i < self.memberCountArray.count ; i++) {
        
       NSDictionary *dict = self.memberCountArray[i];

        if ([dict[@"count"] floatValue] == 0) {//数据为0时
            
        }else{

            SVStoreLineView *rankingsV = [[SVStoreLineView alloc]initWithFrame:CGRectMake(8, maxY, ScreenW - 20, 48)];
            rankingsV.namelabel.text = dict[@"storename"];
            rankingsV.moneylabel.text = dict[@"ratiostring"];
            if (self.memberOrder_receivable != 0) {
                float twoWide = 180 * [dict[@"count"] floatValue] / self.memberOrder_receivable;
                NSLog(@"3333twoWide = %f",twoWide);
                [UIView animateWithDuration:1 animations:^{
                    rankingsV.colorView.width = twoWide;
                }];
                rankingsV.colorView.height = 15;
                
                rankingsV.moneylabel.frame = CGRectMake(CGRectGetMaxX(rankingsV.colorView.frame) + 10, 0, 100, 15);
                rankingsV.moneylabel.centerY = rankingsV.colorView.centerY;
                //  maxY = maxY;
                maxY = CGRectGetMaxY(rankingsV.frame);
                
                //  maxY = maxY;
                [self.fatherView addSubview:rankingsV];
            }
        }
        
        
        
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
