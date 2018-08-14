//
//  Update_AppStore.h
//  FT
//
//  Created by yourentang on 15/8/4.
//  Copyright (c) 2015年 yourentang. All rights reserved.
//

#import "YYUpdateAppStore.h"

@interface YYUpdateAppStore (){
    
}

+ (void)showAlertWithAppStoreVersion:(NSString*)appStoreVersion;

@end

BOOL isForceUpdate = YES;//是否

@implementation YYUpdateAppStore

#pragma mark - Public Methods
+ (void)checkVersion
{
    // Asynchronously query iTunes AppStore for publically available version
    NSString *storeString = [NSString stringWithFormat:@"http://itunes.apple.com/lookup?id=%@", kYYAppID];
    NSURL *storeURL = [NSURL URLWithString:storeString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:storeURL];
    [request setHTTPMethod:@"GET"];
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
       
        if ( [data length] > 0 && !error ) { // Success
            
            NSDictionary *appData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

            dispatch_async(dispatch_get_main_queue(), ^{
                //[YYUpdateAppStore showAlertWithAppStoreVersion:nil];
                //return ;
                // All versions that have been uploaded to the AppStore
                NSArray *versionsInAppStore = [[appData valueForKey:@"results"] valueForKey:@"version"];
                
                if ( ![versionsInAppStore count] ) { // No versions of app in AppStore
                    //[YYUpdateAppStore showAlertWithAppStoreVersion:@"test"];

                    return;
                    
                } else {

                    NSString *currentAppStoreVersion = [versionsInAppStore objectAtIndex:0];
                    //NSLog(@"kYYCurrentVersion %@ %@",kYYCurrentVersion,currentAppStoreVersion);
                    if ( [kYYCurrentVersion compare:currentAppStoreVersion options:NSNumericSearch] == NSOrderedAscending) {
		                
                        [YYUpdateAppStore showAlertWithAppStoreVersion:currentAppStoreVersion];
	                
                    }
                    else {
		            
                        // Current installed version is the newest public version or newer	
	                
                    }

                }
              
            });
        }
        
    }];
}

#pragma mark - Private Methods
+ (void)showAlertWithAppStoreVersion:(NSString *)currentAppStoreVersion
{
    
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString*)kCFBundleNameKey];
    
    if ( isForceUpdate ) { // Force user to update app
        float uiscale = 0.7;
        float uiMaxScale = SCREEN_WIDTH/410-0.2;
        uiscale = MIN(uiscale, uiMaxScale);
        NSString *imageStr = [LanguageManager isEnglishLanguage]?@"newAppImage_brand_en":@"newAppImage_brand";
        CMAlertView *alertView = [[CMAlertView alloc] initWithImage:[UIImage imageNamed:imageStr] imageFrame:CGRectMake(0, 0, 410*uiscale, 509*uiscale) cancelButtonTitle:NSLocalizedString(@"去更新",nil) bgClose:YES];
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kYYAppID];
            NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
            [[UIApplication sharedApplication] openURL:iTunesURL];
        }];
        [alertView show];
        
    } else { // Allow user option to update next time user launches your app
        
        CMAlertView *alertView = [[CMAlertView alloc] initWithTitle:[NSString stringWithFormat:NSLocalizedString(@"检查更新：%@",nil),appName] message:[NSString stringWithFormat:NSLocalizedString(@"发现新版本（%@），是否升级",nil), currentAppStoreVersion] needwarn:NO delegate:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) otherButtonTitles:@[NSLocalizedString(@"升级",nil)] bgClose:YES];
        [alertView setAlertViewBlock:^(NSInteger selectedIndex){
            if (selectedIndex == 1) {
                NSString *iTunesString = [NSString stringWithFormat:@"https://itunes.apple.com/app/id%@", kYYAppID];
                NSURL *iTunesURL = [NSURL URLWithString:iTunesString];
                [[UIApplication sharedApplication] openURL:iTunesURL];
            }
        }];
        [alertView show];
        
    }
    
}
@end
