//
//  YYBrandModifyInfoViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBrandModifyInfoViewController.h"

#import "YYNavigationBarViewController.h"
#import "YYBrandModifyInfoCellViewController.h"

#import "YYBuyerModifyInfoHeadViewCell.h"
#import "YYBrandModifyInfoTxtViewCell.h"
#import "YYBrandModifyInfoContactViewCell.h"
#import "YYBrandModifyInfoSocialViewCell.h"
#import "YYBrandModifyInfoUploadViewCell.h"
#import "YYPickView.h"
#import "YYBrandModifyHeadView.h"

#import "UIImage+Tint.h"
#import "regular.h"
#import "YYUser.h"
#import "MBProgressHUD.h"
#import "YYOrderApi.h"
#import "YYBrandHomeUpdateModel.h"
#import "YYUserApi.h"
#import "YYBrandHomeInfoModel.h"

@interface YYBrandModifyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,YYTableCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,assign) NSInteger uploadImgType;
@property(nonatomic,strong) NSMutableArray *uploadImgs;

@end

@implementation YYBrandModifyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 进入埋点
    [MobClick beginLogPageView:kYYPageBrandModifyInfo];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 退出埋点
    [MobClick endLogPageView:kYYPageBrandModifyInfo];
}

#pragma mark - SomePrepare
-(void)SomePrepare
{
    [self PrepareData];
    [self PrepareUI];
}

-(void)PrepareData
{
    _uploadImgs = [[NSMutableArray alloc] init];
    NSInteger count =  [_homeInfoModel.indexPics count];
    [self resetCellNSArrayValue:count target:_homeInfoModel.indexPics];
    
    [YYUser saveNewsReadStateWithType:2];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateReadState" object:nil];
    if(_block){
        _block(@"readEdit");
    }
    
}
-(void)PrepareUI
{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    YYNavigationBarViewController *navigationBarViewController = [storyboard instantiateViewControllerWithIdentifier:@"YYNavigationBarViewController"];
    
    navigationBarViewController.previousTitle = @"";
    navigationBarViewController.nowTitle = NSLocalizedString(@"编辑主页信息",nil);
    
    [_containerView addSubview:navigationBarViewController.view];
    __weak UIView *_weakContainerView = _containerView;
    [navigationBarViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_weakContainerView.mas_top);
        make.left.equalTo(_weakContainerView.mas_left);
        make.bottom.equalTo(_weakContainerView.mas_bottom);
        make.right.equalTo(_weakContainerView.mas_right);
    }];
    WeakSelf(ws);
    
    __block YYNavigationBarViewController *blockVc = navigationBarViewController;
    
    [navigationBarViewController setNavigationButtonClicked:^(NavigationButtonType buttonType){
        if (buttonType == NavigationButtonTypeGoBack) {
            if (ws.cancelButtonClicked) {
                ws.cancelButtonClicked();
            }
            blockVc = nil;
        }
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    self.tableView.backgroundColor = _define_white_color;
}
-(NSArray *)resetCellNSArrayValue:(NSInteger )count target:(NSArray*)target{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<count; i++) {
        if(i<[target count]){
            [tmpArray addObject:[target objectAtIndex:i]];
            [_uploadImgs addObject:[target objectAtIndex:i]];
        }else{
            [tmpArray addObject:@""];
        }
    }
    return tmpArray;
}

#pragma mark - SomeAction

