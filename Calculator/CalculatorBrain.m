//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Boyle, Patrick on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic,strong) NSMutableArray *operandStack;
@end


@implementation CalculatorBrain

@synthesize operandStack=_operandStack;
- (NSMutableArray *)operandStack
{
    if (_operandStack == nil){
        _operandStack = [[NSMutableArray alloc] init ];
    }
    return _operandStack;
}

- (void)setOperandStack:(NSMutableArray *)anArray
{
    _operandStack=anArray;
}

- (void)pushOperand:(double)operand
{
    NSNumber *operandObject = [NSNumber numberWithDouble:operand];
    [self.operandStack addObject:operandObject];
}

- (double)popOperand
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}
- (void)clearOperands
{
    NSNumber *operandObject = [self.operandStack lastObject];
    if (operandObject) {
        [self.operandStack removeLastObject];
        NSLog(@"clearOperands %@",operandObject);
        [self clearOperands];  
        
    }
    
}


- (double)performOperation:(NSString *)operation
{
    double result=0;
    if ([operation isEqualToString:@"+"]){
        result=[self popOperand] + [self popOperand];
    } else if ([@"*" isEqualToString:operation]){
        result=[self popOperand] * [self popOperand];
    } else if ([@"-" isEqualToString:operation]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if ([@"/" isEqualToString:operation]){
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand]/divisor; 
    } else if ([@"sin" isEqualToString:operation]){
        result = sin([self popOperand]);
    } else if ([@"cos" isEqualToString:operation]){
        result = cos([self popOperand]);
    } else if ([(@"sqrt") isEqualToString:operation]){
        result = sqrt([self popOperand]);
    } 
//    else if ([@"pi" isEqualToString:operation]){
//        double PI = [@"3.1415927" doubleValue];
//        [self pushOperand:PI];
//        result = [self popOperand];
//}
    
    
    [self pushOperand:result];
    return result;
    
}

@end
