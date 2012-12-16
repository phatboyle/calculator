//
//  DestinationTableViewController.h
//  Places
//
//  Created by Boyle, Patrick on 10/13/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DestinationTableViewController : UITableViewController
-(void)setPhotoList: (NSArray *)photoList withTitle:(NSString *)title;
@property (nonatomic, strong) NSArray *photos;

@end
