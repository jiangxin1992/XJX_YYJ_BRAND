
#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonCryptor.h>

@interface ESSAAES : NSObject
{
}

+ (NSData *)Encode:(NSData *)data key:(NSData *)key;//key:(NSString *)key iv:(NSString *)iv;
+ (NSData *)Decode:(NSData *)data key:(NSData *)key;
//+ (NSData *)Decode:(NSData *)data key:(NSString *)key iv:(NSString *)iv;

@end