-(void)modifyCell:(NSInteger)viewType detailType:(NSString *)detailType value:(NSString *)value{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Brand" bundle:[NSBundle mainBundle]];
    YYBrandModifyInfoCellViewController *buyerModifyInfoCellController = [storyboard instantiateViewControllerWithIdentifier:@"YYBrandModifyInfoCellViewController"];
    buyerModifyInfoCellController.viewType = viewType;
    buyerModifyInfoCellController.detailType = detailType;
    buyerModifyInfoCellController.value = value;
    WeakSelf(ws);
    __block NSInteger blockviewType = viewType;
    [buyerModifyInfoCellController setCancelButtonClicked:^(){
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [buyerModifyInfoCellController setSaveButtonClicked:^(NSString *value){
        if(value){
            [ws updateHomeInfo:@[value] viewType:blockviewType];
        }
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:buyerModifyInfoCellController animated:YES];
}
-(NSDictionary *)getParamsMapWithModel:(YYBrandHomeUpdateModel *)model
{
    NSDictionary *tempParamsMap = [model toDictionary];
    NSArray *keyArr = [tempParamsMap allKeys];
    NSMutableDictionary *paramsMap = [[_homeInfoModel toDictionary] mutableCopy];
    if(keyArr.count)
    {
        NSString *key = keyArr[0];
        [paramsMap setObject:[tempParamsMap objectForKey:key] forKey:key];
    }
    NSArray *picArr = [paramsMap objectForKey:@"indexPics"];
    [paramsMap setObject:picArr forKey:@"pics"];
    [paramsMap removeObjectsForKeys:@[@"brandId",@"percent",@"indexPics"]];

    return [paramsMap copy];
}
-(void)updateHomeInfo:(NSArray *)paramsArr viewType:(NSInteger)viewType{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    YYBrandHomeUpdateModel *model = [YYBrandHomeUpdateModel createUploadCertModel:paramsArr];
    if([model.userSocialInfos count] > 0){
        YYBuyerSocialInfoModel *socialInfoModel = [model.userSocialInfos objectAtIndex:0];
        BOOL isContain = NO;
        NSMutableArray *userSocialInfos =  [self.homeInfoModel.userSocialInfos mutableCopy];
        for (YYBuyerSocialInfoModel *socialInfoModel1 in userSocialInfos) {
            if([socialInfoModel1.socialType integerValue] == [socialInfoModel.socialType integerValue]){
                socialInfoModel1.socialName = socialInfoModel.socialName;
                isContain = YES;
                break ;
            }
        }
        if(!isContain){
            [userSocialInfos addObject:socialInfoModel];
        }
        model.userSocialInfos = [userSocialInfos copy];
    }
    if([model.userContactInfos count] > 0){
        YYBuyerContactInfoModel * contactInfoModel = [model.userContactInfos objectAtIndex:0];
        BOOL isContain = NO;
        NSMutableArray *userContactInfos = [self.homeInfoModel.userContactInfos mutableCopy];
        for (YYBuyerContactInfoModel * contactInfoModel1 in userContactInfos) {
            if([contactInfoModel1.contactType integerValue] == [contactInfoModel.contactType integerValue]){
                contactInfoModel1.contactValue = contactInfoModel.contactValue;
                contactInfoModel1.auth = contactInfoModel.auth;
                isContain = YES;
                break ;
            }
        }
        if(!isContain){
            [userContactInfos addObject:contactInfoModel];
        }
        model.userContactInfos = [userContactInfos copy];
    }
    
    WeakSelf(ws);
    __block NSInteger blockviewType = viewType;
    __block YYBrandHomeUpdateModel *blockmodel = model;
    NSDictionary *paramsMap=[self getParamsMapWithModel:model];
    [YYUserApi updateBrandWithDataDict:paramsMap andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        [MBProgressHUD hideAllHUDsForView:ws.view animated:NO];
        if( rspStatusAndMessage.status == YYReqStatusCode100){
            //更新处理
            if(blockviewType == YYBrandModifyInfoCellViewDesc){
                ws.homeInfoModel.brandIntroduction = blockmodel.brandIntroduction;
            }else if(blockviewType == YYBrandModifyInfoCellViewConnBrand){
                ws.homeInfoModel.retailerName = [blockmodel.retailerName copy];
            }else if(blockviewType == YYBrandModifyInfoCellViewWebsite)
            {
                NSDictionary *modelDic= [model toDictionary];
                ws.homeInfoModel.webUrl = [modelDic objectForKey:@"webUrl"];
            }else if(blockviewType == YYBrandModifyInfoCellViewSocial){
                ws.homeInfoModel.userSocialInfos = [blockmodel.userSocialInfos copy];
            }else if(blockviewType == YYBrandModifyInfoCellViewContactTxt){
                ws.homeInfoModel.userContactInfos = [blockmodel.userContactInfos copy];
            }else if(blockviewType == YYBrandModifyInfoCellViewContactTelephone){
                ws.homeInfoModel.userContactInfos = [blockmodel.userContactInfos copy];
            }else if(blockviewType == YYBrandModifyInfoCellViewContactMobile){
                ws.homeInfoModel.userContactInfos = [blockmodel.userContactInfos copy];
            }
            if(_blockSaveSuccess){
                _blockSaveSuccess(ws.homeInfoModel);
            }
            [ws.tableView reloadData];
        }else{
            [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
            [ws.tableView reloadData];
        }
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 4;
    }else if(section == 1){
        return 5;
    }else if(section == 2){
        return 4;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            NSInteger maxPhotoNum = 3;
            maxPhotoNum = MIN([_uploadImgs count], maxPhotoNum-1);
            return [YYBrandModifyInfoUploadViewCell cellHeight:maxPhotoNum];
        }
        return 60;
    }else if(indexPath.section == 1){
        return 60;
    }else if(indexPath.section == 2){
        return 60;
    }else{
        return 0.1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeakSelf(ws);
    if(indexPath.section == 0){
        if(indexPath.row == 0){
            YYBrandModifyInfoUploadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBrandModifyInfoUploadViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            [cell updateCellInfo:_uploadImgs];
            
            return cell;
        }else if(indexPath.row == 1){
            YYBrandModifyInfoTxtViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBrandModifyInfoTxtViewCell" forIndexPath:indexPath];
            [cell downlineIsHide:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = NSLocalizedString(@"品牌简介",nil);
            cell.valueLabel.text = _homeInfoModel.brandIntroduction;
            cell.valueLabel.numberOfLines = 2;
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBrandModifyInfoCellViewDesc detailType:nil value:value];
            };
            return cell;
        }else{
            YYBrandModifyInfoTxtViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBrandModifyInfoTxtViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if (indexPath.row == 2){
                [cell downlineIsHide:NO];
                cell.titleLabel.text = NSLocalizedString(@"列举三个合作买手店",nil);
                if(_homeInfoModel.retailerName && [_homeInfoModel.retailerName count] > 0){
                    cell.valueLabel.text = [_homeInfoModel.retailerName componentsJoinedByString:@"，"];
                }else{
                    cell.valueLabel.text = @"";
                }
                cell.valueLabel.numberOfLines = 1;
                cell.selectedValue = ^(NSString *value){
                    NSString *jsonStr = nil;
                    if(_homeInfoModel.retailerName && [_homeInfoModel.retailerName count] > 0){
                        jsonStr = objArrayToJSON(_homeInfoModel.retailerName);
                    }
                    [ws modifyCell:YYBrandModifyInfoCellViewConnBrand detailType:nil value:[[NSString alloc] initWithFormat:@"retailerName=%@",jsonStr]];
                };
            }else if (indexPath.row == 3){
                [cell downlineIsHide:YES];
                cell.titleLabel.text = NSLocalizedString(@"网站",nil);
                cell.valueLabel.text = _homeInfoModel.webUrl;
                cell.valueLabel.numberOfLines = 1;
                cell.selectedValue = ^(NSString *value){
                
                    [ws modifyCell:YYBrandModifyInfoCellViewWebsite detailType:@"social_weburl" value:value];
                };
            }
            return cell;
        }
    }else if(indexPath.section == 1){
        YYBrandModifyInfoContactViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBrandModifyInfoContactViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0){
            [cell downlineIsHide:NO];
            [cell.titleBtn setTitle:@"Email" forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"email_icon2"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 0;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBrandModifyInfoCellViewContactTxt detailType:@"email" value:value];
            };
        }else if (indexPath.row == 1){
            [cell downlineIsHide:NO];
            [cell.titleBtn setTitle:NSLocalizedString(@"固定电话",nil) forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"phone_icon1"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 4;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBrandModifyInfoCellViewContactTelephone detailType:nil value:value];
            };
            
        }else if (indexPath.row == 2){
            [cell downlineIsHide:NO];
            [cell.titleBtn setTitle:NSLocalizedString(@"手机",nil) forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"mobile_icon"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 1;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBrandModifyInfoCellViewContactMobile detailType:nil value:value];
            };
        }else if (indexPath.row == 3){
            [cell downlineIsHide:NO];
            [cell.titleBtn setTitle:@"QQ" forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"qq_icon1"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 2;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBrandModifyInfoCellViewContactTxt detailType:@"qq" value:value];
            };
            
        }else if (indexPath.row == 4){
            [cell downlineIsHide:YES];
            [cell.titleBtn setTitle:NSLocalizedString(@"微信",nil) forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"weixin_icon1"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 3;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBrandModifyInfoCellViewContactTxt detailType:@"weixin" value:value];
            };
        }
        return cell;
    }else{
        YYBrandModifyInfoSocialViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBrandModifyInfoSocialViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.titleBtn setTitle:@"" forState:UIControlStateNormal];
        NSString *detailType = nil;
        if(indexPath.row == 0){
            [cell.titleBtn setTitle:NSLocalizedString(@"新浪微博",nil) forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"sina_icon"] forState:UIControlStateNormal];
            cell.socialType = 0;
            detailType = @"social_sina";
        }else if (indexPath.row == 1){
            [cell.titleBtn setTitle:NSLocalizedString(@"微信公众号",nil) forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"weixin_public_icon"] forState:UIControlStateNormal];
            cell.socialType = 1;
            detailType = @"social_weixin";
        }else if (indexPath.row == 2){
            [cell.titleBtn setTitle:@"Facebook" forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"facebook_icon"] forState:UIControlStateNormal];
            cell.socialType = 2;
            detailType = @"social_facebook";
            
        }else if (indexPath.row == 3){
            [cell.titleBtn setTitle:@"Instagram" forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"instagram_icon"] forState:UIControlStateNormal];
            cell.socialType = 3;
            detailType = @"social_instagram";
        }
        cell.socialArr = _homeInfoModel.userSocialInfos;
        [cell updateUI];
        cell.selectedValue = ^(NSString *value){
            [ws modifyCell:YYBrandModifyInfoCellViewSocial detailType:detailType value:value];
        };
        return cell;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSString *title = nil;
    if(section == 0){
        title = NSLocalizedString(@"品牌信息",nil);
    }if (section == 1) {
        title = NSLocalizedString(@"商务联系方式",nil);
    } else if (section == 2) {
        title = NSLocalizedString(@"社交账户",nil);
    }
    YYBrandModifyHeadView *headview = [[YYBrandModifyHeadView alloc] initWithTitle:title];
    return headview;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    static NSString *CellIdentifier = @"SectionFooter";
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (headerView == nil){
        [NSException raise:@"SectionFooter == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
    }else{
        
    }
    headerView.contentView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:239.0f/255.0f alpha:1];
    
    return headerView;
}
//
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 57;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section ==2){
        return 0.1;
    }
    return 12;
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //    获取选择图片
    UIImage *image = [UIImage fixOrientation:info[UIImagePickerControllerOriginalImage]];
    WeakSelf(ws);
    if (image) {
        if (![YYCurrentNetworkSpace isNetwork]) {
            [YYToast showToastWithView:self.view title:kNetworkIsOfflineTips andDuration:kAlertToastDuration];
        }else{
            
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [YYOrderApi uploadImage:image size:3.0f andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSString *imageUrl, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                if (imageUrl
                    && [imageUrl length] > 0) {
                    
                    NSMutableArray *tmpValueArr = [[NSMutableArray alloc] initWithArray:_homeInfoModel.indexPics];
                    if(self.uploadImgType > [self.uploadImgs count]){
                        [self.uploadImgs addObject:image];
                        [tmpValueArr addObject:imageUrl];
                    }else{
                        [self.uploadImgs replaceObjectAtIndex:(self.uploadImgType-1) withObject:image];
                        [tmpValueArr addObject:imageUrl];
                    }
                    _homeInfoModel.indexPics = [tmpValueArr copy];
                    [self upLoadPhotoData];
                }
                
            }];
        }
        
        if(ws.uploadImgType > [ws.uploadImgs count]){
            [ws.uploadImgs addObject:image];
        }else{
            [ws.uploadImgs replaceObjectAtIndex:(ws.uploadImgType-1) withObject:image];
        }
        
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)btnClick:(NSInteger)row section:(NSInteger)section andParmas:(NSArray *)parmas{
    NSString *type = [parmas objectAtIndex:0];
    _uploadImgType = row;
    if([type isEqualToString:@"delete"]){
        [self deleteUpdatePhoto];
    }else if([type isEqualToString:@"add"]){
        [self upLoadPhotoImage];
    }
}

