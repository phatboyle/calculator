//
//  ImageViewController.h
//  Places
//
//  Created by Boyle, Patrick on 10/13/12.
//  Copyright (c) 2012 Pat Boyle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewController : UIViewController

@property (nonatomic, strong) NSDictionary *photoDict;
-(void)setImagex:(NSDictionary *)pd withTitle:(NSString *)title;

@end
