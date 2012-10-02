//
//  CalculatorGraphViewController.m
//  Calculator
//
//  Created by Boyle, Patrick on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphViewController.h"
#import "CalculatorGraphView.h"
#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorGraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet CalculatorGraphView *graphView;
@property (nonatomic, weak) CalculatorViewController *calculatorViewController;
@end

@implementation CalculatorGraphViewController

@synthesize graphView = _graphView;
@synthesize calculatorViewController=_calculatorViewController;
@synthesize program=_program;

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation // todo change fofr rotation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setGraphView: (CalculatorGraphView *)graphView
{
    _graphView = graphView;
    self.graphView.dataSource = self;
    
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)];
    [panGesture setMaximumNumberOfTouches:2];
    [self.graphView addGestureRecognizer:panGesture];
    
    [self refreshGraphViewProperties];
     
}

-(void) setProgram:(id)program {
    _program = program;
    self.title = [NSString stringWithFormat:@"y = %@", [CalculatorBrain descriptionOfProgram: self.program]];
    [self refreshGraphViewProperties];
                  
}

- (void) refreshGraphViewProperties {
    if (!self.program) return;
    if (!self.graphView) return;
//    NSString *program = [CalculatorBrain descriptionOfProgram: self.program];
    
    [self.graphView setNeedsDisplay];
}

-(void)storeScale:(float)scale ForGraphView:(CalculatorGraphView *)sender {
    [[NSUserDefaults standardUserDefaults] setFloat:scale  forKey:[@"scale." stringByAppendingString:[CalculatorBrain descriptionOfProgram:self.program]]];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


-(float)YforXValue:(float)xValue inGraphView:(CalculatorGraphView *)sender{
    
    NSDictionary *variables = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:xValue] forKey:@"x"];
    CGFloat yValue = [CalculatorBrain runProgram:self.program usingVariableValues:variables];
    return yValue;
}


/*
-(float)YforXValue:(float)xValue inGraphView:(CalculatorGraphView *)sender{
    
    NSDictionary *variables = [NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:xValue] forKey:@"x"];
    CGFloat Yresult = [self.calculatorViewController runProgram:variables];
    return Yresult;
}
 */

@end
