//
//  CalculatorBrain.m
//  Calculator
//
//  Created by Boyle, Patrick on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

-(void)pushOperand:(double)operand
{
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (void)clearOperands
{
    NSNumber *operandObject = [self.programStack lastObject];
    if (operandObject) {
        [self.programStack removeLastObject];
        NSLog(@"clearOperands %@",operandObject);
        [self clearOperands];  
        
    }
    
}

+ (BOOL)isDoubleOperation:(id)operation
{
    NSSet *mySet;
    NSString *plus= @"+";
    NSString *minus=@"-";
    NSString *multiply=@"*";
    NSString *divide=@"/";
    
    mySet = [NSSet setWithObjects: plus,minus,multiply,divide,nil];
    
    if ([mySet containsObject:operation] ){
        return TRUE;
    }
    return FALSE;
    
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    return [[self class] runProgram:self.program];
}
     
+ (NSString *)descriptionOfProgram:(id)program
{
    // test if operand using the operand helper
    NSMutableArray *a = [NSMutableArray arrayWithCapacity:0];
    NSString *ret = [NSString stringWithString:@""];
    // NSLog(@"entering description of program with %@",[program description]);
    
    id item = [self popOperand:program];
    if ([item isKindOfClass:[NSNumber class]]){
        NSLog(@"adding number %@",item);
        [a addObject:item];
    }
    if ([self isDoubleOperation: item]){
        NSMutableArray *b = [NSMutableArray arrayWithCapacity:0];
        [b addObject:[self descriptionOfProgram:program]];
        [b addObject:item];
        [b addObject:[self descriptionOfProgram:program]];
        [a addObject:b];
    
        
        
    }
    
    ret = [a description];
    NSLog(@"%@",ret);
    return ret;
    // assemble the pieces and return a string
    
}

+ (id)popOperand:(id)program    // this should pop an operand off the stack
{
    id topOfStack = [program lastObject];
    if (topOfStack) [program removeLastObject];
    return topOfStack;
}




// need a method to check what type of operand has been popped
// use NSSet.  If sqrt, then you would need to know 1.  If + you would need to know 2
// NSSet needs to be populated with the right information
// the key should be an NSString object and the value should be a number

//


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
        } else if ([(@"√") isEqualToString:operation]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([@"π" isEqualToString:operation]){
            result = M_PI;
        }
    }
        return result;
        

}


+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    NSMutableArray *stackForDescription;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
        stackForDescription = [program mutableCopy];
        NSLog([stackForDescription description]);
    }
    NSString *programDescription = [NSString stringWithString:@""];
    programDescription = [self descriptionOfProgram:stackForDescription];   
    
    
    return [self popOperandOffProgramStack:stack];
}
@end
