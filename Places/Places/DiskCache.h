//
//  DiskCache.h
//  Places
//
//  Created by Boyle, Patrick on 10/19/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DiskCache : NSObject


+ (NSData *) fetchData:  (NSString *) key;

+ (void) storeData: (NSString *) key: (NSData *) data;



// need to create if not created already
// index by photoID, put in photo data


// storeData

// private method  to clean up cache (less than 10 megs)

@end

/*
 {
 accuracy = 11;
 context = 0;
 dateupload = 1350635517;
 description =     {
 "_content" = "";
 };
 farm = 9;
 "geo_is_contact" = 0;
 "geo_is_family" = 0;
 "geo_is_friend" = 0;
 "geo_is_public" = 1;
 id = 8102171803;
 isfamily = 0;
 isfriend = 0;
 ispublic = 1;
 latitude = "44.659111";
 longitude = "-1.164299";
 owner = "94657696@N00";
 ownername = problog;
 "place_id" = "x6cAkmdUVbwB_jA";
 secret = 46948ca064;
 server = 8049;
 tags = "france dune du mariage arcachon pyla pylasurmer";
 title = "Wedding @Arcachon";
 woeid = 576420;
 }
*/
