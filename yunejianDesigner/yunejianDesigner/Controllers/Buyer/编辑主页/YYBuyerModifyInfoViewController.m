//
//  YYBuyerModifyInfoViewController.m
//  YunejianBuyer
//
//  Created by Apple on 16/12/21.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBuyerModifyInfoViewController.h"

#import "YYNavigationBarViewController.h"
#import "YYBuyerModifyInfoCellViewController.h"

#import "YYBuyerModifyInfoHeadViewCell.h"
#import "YYBuyerModifyInfoTxtViewCell.h"
#import "YYBuyerModifyInfoContactViewCell.h"
#import "YYBuyerModifyInfoSocialViewCell.h"
#import "YYBuyerModifyInfoUploadViewCell.h"
#import "YYPickView.h"
#import "YYBrandModifyHeadView.h"

#import "UIImage+Tint.h"
#import "regular.h"
#import "YYUser.h"
#import "MBProgressHUD.h"
#import "YYOrderApi.h"
#import "YYBuyerHomeUpdateModel.h"
#import "YYUserApi.h"
#import "YYCountryPickView.h"

@interface YYBuyerModifyInfoViewController ()<UITableViewDataSource,UITableViewDelegate,YYCountryPickViewDelegate,YYTableCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

@property (nonatomic,strong) YYCountryListModel *countryInfo;
@property (nonatomic,strong) YYCountryListModel *provinceInfo;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,assign) NSInteger uploadImgType;
@property(nonatomic,strong) NSMutableArray *uploadImgs;
//@property(nonatomic,strong) YYPickView *pickerView;
@property(nonatomic,strong) YYCountryPickView *countryPickerView;
@property(nonatomic,strong) YYCountryPickView *provincePickerView;

@property(nonatomic,strong) NSString *currentNation;
@property(nonatomic,strong) NSNumber *currentNationID;
@property(nonatomic,strong) NSString *currentProvinece;
@property(nonatomic,strong) NSNumber *currentProvineceID;
@property(nonatomic,strong) NSString *currentCity;
@property(nonatomic,strong) NSNumber *currentCityID;

@property(nonatomic,assign) BOOL provinceIsChanged;

@end

@implementation YYBuyerModifyInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SomePrepare];
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
    NSInteger count =  [_homeInfoModel.storeImgs count];
    [self resetCellNSArrayValue:count target:_homeInfoModel.storeImgs];
    
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
#pragma mark - YYCountryPickViewDelegate

-(void)toobarDonBtnHaveCountryClick:(YYCountryPickView *)pickView resultString:(NSString *)resultString{
    //只会在选择完城市之后调保存信息接口
    if(pickView == _countryPickerView){
        //        选择国家后保存select信息（临时）
        //        选择了国家 判断是不是切换了国家  切换了重置省 城市
        NSArray *countryArr = [resultString componentsSeparatedByString:@"/"];
        if(countryArr.count > 1){
            if([self.currentNationID integerValue] != [countryArr[1] integerValue]){
                //切换了初始化
                [self initProvinceCityData];
                //更新国家信息
                self.currentNation = countryArr[0];
                self.currentNationID = @([countryArr[1] integerValue]);
                NSLog(@"111");
            }
        }else{
            //切换了初始化
            [self initCountryData];
            [self initProvinceCityData];
        }
        NSLog(@"\ncurrentNation = %@ currentNationID = %ld \n currentProvinece = %@ currentProvineceID = %ld \n currentCity = %@ currentCityID = %ld \n",_currentNation,[_currentNationID integerValue],_currentProvinece,[_currentProvineceID integerValue],_currentCity,[_currentCityID integerValue]);
        //打开城市选择器
        [self selectCity];
        
    }else if(pickView == _provincePickerView){
        NSArray *provinceCityArr = [resultString componentsSeparatedByString:@","];
        if(provinceCityArr.count){
            NSArray * provinceArr = [provinceCityArr[0] componentsSeparatedByString:@"/"];
            if(provinceArr.count > 1){
                self.currentProvinece = provinceArr[0];
                self.currentProvineceID = @([provinceArr[1] integerValue]);
            }else{
                [self initProvinceData];
            }
            
            if(provinceCityArr.count > 1){
                
                NSArray * cityArr = [provinceCityArr[1] componentsSeparatedByString:@"/"];
                if(cityArr.count > 1){
                    self.currentCity = cityArr[0];
                    self.currentCityID = @([cityArr[1] integerValue]);
                }else{
                    [self initCityData];
                }
            }else{
                [self initCityData];
            }
        }
        NSLog(@"currentNation = %@ currentNationID = %ld \n currentProvinece = %@ currentProvineceID = %ld \n currentCity = %@ currentCityID = %ld \n",_currentNation,[_currentNationID integerValue],_currentProvinece,[_currentProvineceID integerValue],_currentCity,[_currentCityID integerValue]);
        
        NSArray *paramsArr = [self getCountryParamsArr];
        
        [self updateHomeInfo:paramsArr viewType:0];
    }
}

