//
//  CalculatorGraphView.h
//  Calculator
//
//  Created by Boyle, Patrick on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculatorGraphView;

@protocol GraphViewDataSource
-(float)YforXValue:(float)xValue inGraphView:(CalculatorGraphView *)sender;
-(void)storeScale:(float)scale ForGraphView: (CalculatorGraphView *)sender;

@end


@interface CalculatorGraphView : UIView

@property (nonatomic, weak) IBOutlet id <GraphViewDataSource> dataSource;
@property (nonatomic) CGPoint origin;
@property (nonatomic) CGFloat scale;
-(void)pinch:(UIPinchGestureRecognizer *)gesture; 

@end
