//
//  CalculatorViewController.m
//  Calculator
//
//  Created by Boyle, Patrick on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"


@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@end

@implementation CalculatorViewController

@synthesize display;
@synthesize brainStatus;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain=[[CalculatorBrain alloc]init];
    return _brain;
}

- (void)updateBrainStatus:(NSString *) s {
    NSLog(@"updateBrainStatus %@", s);
    self.brainStatus.text = [[self.brainStatus.text stringByAppendingString: @" "] stringByAppendingString:s];
    
}

- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit= [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber){
        NSLog(@"User touched %@", digit);
        self.display.text = [self.display.text stringByAppendingString:digit];
        
    }else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}
- (IBAction)enterPressed {
    NSLog(@"arrived enterPressed");
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    [self updateBrainStatus:self.display.text];
    
}
- (IBAction)decimalPressed {
    NSRange range = [self.display.text rangeOfString:@"."]; // check if decimal is already entered
    if (range.location == NSNotFound) { 
    if (self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text stringByAppendingString:@"."];
        
    }else {
        self.display.text = @".";
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    }
}

- (IBAction)clearPressed {
    self.display.text=@"0";
    [self.brain clearOperands];
    self.brainStatus.text=@"";
}


- (IBAction)operationPressed:(id)sender 
{
    NSLog(@"operationPressed %@ ", [sender currentTitle] );
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed ];
    }
    [self updateBrainStatus:[sender currentTitle]];

    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (void)viewDidUnload {
    [self setBrainStatus:nil];
    [self setBrainStatus:nil];
    [super viewDidUnload];
}
@end
