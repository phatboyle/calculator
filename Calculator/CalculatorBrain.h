//
//  CalculatorBrain.h
//  Calculator
//
//  Created by Boyle, Patrick on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject
//- (void)pushOperand;
- (double)performOperation:(NSString *)operation;

@property (nonatomic, readonly) id program;
+ (NSString *)descriptionOfProgram:(id)program;
+ (double)runProgram:(id)program;
@end
