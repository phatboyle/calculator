//
//  CalculatorGraphViewController.m
//  Calculator
//
//  Created by Boyle, Patrick on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphViewController.h"
#import "CalculatorGraphView.h"
#import "CalculatorBrain.h"

@interface CalculatorGraphViewController () <GraphViewDataSource>
@property (nonatomic, weak) IBOutlet CalculatorGraphView *graphView;
@end

@implementation CalculatorGraphViewController

@synthesize graphView = _graphView;


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)setGraphView: (CalculatorGraphView *)graphView
{
    _graphView = graphView;
    [self.graphView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pinch:)]];
    
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.graphView action:@selector(pan:)];
    [panGesture setMaximumNumberOfTouches:2];
    [self.graphView addGestureRecognizer:panGesture];
     
}

-(float)YforXValue:(float)xValue inGraphView:(CalculatorGraphView *)sender{
    // Find the corresponding Y value by passing the x value to the calculator brain
    id yValue = [CalculatorBrain runProgram:self.program usingVariableValues:
                 [NSDictionary dictionalryWithObject:[NSNumber numberWithFloat:xValue]
                                              forKey:@"x"]];
    return ((NSNumber *)yValue).floatValue;
}

@end
