//
//  CalculatorGraphView.m
//  Calculator
//
//  Created by Boyle, Patrick on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorGraphView.h"
#import "AxesDrawer.h"

@implementation CalculatorGraphView

@synthesize scale = _scale;
@synthesize origin = _origin;

#define DEFAULT_SIZE 26;

- (void)setup
{
    NSLog(@"entering setup");
    self.contentMode = UIViewContentModeRedraw;
    self.origin = CGPointMake(0,0);
    self.scale = DEFAULT_SIZE;
}

- (void)awakeFromNib    // storyboard initialization
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame   // not called from storyboard
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void)setScale:(CGFloat)scale
{
    if (scale != _scale){
        _scale = scale;
        [self setNeedsDisplay];
    }

}


- (void)drawRect:(CGRect)rect
{
    NSLog(@"in drawRect");
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGPoint midPoint;
    midPoint.x = self.bounds.origin.x + self.bounds.size.width/2;
    midPoint.y = self.bounds.origin.y + self.bounds.size.height/2;
    
    CGFloat size = self.bounds.size.width/2;
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height /2;
    size *= self.scale;

    CGContextSetLineWidth(context, 1.0);
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:midPoint scale:self.scale*self.contentScaleFactor];


}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    NSLog(@"in gesture");
    
    if ((gesture.state==UIGestureRecognizerStateChanged)|| (gesture.state == UIGestureRecognizerStateEnded)){
        self.scale *= gesture.scale;
        gesture.scale=1;
    }
}

// put in gesture recognizer for zoom

// put in graphing features



@end
