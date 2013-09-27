//
//  RORUtils.m
//  RevolUtioN
//
//  Created by leon on 13-7-7.
//  Copyright (c) 2013年 Beyond. All rights reserved.
//

#import "RORUtils.h"
#import <CommonCrypto/CommonDigest.h>

@implementation RORUtils

+ (NSString *)md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, strlen(cStr), result );
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0],result[1],result[2],result[3],
            result[4],result[5],result[6],result[7],
            result[8],result[9],result[10],result[11],
            result[12],result[13],result[14],result[15]];
}

+ (NSString *)uuidString {
    // Returns a UUID
    
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    NSString *uuidStr = (__bridge_transfer NSString *)CFUUIDCreateString(kCFAllocatorDefault, uuid);
    CFRelease(uuid);
    
    return uuidStr;
}

+ (NSString *)transSecondToStandardFormat:(double) seconds {
    NSInteger min=0, hour=0;
    min = seconds / 60;
    NSInteger intSeconds = (NSInteger)seconds % 60;
    hour = min / 60;
    min = min % 60;
    if (hour>0)
        return [NSString stringWithFormat:@"%d:%d'%d\"",hour, min, intSeconds];
    else if (min>0)
        return [NSString stringWithFormat:@"%d'%d\"", min, intSeconds];
    return [NSString stringWithFormat:@"%d\"%d", intSeconds, (NSInteger)((seconds - (NSInteger)seconds)*10)];
}

+ (NSString *)toJsonFormObject:(NSObject *)object{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    writer.humanReadable = YES;
    NSString *regStr = [writer stringWithObject:object];
    NSLog(@"%@",regStr);
    return regStr;
}

+ (NSString*)getCityCodeJSon{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityCode" ofType:@"geojson"];
    return path;
}

+(NSString *)getCurrentTime{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatDateString = [formate stringFromDate:[NSDate date]];
    return formatDateString;
}

+(NSDate *)getDateFromString:(NSString *) date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateFormat = [dateFormatter dateFromString: date];
    return dateFormat;
}

+(NSString *)getStringFromDate:(NSDate *) date{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatDateString = [formate stringFromDate:date];
    return formatDateString;
}

