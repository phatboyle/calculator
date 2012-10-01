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
@synthesize dataSource = _dataSource;

#define DEFAULT_SCALE 1;

- (void)setup
{
    //NSLog(@"entering setup");
    self.contentMode = UIViewContentModeRedraw;
    self.origin = CGPointMake(0,0);
    self.scale = DEFAULT_SCALE;
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

- (void)setOrigin:(CGPoint)origin{
    if(_origin.x == origin.x && _origin.y == origin.y) return;
    _origin=origin;
    [self setNeedsDisplay];
}

-(CGPoint)origin{
    if (!_origin.x && !_origin.y){
        _origin.x = self.bounds.origin.x + self.bounds.size.width/2;
        _origin.y = self.bounds.origin.y + self.bounds.size.height/2;
    }
    return _origin;
}


-(void)setScale:(CGFloat)scale
{
    if (scale != _scale){
        _scale = scale;
        [self setNeedsDisplay];
    }

}

-(CGFloat)scale{
    if (!_scale) _scale = DEFAULT_SCALE;
    return _scale;
}

- (CGPoint) convertToGraphCoordinateFromViewCoordinate:(CGPoint)coordinate
{
    CGPoint graphCoordinate;
    graphCoordinate.x=(coordinate.x - self.origin.x)/self.scale;
    graphCoordinate.y=(self.origin.y - coordinate.y)/self.scale;
    return graphCoordinate;
}



- (CGPoint) convertToViewCoordinateFromGraphCoordinate:(CGPoint)coordinate
{
    CGPoint viewCoordinate;
    CGFloat s = self.scale; // test
    viewCoordinate.x = (coordinate.x * self.scale) + self.origin.x;
    viewCoordinate.y = self.origin.y - (coordinate.y * self.scale);
    NSLog(@"%f, %f, %f, %f, %f", s, coordinate.x, viewCoordinate.x, coordinate.y, viewCoordinate.y);

    return viewCoordinate;
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat size = self.bounds.size.width/2;
    if (self.bounds.size.height < self.bounds.size.width) size = self.bounds.size.height /2;
    size *= self.scale;
    
    CGContextSetLineWidth(context, 1.0);
    [AxesDrawer drawAxesInRect:self.bounds originAtPoint:self.origin scale:self.scale];
    CGFloat csf = self.contentScaleFactor; // test
    CGContextBeginPath(context);
    
    CGPoint o = self.origin;  // test

    CGFloat startingX = - self.origin.x;
    CGFloat endingX = startingX + self.bounds.size.width;
    CGFloat increment = 1/self.contentScaleFactor;
    
    BOOL firstPoint = YES;
    
    for (CGFloat x = startingX; x<= endingX; x+= increment){
        CGPoint coordinate;
        coordinate.x = x;
        coordinate = [self convertToGraphCoordinateFromViewCoordinate:coordinate];
        coordinate.y = [self.dataSource YforXValue:coordinate.x inGraphView:self];
        coordinate = [self convertToViewCoordinateFromGraphCoordinate:coordinate];
        coordinate.x=x;
        
        
        
    
        if(firstPoint){
            CGContextMoveToPoint(context, coordinate.x, coordinate.y);
            firstPoint = NO;
        }
        CGContextAddLineToPoint(context, coordinate.x, coordinate.y);
       // NSLog(@"%f, %f", coordinate.x, coordinate.y);
    }

}

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    //NSLog(@"in gesture");
    
    if ((gesture.state==UIGestureRecognizerStateChanged)|| (gesture.state == UIGestureRecognizerStateEnded)){
        self.scale *= gesture.scale;
        gesture.scale=1;
    }
}

- (void)pan:(UIPanGestureRecognizer *)gesture
{
    //NSLog(@"in pan");
    if ((gesture.state == UIGestureRecognizerStateChanged)||(gesture.state == UIGestureRecognizerStateEnded))
    {
        CGPoint translation = [gesture translationInView:self];
        
        // move the origin of the graph
        CGPoint axisOrigin = CGPointMake(self.origin.x + translation.x, self.origin.y + translation.y);
        self.origin = axisOrigin;
        [gesture setTranslation:CGPointZero inView:self];
    }
}

// set up delegates
// draw graph
// ipad

//http://www.i4-apps.com/assignment-3-required-tasks/#more-507
//https://github.com/jpoetker/cs193p-graphing-calculator/tree/master/GraphingCalculator



@end
