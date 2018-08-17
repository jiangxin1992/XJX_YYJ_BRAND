//
//  YYSellerInfoCell.m
//  yunejianDesigner
//
//  Created by Apple on 16/6/30.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYSellerInfoCell.h"

#import "YYUser.h"

@interface YYSellerInfoCell()

@end
@implementation YYSellerInfoCell

- (IBAction)switchClicked:(id)sender{
    YYUser *user = [YYUser currentUser];
    UISwitch *tempSwitch = (UISwitch *)sender;
    BOOL isOn = tempSwitch.isOn;
    if (_switchClicked) {
        if(user.userType == YYUserTypeShowroom)
        {
            _switchClicked(_subModel.showroomUserId,isOn);
        }else if(user.userType == YYUserTypeDesigner)
        {
            _switchClicked(@(_seller.salesmanId),isOn);
        }
    }
}

- (void)setLabelStatus:(float)alpha{
    if(alpha >= 1){
        self.keyLabel.textColor = [UIColor colorWithHex:@"000000"];
        self.valueLabel.textColor = [UIColor colorWithHex:@"000000"];
    }else{
        self.keyLabel.textColor = [UIColor colorWithHex:@"919191"];
        self.valueLabel.textColor = [UIColor colorWithHex:@"919191"];
    }
   // self.keyLabel.alpha = alpha;
   // self.valueLabel.alpha = alpha;
}

- (void)updateUIWithShowType:(NSInteger )showType{
    
    
    [self setTranslatesAutoresizingMaskIntoConstraints:YES];

//    _statusSwitch.transform = CGAffineTransformMakeScale(1, 1);
    
    YYUser *user = [YYUser currentUser];
    if(user.userType == YYUserTypeShowroom)
    {
        if (!_subModel) {
            return;
        }
        
        self.currentShowType = showType;
        
        _keyLabel.text = _subModel.manager;
        _valueLabel.text = _subModel.email;
    }else
    {
        if (!_seller) {
            return;
        }
        self.currentShowType = showType;
        
        _keyLabel.text = _seller.name;
        _valueLabel.text = _seller.email;
    }

}
#pragma mark - Other
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
