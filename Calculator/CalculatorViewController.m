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
@synthesize variableDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain
{
    if (!_brain) _brain=[[CalculatorBrain alloc]init];
    return _brain;
}

- (void)updateBrainStatus:(NSString *) s {
    //NSLog(@"updateBrainStatus %@", s);
    // self.brainStatus.text = [[self.brainStatus.text stringByAppendingString: @" "] stringByAppendingString:s];
    self.brainStatus.text = [s description];
    
}

- (IBAction)undoPressed {
    NSLog(@"undoPressed");
    if ([self.display.text length]< 1){
        self.userIsInTheMiddleOfEnteringANumber = NO;
        [self.brain popOffProgramStack];
    }

    if (userIsInTheMiddleOfEnteringANumber){
        self.display.text = [self.display.text substringToIndex:[self.display.text length]-1];
        [self.brain popOffProgramStack];
    } else {
        [self.brain popOffProgramStack];

    }
    
    [self operationPressed:nil];    // rerun with variables
}


- (IBAction)testPressed:(UIButton *)sender {
    //NSLog(@"entering testPressed:sender");
    //NSLog(@"sender string is: %@", [sender currentTitle]);
    if ([[sender currentTitle] isEqualToString:@"Test1"]){
        [self.brain setVariableDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:1],@"x",[NSNumber numberWithInt:2],@"y", nil]];
    //    NSLog(@"Test1 pressed");
    }
    if ([[sender currentTitle] isEqualToString:@"Test2"]){
        [self.brain setVariableDictionary:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:5],@"x",[NSNumber numberWithInt:10],@"y", nil]];       
    //    NSLog(@"Test2 pressed");
    }
    
    [self operationPressed:nil];
    
}


- (IBAction)digitPressed:(UIButton *)sender {
    NSString *digit= [sender currentTitle];
    if (self.userIsInTheMiddleOfEnteringANumber){
       // NSLog(@"User touched %@", digit);
        self.display.text = [self.display.text stringByAppendingString:digit];
        
    }else {
        self.display.text = digit;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
    
}
- (IBAction)enterPressed {
    //NSLog(@"arrived enterPressed");
    [self.brain pushOperand:[self.display.text doubleValue]];
    self.userIsInTheMiddleOfEnteringANumber = NO;
    
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
    if (self.userIsInTheMiddleOfEnteringANumber) {
        [self enterPressed ];
    }
    double result=0;
    if (sender){
        NSString *operation = [sender currentTitle];        
        result = [self.brain performOperation:operation];

    } else {
        result = [self.brain performOperation:nil];

    }
    
    
    // update description
    NSString *descriptionString = [self.brain getDescriptionOfProgram];
    NSLog(@"controller description is %@ ",descriptionString);
    [self updateBrainStatus:[descriptionString description]];
    
    // update result
    self.display.text = [NSString stringWithFormat:@"%g", result];
    
    // update variables display
    NSString *variablesString = [self.brain getVariablesUsedInProgram];
    self.variableDisplay.text= variablesString;
    
}

- (void)viewDidUnload {
    [self setBrainStatus:nil];
    [self setBrainStatus:nil];
    [self setVariableDisplay:nil];
    [super viewDidUnload];
}
@end
