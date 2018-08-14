//
//  YYBaseWebView.m
//  yunejianDesigner
//
//  Created by Apple on 16/8/25.
//  Copyright © 2016年 Apple. All rights reserved.
//

#import "YYBaseWebView.h"
//#import "WebViewJavascriptBridge.h"
#import "MBProgressHUD.h"
@interface YYBaseWebView () <UIWebViewDelegate>
//@property (nonatomic, strong) UIActivityIndicatorView *activityView;;
//@property WebViewJavascriptBridge* bridge;
@end


@implementation YYBaseWebView 

- (instancetype)initWithFrame:(CGRect)frame urlString:(NSString *)urlString {
    self = [super initWithFrame:frame];
    if (self) {
        self.urlString = urlString;
    }
    return self;
}

- (void)setUrlString:(NSString *)urlString {
    _urlString = urlString;
    [self setup];
}

- (void)setup {
    self.delegate = self;
    //[self addSubview:self.activityView];
    [MBProgressHUD showHUDAddedTo:self animated:YES];
    [self loadTopicContentWebView];
//    _bridge = [WebViewJavascriptBridge bridgeForWebView:self webViewDelegate:self handler:^(id data, WVJBResponseCallback responseCallback) {
//        NSString *imageUrl = data[@"imageUrl"];
//        [self openImageInApp:imageUrl];
//    }];
}

//- (UIActivityIndicatorView *)activityView {
//    if (!_activityView) {
//        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//        _activityView.center = CGPointMake(CGRectGetWidth(self.frame)/2, CGRectGetHeight(self.frame)/2);
//        [_activityView startAnimating];
//    }
//    return _activityView;
//}

- (void)loadTopicContentWebView {
    NSURL *url = [NSURL URLWithString:_urlString];
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    //[requestObj setValue:[AccessTokenHandler getClientGrantAccessTokenFromLocal] forHTTPHeaderField:@"Authorization"];
    [self loadRequest:requestObj];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *url = [request URL];
//    if (navigationType == UIWebViewNavigationTypeLinkClicked && ![url.scheme isEqualToString:@"phphub"]) {
//        if ([url.host isEqualToString:PHPHubHost]) {
//            NSArray *pathComponents = url.pathComponents;
//            if (pathComponents.count > 1 && pathComponents[1] && pathComponents[2]) {
//                NSString *urlType = pathComponents[1];
//                NSNumber *payload = pathComponents[2];
//                if ([urlType isEqualToString:@"users"]) {
//                    [JumpToOtherVCHandler jumpToUserProfileWithUserId:payload];
//                } else if ([urlType isEqualToString:@"topics"]) {
//                    [JumpToOtherVCHandler jumpToTopicDetailWithTopicId:payload];
//                }
//                return NO;
//            }
//        }
//        [JumpToOtherVCHandler jumpToWebVCWithUrlString:url.absoluteString];
//        return NO;
//    }
    if(self.jumpPageSuccess){
        self.jumpPageSuccess([url absoluteString]);
    }
    return YES;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    //[_activityView removeFromSuperview];
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    //[_activityView removeFromSuperview];
    [MBProgressHUD hideAllHUDsForView:self animated:YES];
}

//- (void)openImageInApp:(NSString *)imageUrlString {
//    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
//    imageInfo.imageURL = [NSURL URLWithString:imageUrlString];
//    imageInfo.referenceRect = self.frame;
//    imageInfo.referenceView = self.superview;
//    
//    // Setup view controller
//    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
//                                           initWithImageInfo:imageInfo
//                                           mode:JTSImageViewControllerMode_Image
//                                           backgroundStyle:JTSImageViewControllerBackgroundOption_None];
//    
//    // Present the view controller.
//    [imageViewer showFromViewController:[JumpToOtherVCHandler getTabbarViewController] transition:JTSImageViewControllerTransition_FromOffscreen];
//}
@end