#pragma mark - SomeAction
-(void)setHomeInfoModel:(YYBuyerHomeInfoModel *)homeInfoModel{
    _homeInfoModel = homeInfoModel;
    
    [self updateTempCountryDataByRealData];
}
-(NSArray *)getCountryParamsArr{
    NSString *_nationId  = @"";
    if([_currentNationID integerValue]>0){
        _nationId = [[NSString alloc] initWithFormat:@"%ld",[_currentNationID integerValue]];
    }
    NSString *_provinceId  = @"";
    if([_currentProvineceID integerValue]>0){
        _provinceId = [[NSString alloc] initWithFormat:@"%ld",[_currentProvineceID integerValue]];
    }
    NSString *_cityId = @"";
    if([_currentCityID integerValue]>0){
        _cityId = [[NSString alloc] initWithFormat:@"%ld",[_currentCityID integerValue]];
    }
    
    NSString *_nation  = @"";
    if(![NSString isNilOrEmpty:_currentNation]){
        if(![_currentNation isEqualToString:@"-"]){
            _nation = _currentNation;
        }
    }
    
    NSString *_province  = @"";
    if(![NSString isNilOrEmpty:_currentProvinece]){
        if(![_currentProvinece isEqualToString:@"-"]){
            _province = _currentProvinece;
        }
    }
    
    NSString *_city  = @"";
    if(![NSString isNilOrEmpty:_currentCity]){
        if(![_currentCity isEqualToString:@"-"]){
            _city = _currentCity;
        }
    }
    NSArray *paramsArr = @[
                           [NSString stringWithFormat:@"nation=%@",_nation]
                           ,[NSString stringWithFormat:@"province=%@",_province]
                           ,[NSString stringWithFormat:@"city=%@",_city]
                           ,[NSString stringWithFormat:@"nationId=%@",_nationId]
                           ,[NSString stringWithFormat:@"provinceId=%@",_provinceId]
                           ,[NSString stringWithFormat:@"cityId=%@",_cityId]
                           ];
    return paramsArr;
}
//更新国家城市相关tempdata
-(void)updateTempCountryDataByRealData{
    if ([_homeInfoModel.provinceId integerValue]) {
        NSString *proviceStr = [LanguageManager isEnglishLanguage]?_homeInfoModel.provinceEn:_homeInfoModel.province;
        self.currentProvinece = proviceStr;
        self.currentProvineceID = _homeInfoModel.provinceId;
    }
    
    if ([_homeInfoModel.cityId integerValue]) {
        NSString *cityStr = [LanguageManager isEnglishLanguage]?_homeInfoModel.cityEn:_homeInfoModel.city;
        self.currentCity = cityStr;
        self.currentCityID = _homeInfoModel.cityId;
    }
    
    if ([_homeInfoModel.nationId integerValue]) {
        
        self.currentNation = [LanguageManager isEnglishLanguage]?_homeInfoModel.nationEn:_homeInfoModel.nation;
        self.currentNationID = _homeInfoModel.nationId;
    }
    NSLog(@"111");
}
-(void)initProvinceCityData{
    _provinceInfo = nil;
    _currentProvinece = @"";
    _currentCity = @"";
    _currentProvineceID = @(0);
    _currentCityID = @(0);
}
-(void)initProvinceData{
    _currentProvinece = @"";
    _currentProvineceID = @(0);
}
-(void)initCityData{
    _currentCity = @"";
    _currentCityID = @(0);
}
-(void)initCountryData{
    _currentNation = @"";
    _currentNationID = @(0);
}
-(void)selectCity{
    
    [_countryPickerView removeNoBlock];
    [regular dismissKeyborad];
    if(!_provinceInfo){
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        [YYUserApi getSubCountryInfoWithCountryID:[_currentNationID integerValue] WithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYCountryListModel *countryListModel, NSInteger impId,NSError *error) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
            if (rspStatusAndMessage.status == kCode100) {
                if(countryListModel.result.count){
                    _provinceInfo = countryListModel;
                }else{
                    YYCountryModel *TempModel = [[YYCountryModel alloc] init];
                    TempModel.impId = @(-1);
                    TempModel.name = @"-";
                    TempModel.nameEn = @"-";
                    countryListModel.result = [NSArray arrayWithObject:TempModel];
                    _provinceInfo = countryListModel;
                }
                
                if(_provinceInfo.result.count){
                    self.provincePickerView=[[YYCountryPickView alloc] initPickviewWithCountryArray:_provinceInfo.result WithPlistType:SubCountryPickView isHaveNavControler:NO];
                    self.provincePickerView.delegate = self;
                    [_provincePickerView show:self.view];
                    WeakSelf(ws);
                    [_provincePickerView setCancelButtonClicked:^(){
                        [ws updateTempCountryDataByRealData];
                        //                        NSLog(@"\ncurrentNation = %@ currentNationID = %ld \n currentProvinece = %@ currentProvineceID = %ld \n currentCity = %@ currentCityID = %ld \n",_currentNation,[_currentNationID integerValue],_currentProvinece,[_currentProvineceID integerValue],_currentCity,[_currentCityID integerValue]);
                        NSLog(@"111");
                    }];
                }
            }
        }];
    }else{
        [_provincePickerView show:self.view];
    }
}
-(void)selectCountry{
    [_provincePickerView removeNoBlock];
    [regular dismissKeyborad];
    
    if(!_countryInfo){
        [YYUserApi getCountryInfoWithBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYCountryListModel *countryListModel, NSError *error) {
            if (rspStatusAndMessage.status == kCode100) {
                _countryInfo = countryListModel;
                
                if(_countryInfo.result.count){
                    self.countryPickerView=[[YYCountryPickView alloc] initPickviewWithCountryArray:_countryInfo.result WithPlistType:CountryPickView isHaveNavControler:NO];
                    self.countryPickerView.delegate = self;
                    [_countryPickerView show:self.view];
                    WeakSelf(ws);
                    [_countryPickerView setCancelButtonClicked:^(){
                        [ws updateTempCountryDataByRealData];
                    }];
                }
            }
        }];
    }else{
        [_countryPickerView show:self.view];
    }
}


