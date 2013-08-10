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

static NSNumber *userId = nil;

static NSDate *systemTime = nil;

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

+ (NSString *)transSecondToStandardFormat:(NSInteger) seconds {
    NSInteger min=0, hour=0;
    min = seconds / 60;
    seconds = seconds % 60;
    hour = min / 60;
    min = min % 60;
    return [NSString stringWithFormat:@"%.2d:%.2d:%.2d",hour, min, seconds];
}

+ (NSString *)toJsonFormObject:(NSObject *)object{
    SBJsonWriter *writer = [[SBJsonWriter alloc] init];
    NSString *regStr = [writer stringWithObject:object];
    return regStr;
}

+ (NSNumber *)getUserId{
    if (userId == nil || userId < 0){
        NSMutableDictionary *userDict = [self getUserInfoPList];
        userId = [userDict valueForKey:@"userId"];    }
    return userId;
}

+(NSDate *)getSystemTime{
    if (systemTime == nil){
        NSMutableDictionary *userDict = [self getUserInfoPList];
        systemTime = [userDict valueForKey:@"systemTime"];    }
    return systemTime;
}

+ (void)resetUserId{
    userId = [[NSNumber alloc] initWithInt:-1];
}

+ (NSString*)getCityCodeJSon{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"CityCode" ofType:@"geojson"];
    return path;
}

+ (NSString*)getUserSettingsPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    return [docPath stringByAppendingPathComponent:@"userSettings.plist"];
}

+ (NSString *)hasLoggedIn{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *name = [userDict valueForKey:@"nickName"];
    
    if (!([name isEqual:@""] || name == nil))
        return name;
    else
        return nil;
}

+(NSString *)getCurrentTime{
    NSDateFormatter *formate = [[NSDateFormatter alloc] init];
    [formate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *formatDateString = [formate stringFromDate:[NSDate date]];
    return formatDateString;
}

+ (NSMutableDictionary *)getUserInfoPList{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *userDict = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    if (userDict == nil)
        userDict = [[NSMutableDictionary alloc] init];
    
    return userDict;
}

+ (void)writeToUserInfoPList:(NSDictionary *) userDict{
    NSArray *doc = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [ doc objectAtIndex:0 ];
    NSString *path = [docPath stringByAppendingPathComponent:@"userInfo.plist"];
    NSMutableDictionary *pInfo = [self getUserInfoPList];
    [pInfo addEntriesFromDictionary:userDict];
    [pInfo writeToFile:path atomically:YES];
}

+ (void)saveLastUpdateTime: (NSString *) key{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *systemTime = (NSString *)[userDict objectForKey:@"systemTime"];
    [userDict setValue:systemTime forKey:key];
    [self writeToUserInfoPList:userDict];
}

+ (NSString *)getLastUpdateTime: (NSString *) key{
    NSMutableDictionary *userDict = [self getUserInfoPList];
    NSString *lastUpdateTime = (NSString *)[userDict objectForKey:key];
    if(lastUpdateTime == nil){
        lastUpdateTime = @"2000-01-01 00:00:00";
    }
    return lastUpdateTime;
}

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query{
    NSError *error;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query argumentArray:params];
    [fetchRequest setPredicate:predicate];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return fetchObject;
}

+(NSArray *)fetchFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query withOrderBy:(NSArray *) sortParams{
    NSError *error;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query argumentArray:params];
    [fetchRequest setPredicate:predicate];
    [fetchRequest setSortDescriptors:sortParams];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    if (fetchObject == nil || [fetchObject count] == 0) {
        return nil;
    }
    return fetchObject;
}

+(void)deleteFromDelegate:(NSString *) tableName withParams:(NSArray *) params withPredicate:(NSString *) query{
    NSError *error;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
    
    [fetchRequest setEntity:entity];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:query argumentArray:params];
    [fetchRequest setPredicate:predicate];
    NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *info in fetchObject) {
        [context deleteObject:info];
    }
    //保存修改
    [context save:&error];
}

+ (void)clearTableData:(NSArray *) tableArray{
    NSError *error;
    RORAppDelegate *delegate = (RORAppDelegate *)[[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = delegate.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc]init];
    
    for(NSString *table in tableArray){
        NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:context];
        [fetchRequest setEntity:entity];
        NSError *error = nil;
        NSArray *fetchObject = [context executeFetchRequest:fetchRequest error:&error];
        for (NSManagedObject *info in fetchObject) {
            [context deleteObject:info];
        }
    }
    //保存修改
    [context save:&error];
}

+ (NSData*) gzipCompressData: (NSData*)uncompressedData  {
    
    if (!uncompressedData || [uncompressedData length] == 0)
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
	zlibStreamStruct.next_in   = (Bytef*)[uncompressedData bytes]; // Pointer to input bytes
	zlibStreamStruct.avail_in  = [uncompressedData length]; // Number of input bytes left to process
    
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
	NSMutableData *compressedData = [NSMutableData dataWithLength:[uncompressedData length] * 1.01 + 12];
    
	int deflateStatus;
	do
	{
		// Store location where next byte should be put in next_out
		zlibStreamStruct.next_out = [compressedData mutableBytes] + zlibStreamStruct.total_out;
        
		// Calculate the amount of remaining free space in the output buffer
		// by subtracting the number of bytes that have been written so far
		// from the buffer's total capacity
		zlibStreamStruct.avail_out = [compressedData length] - zlibStreamStruct.total_out;
        
		/* deflate() compresses as much data as possible, and stops/returns when
		 the input buffer becomes empty or the output buffer becomes full. If
		 deflate() returns Z_OK, it means that there are more bytes left to
		 compress in the input buffer but the output buffer is full; the output
		 buffer should be expanded and deflate should be called again (i.e., the
		 loop should continue to rune). If deflate() returns Z_STREAM_END, the
		 end of the input stream was reached (i.e.g, all of the data has been
		 compressed) and the loop should stop. */
		deflateStatus = deflate(&zlibStreamStruct, Z_FINISH);
        
	} while ( deflateStatus == Z_OK );
    
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
	NSLog(@"%s: Compressed file from %d KB to %d KB", __func__, [uncompressedData length]/1024, [compressedData length]/1024);
    
	return compressedData;
}

@end
