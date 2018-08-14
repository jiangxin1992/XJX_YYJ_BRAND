
#import <UIKit/UIKit.h>

enum TBase64ErrorCode
{
    ESSA_BUF_ERROR = -1,
    ESSA_NOT_BASE64_STRING = -2,
};

@interface ESSABase64 : NSObject
{
}

+ (NSString *)Encode:(NSData *)data;
//+ (NSData *)Decode:(NSString *)str;
+ (NSData *)Decode:(NSData *)data;

@end
