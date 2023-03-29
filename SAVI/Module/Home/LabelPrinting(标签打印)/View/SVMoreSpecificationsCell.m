//
//  SVMoreSpecificationsCell.m
//  SAVI
//
//  Created by houming Wang on 2019/4/13.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVMoreSpecificationsCell.h"
#import "SVWaresListModel.h"

@interface SVMoreSpecificationsCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *spectL;
@property (weak, nonatomic) IBOutlet UILabel *itemNum;
@property (weak, nonatomic) IBOutlet UITextField *stockText;
@property (weak, nonatomic) IBOutlet UIButton *cellButton;


@end

@implementation SVMoreSpecificationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.stockText.delegate = self;
}
- (void)setModel:(SVWaresListModel *)model{
    _model = model;
    [self updateCell];
}

- (void)updateCell{
    [self.cellButton setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
    [self.cellButton setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
    
    if ([self.model.isSelect isEqualToString:@"1"]) {
        self.cellButton.selected = YES;
    }
    else{
        self.cellButton.selected = NO;
    }
    
    if ([_model.sv_p_specs containsString:@"\n"]) {
       // _model.sv_p_specs
        NSString *sv_p_specsStr = [_model.sv_p_specs stringByReplacingOccurrencesOfString:@"\n" withString:@""]; //
        self.spectL.text = sv_p_specsStr;
    }else{
        self.spectL.text = _model.sv_p_specs;
    }
   
    self.itemNum.text = _model.sv_p_storage;
    self.stockText.text = _model.sv_p_storage;
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    [self updateCell];
    
}

- (IBAction)addClick:(UIButton *)sender {
    NSInteger count = [_model.sv_p_storage integerValue];
    count += 1;
    _model.sv_p_storage = [NSString stringWithFormat:@"%ld",count];
    if (self.model_block) {
        self.model_block(self.model, self.index);
    }
    
    [self updateCell];
   
}


- (IBAction)reduceClick:(UIButton *)sender {
    NSInteger count = [_model.sv_p_storage integerValue];
    if (count == 0) {
        return;
    }
    count -= 1;
    _model.sv_p_storage = [NSString stringWithFormat:@"%ld",count];
    if (self.model_block) {
        self.model_block(self.model, self.index);
    }
      [self updateCell];
   
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
   
    _model.sv_p_storage = textField.text;
    if (self.model_block) {
        self.model_block(self.model, self.index);
    }
    
    
     [self updateCell];
    
}
- (IBAction)selectClick:(id)sender {
    if ([self.model.isSelect isEqualToString:@"1"]) {
        self.model.isSelect = @"0";
    }
    else{
        self.model.isSelect = @"1";
    }
    
    if (self.model_block) {
        self.model_block(self.model, self.index);
    }
    
    [self updateCell];
}

@end