-(void)modifyCell:(NSInteger)viewType detailType:(NSString *)detailType value:(NSString *)value{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Buyer" bundle:[NSBundle mainBundle]];
    YYBuyerModifyInfoCellViewController *buyerModifyInfoCellController = [storyboard instantiateViewControllerWithIdentifier:@"YYBuyerModifyInfoCellViewController"];
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
            if(blockviewType == YYBuyerModifyInfoCellViewPrice)
            {
                NSArray *valueArr = [value componentsSeparatedByString:@"&"];
                if([valueArr count] > 0){
                    [ws updateHomeInfo:valueArr viewType:blockviewType];
                }else{
                    [ws updateHomeInfo:@[value] viewType:blockviewType];
                }
            }else
            {
                [ws updateHomeInfo:@[value] viewType:blockviewType];
            }
        }
        [ws.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:buyerModifyInfoCellController animated:YES];
}

-(void)updateHomeInfo:(NSArray *)paramsArr viewType:(NSInteger)viewType{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    YYBuyerHomeUpdateModel *model = [YYBuyerHomeUpdateModel createUploadCertModel:paramsArr];
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
    NSLog(@"[model toJSONString] %@",[model toJSONString]);
    
    WeakSelf(ws);
    NSData *jsondata = [[model toDictionary] mj_JSONData];
    [YYUserApi updateBuyerWithData:jsondata andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, NSError *error) {
        if( rspStatusAndMessage.status == kCode100){
            //更新处理 重新获取用户数据
            [YYUserApi getBuyerHomeInfo:@"" andBlock:^(YYRspStatusAndMessage *rspStatusAndMessage, YYBuyerHomeInfoModel *infoModel, NSError *error) {
                [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
                if(rspStatusAndMessage.status == kCode100){
                    [self updateHomeInfoWithData:infoModel];
                    [ws.tableView reloadData];
                }else{
                    [YYToast showToastWithView:ws.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
                }
            }];
        }else{
            [MBProgressHUD hideAllHUDsForView:ws.view animated:YES];
            [YYToast showToastWithView:self.view title:rspStatusAndMessage.message andDuration:kAlertToastDuration];
        }
    }];
}
-(void)updateHomeInfoWithData:(YYBuyerHomeInfoModel *)infoModel{
    
    self.homeInfoModel.nation = infoModel.nation;
    self.homeInfoModel.province = infoModel.province;
    self.homeInfoModel.city = infoModel.city;
    self.homeInfoModel.nationEn = infoModel.nationEn;
    self.homeInfoModel.provinceEn = infoModel.provinceEn;
    self.homeInfoModel.cityEn = infoModel.cityEn;
    self.homeInfoModel.nationId = infoModel.nationId;
    self.homeInfoModel.provinceId = infoModel.provinceId;
    self.homeInfoModel.cityId = infoModel.cityId;
    self.homeInfoModel.priceMin = infoModel.priceMin;
    self.homeInfoModel.logoPath = infoModel.logoPath;
    self.homeInfoModel.buyerId = infoModel.buyerId;
    self.homeInfoModel.priceMax = infoModel.priceMax;
    self.homeInfoModel.userContactInfos = infoModel.userContactInfos;
    self.homeInfoModel.introduction = infoModel.introduction;
    self.homeInfoModel.userSocialInfos = infoModel.userSocialInfos;
    self.homeInfoModel.street = infoModel.street;
    self.homeInfoModel.connectStatus = infoModel.connectStatus;
    self.homeInfoModel.addressDetail = infoModel.addressDetail;
    self.homeInfoModel.town = infoModel.town;
    self.homeInfoModel.copBrands = infoModel.copBrands;
    self.homeInfoModel.storeImgs = infoModel.storeImgs;
    self.homeInfoModel.percent = infoModel.percent;
    self.homeInfoModel.webUrl = infoModel.webUrl;
    self.homeInfoModel.name = infoModel.name;
    self.homeInfoModel.email = infoModel.email;
    self.homeInfoModel.pickerRow = infoModel.pickerRow;
    self.homeInfoModel.pickerComponent = infoModel.pickerComponent;
    self.homeInfoModel.legalPersonFiles = infoModel.legalPersonFiles;
    self.homeInfoModel.licenceFile = infoModel.licenceFile;
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0){
        return 8;
    }else if(section == 1){
        return 5;
    }else if(section == 2){
        return 4;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        if(indexPath.row == 4){
            NSInteger maxPhotoNum = 8;
            maxPhotoNum = MIN([_uploadImgs count], maxPhotoNum-1);
            return [YYBuyerModifyInfoUploadViewCell cellHeight:maxPhotoNum];
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
        if(indexPath.row == 4){
            YYBuyerModifyInfoUploadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyInfoUploadViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
            [cell updateCellInfo:_uploadImgs];
            
            return cell;
        }else if(indexPath.row == 3){
            YYBuyerModifyInfoTxtViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyInfoTxtViewCell" forIndexPath:indexPath];
            [cell downlineIsHide:NO];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.titleLabel.text = NSLocalizedString(@"买手店简介",nil);
            cell.valueLabel.text = _homeInfoModel.introduction;
            cell.valueLabel.numberOfLines = 2;
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBuyerModifyInfoCellViewDesc detailType:nil value:value];
            };
            return cell;
        }else{
            YYBuyerModifyInfoTxtViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyInfoTxtViewCell" forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if(indexPath.row == 0){
                [cell downlineIsHide:NO];
                cell.titleLabel.text = NSLocalizedString(@"所在国家",nil);
                NSString *nationStr = [LanguageManager isEnglishLanguage]?_homeInfoModel.nationEn:_homeInfoModel.nation;
                cell.valueLabel.text = nationStr;
                cell.valueLabel.numberOfLines = 1;
                cell.selectedValue = ^(NSString *value){
                    [ws selectCountry];
                };
            }else if(indexPath.row == 1){
                [cell downlineIsHide:NO];
                cell.titleLabel.text = NSLocalizedString(@"所在省/市/区",nil);
                NSString *provinceStr = [LanguageManager isEnglishLanguage]?_homeInfoModel.provinceEn:_homeInfoModel.province;
                NSString *cityStr = [LanguageManager isEnglishLanguage]?_homeInfoModel.cityEn:_homeInfoModel.city;
                cell.valueLabel.text = [NSString stringWithFormat:@"%@ %@",provinceStr,cityStr];
                cell.valueLabel.numberOfLines = 1;
                cell.selectedValue = ^(NSString *value){
                    [ws selectCity];
                };
            }else if (indexPath.row == 2){
                [cell downlineIsHide:NO];
                cell.titleLabel.text = NSLocalizedString(@"详细地址",nil);
                cell.valueLabel.text = _homeInfoModel.addressDetail;
                cell.valueLabel.numberOfLines = 1;
                cell.selectedValue = ^(NSString *value){
                    [ws modifyCell:YYBuyerModifyInfoCellViewDetailAddress detailType:nil value:value];
                };
            }else if (indexPath.row == 5){
                [cell downlineIsHide:NO];
                cell.titleLabel.text = NSLocalizedString(@"款式零售价范围",nil);
                cell.valueLabel.text = [NSString stringWithFormat:@"￥%@-%@",_homeInfoModel.priceMin,_homeInfoModel.priceMax];
                cell.valueLabel.numberOfLines = 1;
                cell.selectedValue = ^(NSString *value){
                    [ws modifyCell:YYBuyerModifyInfoCellViewPrice detailType:nil value:[NSString stringWithFormat:@"priceMin=%@&priceMax=%@",_homeInfoModel.priceMin,_homeInfoModel.priceMax]];
                };
            }else if (indexPath.row == 6){
                [cell downlineIsHide:NO];
                cell.titleLabel.text = NSLocalizedString(@"列举合作品牌",nil);
                if(_homeInfoModel.copBrands && [_homeInfoModel.copBrands count] > 0){
                    cell.valueLabel.text = [_homeInfoModel.copBrands componentsJoinedByString:@"，"];
                }else{
                    cell.valueLabel.text = @"";
                }
                cell.valueLabel.numberOfLines = 1;
                cell.selectedValue = ^(NSString *value){
                    NSString *jsonStr = nil;
                    if(_homeInfoModel.copBrands && [_homeInfoModel.copBrands count] > 0){
                        jsonStr = objArrayToJSON(_homeInfoModel.copBrands);
                    }
                    [ws modifyCell:YYBuyerModifyInfoCellViewConnBrand detailType:nil value:[[NSString alloc] initWithFormat:@"copBrands=%@",jsonStr]];
                };
            }else if (indexPath.row == 7){
                [cell downlineIsHide:YES];
                cell.titleLabel.text = NSLocalizedString(@"网站",nil);
                cell.valueLabel.text = _homeInfoModel.webUrl;
                cell.valueLabel.numberOfLines = 1;
                cell.selectedValue = ^(NSString *value){
                    
                    [ws modifyCell:YYBuyerModifyInfoCellViewWebsite detailType:@"social_weburl" value:value];
                };
            }
            return cell;
        }
    }else if(indexPath.section == 1){
        YYBuyerModifyInfoContactViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyInfoContactViewCell" forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if(indexPath.row == 0){
            [cell downlineIsHide:NO];
            [cell.titleBtn setTitle:@"Email" forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"email_icon2"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 0;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBuyerModifyInfoCellViewContactTxt detailType:@"email" value:value];
            };
        }else if (indexPath.row == 1){
            [cell downlineIsHide:NO];
            [cell.titleBtn setTitle:NSLocalizedString(@"固定电话",nil) forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"phone_icon1"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 4;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBuyerModifyInfoCellViewContactTelephone detailType:nil value:value];
            };
            
        }else if (indexPath.row == 2){
            [cell downlineIsHide:NO];
            [cell.titleBtn setTitle:NSLocalizedString(@"手机",nil) forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"mobile_icon"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 1;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBuyerModifyInfoCellViewContactMobile detailType:nil value:value];
            };
        }else if (indexPath.row == 3){
            [cell downlineIsHide:NO];
            [cell.titleBtn setTitle:@"QQ" forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"qq_icon1"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 2;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBuyerModifyInfoCellViewContactTxt detailType:@"qq" value:value];
            };
            
        }else if (indexPath.row == 4){
            [cell downlineIsHide:YES];
            [cell.titleBtn setTitle:NSLocalizedString(@"微信",nil) forState:UIControlStateNormal];
            [cell.titleBtn setImage:[UIImage imageNamed:@"weixin_icon1"] forState:UIControlStateNormal];
            cell.conractArr = _homeInfoModel.userContactInfos;
            cell.conractType = 3;
            [cell updateUI];
            cell.selectedValue = ^(NSString *value){
                [ws modifyCell:YYBuyerModifyInfoCellViewContactTxt detailType:@"weixin" value:value];
            };
        }
        return cell;
    }else{
        YYBuyerModifyInfoSocialViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"YYBuyerModifyInfoSocialViewCell" forIndexPath:indexPath];
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
            [ws modifyCell:YYBuyerModifyInfoCellViewSocial detailType:detailType value:value];
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
                    
                    NSMutableArray *tmpValueArr = [[NSMutableArray alloc] initWithArray:_homeInfoModel.storeImgs];
                    if(self.uploadImgType > [self.uploadImgs count]){
                        [self.uploadImgs addObject:image];
                        [tmpValueArr addObject:imageUrl];
                    }else{
                        [self.uploadImgs replaceObjectAtIndex:(self.uploadImgType-1) withObject:image];
                        [tmpValueArr addObject:imageUrl];
                    }
                    _homeInfoModel.storeImgs = [tmpValueArr copy];
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
    NSArray *valueArr = _homeInfoModel.storeImgs;
    NSMutableArray *tmpValueArr = [[NSMutableArray alloc] initWithArray:valueArr];
    if(self.uploadImgType > [self.uploadImgs count]){
    }else{
        [self.uploadImgs removeObjectAtIndex:(self.uploadImgType-1)];
        [tmpValueArr removeObjectAtIndex:(self.uploadImgType-1)];
    }
    _homeInfoModel.storeImgs = [tmpValueArr copy];
    [self upLoadPhotoData];
    [self.tableView reloadData];
}

-(void)upLoadPhotoData
{
    if([_homeInfoModel.storeImgs count] > 0){
        [self updateHomeInfo:@[[NSString stringWithFormat:@"storeImgs=%@",[_homeInfoModel.storeImgs componentsJoinedByString:@","]]] viewType:-1];
    }else{
        [self updateHomeInfo:@[[NSString stringWithFormat:@"storeImgs=%@",@""]] viewType:-1];
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
