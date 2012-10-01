//
//  CalculatorViewController.h
//  Calculator
//
//  Created by Boyle, Patrick on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CalculatorViewController : UIViewController
@property (weak, nonatomic) UILabel *display;
@property (weak, nonatomic) IBOutlet UILabel *brainStatus;
@property (weak, nonatomic) IBOutlet UILabel *variableDisplay;

-(double) runProgram:(NSDictionary *)variables;

@end
