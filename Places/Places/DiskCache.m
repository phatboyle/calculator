//
//  DiskCache.m
//  Places
//
//  Created by Boyle, Patrick on 10/19/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import "DiskCache.h"

// trim cache
// put in logging


@implementation DiskCache

static NSURL *cacheURL;

+ (NSFileManager*) filemanager {
    NSFileManager* fm = [[NSFileManager alloc] init];
    return fm;
}


+(NSURL *) cachesUrl {
    if (!cacheURL){
        NSArray * cachesArray = [[self filemanager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask];
        
        cacheURL = [cachesArray lastObject];
    }
    return cacheURL;
}

+ (NSURL *) getUrlForFile: (NSString *) filename {
    return [NSURL URLWithString:filename relativeToURL:cacheURL];
}



+(void) storeData: (NSString *) key: (NSData *) data {
    [data writeToURL:[self getUrlForFile:key] atomically:YES];
    
}

+(NSData *) fetchData:(NSString *)key{
    return [NSData dataWithContentsOfURL:[self getUrlForFile:key]];
    
}

@end
