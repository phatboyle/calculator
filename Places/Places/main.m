//
//  main.m
//  Places
//
//  Created by Pat Boyle on 10/7/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PlacesAppDelegate.h"
#import "FlickrFetcher.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        // get array of images
        NSArray *fetched = [FlickrFetcher topPlaces];
        
        NSLog(@"Number of images %d", [fetched count]);
        NSLog(@"Type of object %@", NSStringFromClass([[fetched objectAtIndex:(0)] class]));
        NSLog(@"The description of the first object is %@", [[fetched objectAtIndex:0] description]);
        NSLog(@"TopPlaces is an array of type %@", NSStringFromClass([[fetched objectAtIndex:0] class]));
        //NSDictionary *first = [fetched objectAtIndex:0];
        //NSLog(@"The location of the first object is %@", [[first valueForKeyPath ]:description._content]);
        
        
        
        
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([PlacesAppDelegate class]));
    }
}