+ (NSData*) gzipCompressData:(NSData*)pUncompressedData
{
	/*
	 Special thanks to Robbie Hanson of Deusty Designs for sharing sample code
	 showing how deflateInit2() can be used to make zlib generate a compressed
	 file with gzip headers:
     
     http://deusty.blogspot.com/2007/07/gzip-compressiondecompression.html
     
	 */
    
	if (!pUncompressedData || [pUncompressedData length] == 0)
	{
		NSLog(@"%s: Error: Can't compress an empty or null NSData object.", __func__);
		return nil;
	}
    
	/* Before we can begin compressing (aka "deflating") data using the zlib
	 functions, we must initialize zlib. Normally this is done by calling the
	 deflateInit() function; in this case, however, we'll use deflateInit2() so
	 that the compressed data will have gzip headers. This will make it easy to
	 decompress the data later using a tool like gunzip, WinZip, etc.
     
	 deflateInit2() accepts many parameters, the first of which is a C struct of
	 type "z_stream" defined in zlib.h. The properties of this struct are used to
	 control how the compression algorithms work. z_stream is also used to
	 maintain pointers to the "input" and "output" byte buffers (next_in/out) as
	 well as information about how many bytes have been processed, how many are
	 left to process, etc. */
	z_stream zlibStreamStruct;
	zlibStreamStruct.zalloc    = Z_NULL; // Set zalloc, zfree, and opaque to Z_NULL so
	zlibStreamStruct.zfree     = Z_NULL; // that when we call deflateInit2 they will be
	zlibStreamStruct.opaque    = Z_NULL; // updated to use default allocation functions.
	zlibStreamStruct.total_out = 0; // Total number of output bytes produced so far
	zlibStreamStruct.next_in   = (Bytef*)[pUncompressedData bytes]; // Pointer to input bytes
	zlibStreamStruct.avail_in  = [pUncompressedData length]; // Number of input bytes left to process
    
	/* Initialize the zlib deflation (i.e. compression) internals with deflateInit2().
	 The parameters are as follows:
     
	 z_streamp strm - Pointer to a zstream struct
	 int level      - Compression level. Must be Z_DEFAULT_COMPRESSION, or between
     0 and 9: 1 gives best speed, 9 gives best compression, 0 gives
     no compression.
	 int method     - Compression method. Only method supported is "Z_DEFLATED".
	 int windowBits - Base two logarithm of the maximum window size (the size of
     the history buffer). It should be in the range 8..15. Add
     16 to windowBits to write a simple gzip header and trailer
     around the compressed data instead of a zlib wrapper. The
     gzip header will have no file name, no extra data, no comment,
     no modification time (set to zero), no header crc, and the
     operating system will be set to 255 (unknown).
	 int memLevel   - Amount of memory allocated for internal compression state.
     1 uses minimum memory but is slow and reduces compression
     ratio; 9 uses maximum memory for optimal speed. Default value
     is 8.
	 int strategy   - Used to tune the compression algorithm. Use the value
     Z_DEFAULT_STRATEGY for normal data, Z_FILTERED for data
     produced by a filter (or predictor), or Z_HUFFMAN_ONLY to
     force Huffman encoding only (no string match) */
    int initError = deflateInit2(&zlibStreamStruct, Z_DEFAULT_COMPRESSION, Z_DEFLATED, (15+16), 8, Z_DEFAULT_STRATEGY);
	if (initError != Z_OK)
	{
		NSString *errorMsg = nil;
		switch (initError)
		{
			case Z_STREAM_ERROR:
				errorMsg = @"Invalid parameter passed in to function.";
				break;
			case Z_MEM_ERROR:
				errorMsg = @"Insufficient memory.";
				break;
			case Z_VERSION_ERROR:
				errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
				break;
			default:
				errorMsg = @"Unknown error code.";
				break;
		}
		NSLog(@"%s: deflateInit2() Error: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
		return nil;
	}
    
	// Create output memory buffer for compressed data. The zlib documentation states that
	// destination buffer size must be at least 0.1% larger than avail_in plus 12 bytes.
	NSMutableData *compressedData = [NSMutableData dataWithLength:[pUncompressedData length] * 1.01 + 12];
    
	int deflateStatus = 0;
	do
	{
        if ((deflateStatus == Z_BUF_ERROR) || (zlibStreamStruct.total_out == [compressedData length])) {
			[compressedData increaseLengthBy:1024];
		}
		// Store location where next byte should be put in next_out
		zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
		// Calculate the amount of remaining free space in the output buffer
		// by subtracting the number of bytes that have been written so far
		// from the buffer's total capacity
		zlibStreamStruct.avail_out = (unsigned int)[compressedData length] - zlibStreamStruct.total_out;
        
		/* deflate() compresses as much data as possible, and stops/returns when
		 the input buffer becomes empty or the output buffer becomes full. If
		 deflate() returns Z_OK, it means that there are more bytes left to
		 compress in the input buffer but the output buffer is full; the output
		 buffer should be expanded and deflate should be called again (i.e., the
		 loop should continue to rune). If deflate() returns Z_STREAM_END, the
		 end of the input stream was reached (i.e.g, all of the data has been
		 compressed) and the loop should stop. */
		deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
	} while ( deflateStatus == Z_OK || deflateStatus == Z_BUF_ERROR );
    
	// Check for zlib error and convert code to usable error message if appropriate
	if (deflateStatus != Z_STREAM_END)
	{
		NSString *errorMsg = nil;
		switch (deflateStatus)
		{
			case Z_ERRNO:
				errorMsg = @"Error occured while reading file.";
				break;
			case Z_STREAM_ERROR:
				errorMsg = @"The stream state was inconsistent (e.g., next_in or next_out was NULL).";
				break;
			case Z_DATA_ERROR:
				errorMsg = @"The deflate data was invalid or incomplete.";
				break;
			case Z_MEM_ERROR:
				errorMsg = @"Memory could not be allocated for processing.";
				break;
			case Z_BUF_ERROR:
				errorMsg = @"Ran out of output buffer for writing compressed bytes.";
				break;
			case Z_VERSION_ERROR:
				errorMsg = @"The version of zlib.h and the version of the library linked do not match.";
				break;
			default:
				errorMsg = @"Unknown error code.";
				break;
		}
		NSLog(@"%s: zlib error while attempting compression: \"%@\" Message: \"%s\"", __func__, errorMsg, zlibStreamStruct.msg);
        
		// Free data structures that were dynamically created for the stream.
		deflateEnd(&zlibStreamStruct);
        
		return nil;
	}
	// Free data structures that were dynamically created for the stream.
	deflateEnd(&zlibStreamStruct);
	[compressedData setLength: zlibStreamStruct.total_out];
	NSLog(@"%s: Compressed file from %d KB to %d KB", __func__, [pUncompressedData length]/1024, [compressedData length]/1024);
    
	return compressedData;
}

+(NSString *)getCitycodeByCityname:(NSString *)cityName withProvince:(NSString *)provinceName{
    if(cityName == nil)return nil;
    NSError *error;
    NSData *CityCodeJson = [NSData dataWithContentsOfFile:[RORUtils getCityCodeJSon]];
    NSDictionary *citycodeDic = [NSJSONSerialization JSONObjectWithData:CityCodeJson options:NSJSONReadingMutableLeaves error:&error];
    //    weatherDic字典中存放的数据也是字典型，从它里面通过键值取值
    NSArray *citycodeList = [citycodeDic objectForKey:@"城市代码"];
    NSString * defaultCityCode = nil;
    for (int i=0; i<citycodeList.count; i++){
        NSDictionary *prov = [citycodeList objectAtIndex:i];
        NSArray *cityList = [prov objectForKey:@"市"];
        for (int j=0; j<cityList.count; j++){
            NSDictionary *city = [cityList objectAtIndex:j];
            NSString *name = [city valueForKey:@"市名"];
            if ([cityName rangeOfString:name].location != NSNotFound){
                return [city valueForKey:@"编码"];
            }
            if ([provinceName rangeOfString:name].location != NSNotFound){
                defaultCityCode = [city valueForKey:@"编码"];
            }
        }
    }
    return defaultCityCode;
}

+(NSString*)outputDistance:(double)distance{
    if (distance<1000){
        return [NSString stringWithFormat:@"%.0f m", round(distance)];
    }
    return [NSString stringWithFormat:@"%.2f km", distance/1000];
}

+(void)setFontFamily:(NSString*)fontFamily forView:(UIView*)view andSubViews:(BOOL)isSubViews
{
    if ([view isKindOfClass:[UILabel class]])
    {
        UILabel *lbl = (UILabel *)view;
        [lbl setFont:[UIFont fontWithName:fontFamily size:[[lbl font] pointSize]]];
    }
    
    if ([view isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)view;
        [btn.titleLabel setFont:[UIFont fontWithName:fontFamily size:[[btn.titleLabel font] pointSize]]];
    }
    
    if (isSubViews)
    {
        for (UIView *sview in view.subviews)
        {
            [self setFontFamily:fontFamily forView:sview andSubViews:YES];
        }
    }
}

+(void)listFontFamilies
{
    NSArray* familys = [UIFont familyNames];
    
    for (int i = 0; i<[familys count]; i++) {
        
        NSString* family = [familys objectAtIndex:i];
        
        NSLog(@"Fontfamily:%@=====",family);
        
        NSArray* fonts = [UIFont fontNamesForFamilyName:family];
        
        for (int j = 0; j<[fonts count]; j++) {
            
            NSLog(@"FontName:%@",[fonts objectAtIndex:j]);
            
        }
        
    }
}


@end
