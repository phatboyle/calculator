//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Boyle, Patrick on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"
//#import "math.h"

@interface CalculatorBrain()
@property (nonatomic,strong) NSMutableArray *programStack;
@end


@implementation CalculatorBrain

@synthesize programStack = _programStack;

- (NSMutableArray *)programStack
{
    if (_programStack == nil) _programStack = [[NSMutableArray alloc] init];
    return _programStack;
}

-(id)program
{
    return [self.programStack copy];
}

-(void)pushOperand
{
    
}
-(void)test{
    
}



- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}
     
+ (NSString *)descriptionOfProgram:(id)program
{
    return @"Implement this in Homework #2";
}
     

+ (double)popOperandOffProgramStack:(NSMutableArray *)stack
{
    double result=0;
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        result = [topOfStack doubleValue];
    }
    else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        
        if ([operation isEqualToString:@"+"]){
            result=[self popOperandOffProgramStack:stack] + [self popOperandOffProgramStack:stack];
        } else if ([@"*" isEqualToString:operation]){
            result=[self popOperandOffProgramStack:stack] * [self popOperandOffProgramStack:stack];
        } else if ([@"-" isEqualToString:operation]){
            double subtrahend = [self popOperandOffProgramStack:stack];
            result = [self popOperandOffProgramStack:stack] - subtrahend;
        } else if ([@"/" isEqualToString:operation]){
            double divisor = [self popOperandOffProgramStack:stack];
            if (divisor) result = [self popOperandOffProgramStack:stack]/divisor;
        } else if ([@"sin" isEqualToString:operation]){
            result = sin([self popOperandOffProgramStack:stack]);
        } else if ([@"cos" isEqualToString:operation]){
            result = cos([self popOperandOffProgramStack:stack]);
        } else if ([(@"sqrt") isEqualToString:operation]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([@"pi" isEqualToString:operation]){
            double PI = M_PI;
            [self pushOperand];
            result = [self popOperandOffProgramStack:stack];
        }    
    }    
        return result;
        
}


+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}
@end
