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

-(NSMutableArray *)getMutableProgram
{
    return [self.programStack mutableCopy];
    
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

+ (BOOL)isSingleOperation:(id)operation
{
    NSSet *mySet;
    NSString *sqrt=@"√";
    NSString *pi=@"π";
    NSString *sin=@"sin";
    NSString *cos=@"cos";
    mySet = [NSSet setWithObjects: sqrt,pi,sin,cos, nil];
    if ([mySet containsObject:operation]){
        return true;
        
    }
    return false;
}
+ (BOOL)isNoOperandOperation:(id)operation
{
    NSSet *mySet;
    NSString *pi=@"π";
    mySet = [NSSet setWithObjects: pi, nil];
    if ([mySet containsObject:operation]){
        return true;
    }
    return false;
}
+ (BOOL)isVariable:(id)operation
{
    NSSet *mySet;
    NSString *a=@"a";
    NSString *b=@"b";
    NSString *c=@"c";
    mySet = [NSSet setWithObjects: a,b,c, nil];
    if ([mySet containsObject:operation]){
        return true;
    }
    return false;
}

- (double)performOperation:(NSString *)operation
{
    [self.programStack addObject:operation];
    
    return [[self class] runProgram:self.program];
}

+ (double)runProgram:(id)program
{
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    return [self popOperandOffProgramStack:stack];
}


- (NSString *)getDescriptionOfProgram
{
    NSString *x = @"";
    NSMutableArray *y = [self getMutableProgram];
    x=[[self class] descriptionOfProgram:y];
    return x;
    NSLog(@"description is: %@",x);
}
     
+ (NSString *)descriptionOfProgram:(NSMutableArray *)stack
{
    NSMutableString *programFragment = [NSMutableString stringWithString:@""];
    NSLog(@"entering description of program with %@ ",[stack description]);
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject] ;
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        [programFragment appendFormat:@"%g",[topOfStack doubleValue]];
    }
    
    else if ([self isDoubleOperation: topOfStack])
    {
        NSString *firstOperand = [self descriptionOfProgram:stack];
        NSString *secondOperand = [self descriptionOfProgram:stack];
        [programFragment appendFormat:@"(%@ %@ %@)",secondOperand,topOfStack,firstOperand];
        
    } else if ([self isSingleOperation:topOfStack])
    {
        [programFragment appendFormat: @"(%@ %@)",topOfStack, [self descriptionOfProgram:stack]];
    } else if ([self isNoOperandOperation: topOfStack])
    {
        [programFragment appendFormat: @"%@",topOfStack];
    } else if ([self isVariable: topOfStack])
    {
        [programFragment appendFormat: @"%@",topOfStack];
    } else if ([stack count]){
        [programFragment appendFormat:@",",[self descriptionOfProgram:stack] ];        
    }

    
    
    //NSLog(@"%@",ret);
    return programFragment;
    
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
        } else if ([(@"√") isEqualToString:operation]){
            result = sqrt([self popOperandOffProgramStack:stack]);
        } else if ([@"π" isEqualToString:operation]){
            result = M_PI;
        }
    }
    return result;
        

}


@end