-(void)deleteUpdatePhoto{
    NSArray *valueArr = _homeInfoModel.indexPics;
    NSMutableArray *tmpValueArr = [[NSMutableArray alloc] initWithArray:valueArr];
    if(self.uploadImgType > [self.uploadImgs count]){
    }else{
        [self.uploadImgs removeObjectAtIndex:(self.uploadImgType-1)];
        [tmpValueArr removeObjectAtIndex:(self.uploadImgType-1)];
    }
    _homeInfoModel.indexPics = [tmpValueArr copy];
    [self upLoadPhotoData];
    [self.tableView reloadData];
}

-(void)upLoadPhotoData
{
    if([_homeInfoModel.indexPics count] > 0){
        [self updateHomeInfo:@[[NSString stringWithFormat:@"indexPics=%@",[_homeInfoModel.indexPics componentsJoinedByString:@","]]] viewType:-1];
    }else{
        [self updateHomeInfo:@[[NSString stringWithFormat:@"indexPics=%@",@""]] viewType:-1];
    }
    [self.tableView reloadData];
}
-(void)upLoadPhotoImage{
    WeakSelf(ws);
    UIImagePickerController *picker=[[UIImagePickerController alloc] init];
    picker.view.backgroundColor = _define_white_color;
    picker.delegate = self;
    picker.videoQuality = UIImagePickerControllerQualityTypeLow;
    picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    UIAlertController * alertController = [regular getAlertWithFirstActionTitle:NSLocalizedString(@"相册",nil) FirstActionBlock:^{
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [ws presentViewController:picker animated:YES completion:nil];
        }else
        {
            NSLog(@"无法打开相册");
        }
        
    } SecondActionTwoTitle:NSLocalizedString(@"拍照",nil) SecondActionBlock:^{
        
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            //打开相机
            picker.allowsEditing = NO;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            //picker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            [ws presentViewController:picker animated:YES completion:nil];
        }else
        {
            NSLog(@"不能打开相机");
        }
        
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}
#pragma mark - Other
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
