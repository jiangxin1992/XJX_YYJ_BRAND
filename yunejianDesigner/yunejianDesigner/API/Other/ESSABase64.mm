
#include <string.h>

#include "ESSABase64.h"

inline char Encode(unsigned char uc)
{
	if(uc < 26)
	{
		return 'A' + uc;
	}
	else if(uc < 52)
	{
		return 'a' + (uc - 26);
	}
	else if(uc < 62)
	{
		return '0' + (uc - 52);
	}
	else if(uc == 62)
	{
		return '+';
	}
	else
	{
		return '/';
	}
}

inline bool IsBase64(char c)
{
	if(c >= 'A' && c <= 'Z')
	{
		return true;
	}
	if(c >= 'a' && c <= 'z')
	{
		return true;
	}
	if(c >= '0' && c <= '9')
	{
		return true;
	}
	if(c == '+')
	{
		return true;
	}
	if(c == '/')
	{
		return true;
	}
	if(c == '=')
	{
		return true;
	}

	return false;
}

inline unsigned char Decode(char c)
{
	if(c >= 'A' && c <= 'Z')
	{
		return c - 'A';
	}
	else if(c >= 'a' && c <= 'z')
	{
		return c - 'a' + 26;
	}
	else if(c >= '0' && c <= '9')
	{
		return c - '0' + 52;
	}
	else if(c == '+')
	{
		return 62;
	}
	else
	{
		return 63;
	}
}

int Encode(const unsigned char *buf_in, int len_in, unsigned char *buf_out, int len_out)
{
	if(!buf_in || !buf_out || len_in == 0 || len_out == 0)
	{
		return ESSA_BUF_ERROR;
	}
    
	int encodeIndex = 0;
	for(int i = 0; i < len_in && encodeIndex < len_out; i += 3)
	{
		unsigned char by1 = 0;
		unsigned char by2 = 0;
		unsigned char by3 = 0;
        
		by1 = buf_in[i];
		if(i + 1 < len_in)
		{
			by2 = buf_in[i + 1];
		}
        
		if(i + 2 < len_in)
		{
			by3 = buf_in[i + 2];
		}
        
		unsigned char by4 = 0;
		unsigned char by5 = 0;
		unsigned char by6 = 0;
		unsigned char by7 = 0;
        
		by4 = (by1 >> 2) & 0x3f;
		by5 = ((by1 << 4) | (by2 >> 4)) & 0x3f;
		by6 = ((by2 << 2) | (by3 >> 6)) & 0x3f;
		by7 = by3 & 0x3f;
		buf_out[encodeIndex] = Encode(by4);
		encodeIndex++;
		buf_out[encodeIndex] = Encode(by5);
		encodeIndex++;
        
		if(i + 1 < len_in)
		{
			buf_out[encodeIndex] = Encode(by6);
			encodeIndex++;
		}
		else
		{
			buf_out[encodeIndex] = '=';
			encodeIndex++;
		}
        
		if(i + 2 < len_in)
		{
			buf_out[encodeIndex] = Encode(by7);
			encodeIndex++;
		}
		else
		{
			buf_out[encodeIndex] = '=';
			encodeIndex++;
		}
        
		/*if(i % (76 / 4 * 3) == 0)
         {
         buf_out[encodeIndex] = '\r';
         encodeIndex++;
         buf_out[encodeIndex] = '\n';
         encodeIndex++;
         //retval += "\r\n";
         }*/
	}
    
	return encodeIndex;
}

bool IsBase64(const unsigned char* base64_buf, int buf_len)
{
	char* temp = (char*)base64_buf;
	bool isBase64String = true;
	if(!temp)
	{
		return false;
	}

	for(int i = 0; i < buf_len; i++)
	{
		if(!IsBase64(*temp++))
		{
			isBase64String = false;
			break;
		}
	}

	return isBase64String;
}

int Decode(const unsigned char *buf_in, int len_in, unsigned char *buf_out, int len_out)
{
	int decodeIndex = 0;

	if(!buf_in || !buf_out || len_in == 0 || len_out == 0)
	{
		return ESSA_BUF_ERROR;
	}

	if(!IsBase64(buf_in, len_in))
	{
		return ESSA_NOT_BASE64_STRING;
	}

	for(int i = 0; i < len_in && decodeIndex < len_out; i += 4)
	{
		char c1 = 'A', c2 = 'A', c3 = 'A', c4 = 'A';
		c1 = buf_in[i];

		if(i + 1 < len_in)
		{
			c2 = buf_in[i + 1];
		}

		if(i + 2 < len_in)
		{
			c3 = buf_in[i + 2];
		}

		if(i + 3 < len_in)
		{
			c4 = buf_in[i + 3];
		}

		unsigned char by1 = 0, by2 = 0, by3 = 0, by4 = 0;
		by1 = Decode(c1);
		by2 = Decode(c2);
		by3 = Decode(c3);
		by4 = Decode(c4);
		buf_out[decodeIndex] = (by1 << 2) | (by2 >> 4);
		decodeIndex++;

		if(c3 != '=')
		{
			buf_out[decodeIndex] = (by2 << 4) | (by3 >> 2);
			decodeIndex++;
		}

		if(c4 != '=')
		{
			buf_out[decodeIndex] = (by3 << 6) | by4;
			decodeIndex++;
		}
	}

	return decodeIndex;
}

@implementation ESSABase64

+ (NSString *)Encode:(NSData *)data
{
    if(data && [data length])
    {
        int inLen = [data length];
        int outLen = inLen * 4 / 3;//len_out >= len_in*4/3,否则编码不完全
        unsigned char *out_buf = new unsigned char[outLen + 1];
        if(out_buf)
        {
            memset(out_buf, 0, outLen + 1);
            
            outLen = Encode((const unsigned char *)[data bytes], inLen, out_buf, outLen);
            if(outLen > 0)
            {
                //NSString *resultString = [NSString stringWithCharacters:(const unichar *)out_buf length:outLen];
                NSString *resultString = [NSString stringWithCString:(const char *)out_buf length:outLen];
                
                delete out_buf;
                
                return resultString;
            }
        }
    }

    return nil;
}

+ (NSData *)Decode:(NSData *)data
{
    if(data && [data length])
    {
        int inLen = [data length];
        int outLen = inLen * 3 / 4;//len_out >= len_in*3/4,否则解码不完全
        unsigned char *out_buf = new unsigned char[outLen + 1];
        if(out_buf)
        {
            memset(out_buf, 0, outLen + 1);
            
            outLen = Decode((const unsigned char *)[data bytes], inLen, out_buf, outLen);
            if(outLen > 0)
            {
                NSData *resultData = [NSData dataWithBytes:out_buf length:outLen];
                
                delete out_buf;
                
                return resultData;
            }
        }
    }
    
    return nil;
}

@end
