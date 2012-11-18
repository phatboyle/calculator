//
//  DiskCache.m
//  Places
//
//  Created by Boyle, Patrick on 10/19/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import "DiskCache.h"

// TODO: trim cache
// put in logging
// check dir:  ~/library/application support/iphone simulator

#define MAX_CACHE_SIZE 2000000


@implementation DiskCache

static NSURL *cacheURL;

+ (NSFileManager *) filemanager {
    NSFileManager * fm = [[NSFileManager alloc] init];
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
    return [NSURL URLWithString:filename relativeToURL:[self cachesUrl]];
}



+(void) storeData: (NSString *) key: (NSData *) data {
    //TODO: if the file is already there then don't write anything
    [self trimCache];
    NSLog(@"%@",[[self getUrlForFile:key]absoluteString]);
    if (![[self filemanager] fileExistsAtPath:[[self getUrlForFile:key] absoluteString] ]){
        [data writeToURL:[self getUrlForFile:key] atomically:YES];
    }
    // in addition, check to see how many files are there
    
}

+(void) trimCache
{
    NSArray* URLsCacheArray = [[self filemanager] contentsOfDirectoryAtURL:[self cachesUrl] includingPropertiesForKeys:[NSArray arrayWithObjects:NSURLNameKey, NSURLIsDirectoryKey, NSURLCreationDateKey, NSFileSize, nil] options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
    // get array
    // count up the file sizes
    // if sum of file sizes is > 10 megs, delete oldest
    
    int cachesize = 0;
    for (NSURL *url in URLsCacheArray){
        NSError* error = nil;
        if ([[self filemanager] fileExistsAtPath:url.path]){
            NSLog(@"file exists");
        }
        cachesize += [[[[self filemanager] attributesOfItemAtPath:url.path error:&error] valueForKey:NSFileSize] integerValue];
        if (error){
            NSLog(@"%@", error);
        }
    }
    
    NSLog(@"cachesize is %d", cachesize);
    
    
    if (MAX_CACHE_SIZE < cachesize){
        URLsCacheArray = [URLsCacheArray sortedArrayUsingComparator:^(id item1, id item2) {
            NSDate* d1 = [[[self filemanager] attributesOfItemAtPath:[item1 path] error:nil] valueForKey:NSFileSize];
            NSDate* d2 = [[[self filemanager] attributesOfItemAtPath:[item2 path] error:nil] valueForKey:NSFileSize];
            
            return [d2 compare:d1];
            
        }];
        // now we have a sorted array
        
        NSMutableArray* URLsArray = [NSMutableArray arrayWithArray:URLsCacheArray];
        
        NSLog(@"found %d files in cache", [URLsArray count]);
        NSLog(@"list of urls: %@", URLsArray);
        
        while (MAX_CACHE_SIZE < cachesize && URLsCacheArray.count > 0) {
            NSURL* url = [URLsArray lastObject];
            NSError* error=nil;
            NSDictionary* fileAttributes= [[self filemanager] attributesOfItemAtPath:url.path error:&error];
            NSLog(@"%@", fileAttributes);
            
            if (error)
            {
                NSLog(@"%@", error);
            }
            
            
            if ([fileAttributes valueForKey:url.path] == NSFileTypeRegular){
                NSError* error=nil;
                [[self filemanager] removeItemAtURL:url error:&error];
                if (error){
                    NSLog(@"%@", error);    // this needs to be made safer
                } else {
                cachesize -= [[fileAttributes valueForKey:NSFileSize] intValue];
                [URLsArray removeLastObject];
                NSLog(@"removed object of size %d",[[fileAttributes valueForKey:NSFileSize] intValue] );
                    
                }
            
            }
            
            
        }
    }
    
    
}


+(NSData *) fetchData:(NSString *)key{
    return [NSData dataWithContentsOfURL:[self getUrlForFile:key]];
    
}

@end
