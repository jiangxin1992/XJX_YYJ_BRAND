
#include <string.h>
#include "ESSAAES.h"

@implementation ESSAAES

//+ (NSData *)AES128Operation:(NSData *)data operation:(CCOperation)operation key:(NSString *)key iv:(NSString *)iv
//{
//    char keyPtr[kCCKeySizeAES128 + 1];
//    memset(keyPtr, 0, sizeof(keyPtr));
//    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
//    
//    char ivPtr[kCCBlockSizeAES128 + 1];
//    memset(ivPtr, 0, sizeof(ivPtr));
//    [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
//    
//    NSUInteger dataLength = [data length];
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
//    
//    void *buffer = malloc(bufferSize);
//    
//    size_t numBytesCrypted = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionECBMode, keyPtr, kCCBlockSizeAES128, ivPtr, [data bytes], dataLength, buffer, bufferSize, &numBytesCrypted);
//    if(cryptStatus == kCCSuccess)
//    {
//        return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
//    }
//    
//    free(buffer);
//    
//    return nil;
//}

//+ (NSData *)AES256EncryptWithKey:(NSData *)data key:(NSData *)key   //<strong>加密</strong>
//{
//    //AES256<strong>加密</strong>，密钥应该是32位的
//
//    //const void * keyPtr2 = [key bytes];
//
//    //char (*keyPtr)[32] = (char *)keyPtr2;
//
//    //对于块<strong>加密</strong><strong>算法</strong>，输出大小总是等于或小于输入大小加上一个块的大小
//
//    //所以在下边需要再加上一个块的大小
//
//    NSUInteger dataLength = [data length];
//
//    size_t bufferSize = dataLength + kCCBlockSizeAES128;
//
//    void *buffer = malloc(bufferSize);
//
//    size_t numBytesEncrypted = 0;
//
//    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,
//                                          kCCOptionPKCS7Padding/*这里就是刚才说到的PKCS7Padding填充了*/| kCCOptionECBMode,
//                                          [key bytes], kCCBlockSizeAES128,//kCCKeySizeAES256,
//                                          NULL,/* 初始化向量(可选) */
//                                          [data bytes], dataLength,/*输入*/
//                                          buffer, bufferSize,/* 输出 */
//                                          &numBytesEncrypted);
//
//    if(cryptStatus == kCCSuccess)
//    {
//        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
//    }
//
//    free(buffer);//释放buffer
//
//    return nil;
//}

+ (NSData *)AESOperation:(NSData *)data operation:(CCOperation)operation key:(NSData *)key keyLen:(size_t)keyLen iv:(NSString *)iv
{
    char *pIV = nil;
    
    char ivPtr[kCCBlockSizeAES128 + 1];
    if(iv && [iv length])
    {
        memset(ivPtr, 0, sizeof(ivPtr));
        [iv getCString:ivPtr maxLength:sizeof(ivPtr) encoding:NSUTF8StringEncoding];
    }
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    
    void *buffer = malloc(bufferSize);
    if(buffer)
    {
        size_t numBytesCrypted = 0;
        CCCryptorStatus cryptStatus = CCCrypt(operation, kCCAlgorithmAES128, kCCOptionPKCS7Padding | kCCOptionECBMode, [key bytes], keyLen, pIV, [data bytes], dataLength, buffer, bufferSize, &numBytesCrypted);
        
        if(cryptStatus == kCCSuccess)
        {
            return [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        }
        
        free(buffer);
    }
    
    return nil;
}

+ (NSData *)Encode:(NSData *)data key:(NSData *)key
{
    if(data && [data length])
    {
        return [ESSAAES AESOperation:data operation:kCCEncrypt key:key keyLen:kCCBlockSizeAES128 iv:nil];
    }

    return nil;
}

+ (NSData *)Decode:(NSData *)data key:(NSData *)key
{
    if(data && [data length])
    {
        return [ESSAAES AESOperation:data operation:kCCDecrypt key:key keyLen:kCCBlockSizeAES128 iv:nil];
    }

    return nil;
}

@end
