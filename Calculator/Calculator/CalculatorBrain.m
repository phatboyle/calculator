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
@property (nonatomic) NSDictionary *variableDictionary;
@end



@implementation CalculatorBrain

@synthesize variableDictionary=_variableDictionary;

@synthesize programStack = _programStack;

- (void)setVariableDictionary:(NSDictionary *)variableDictionary
{
    _variableDictionary = [variableDictionary copy];
    
}

- (NSDictionary *)variableDictionary{
    if (_variableDictionary == nil) {
        _variableDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],@"x",[NSNumber numberWithInt:0],@"y", nil];
    }
    return _variableDictionary;
}

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

+ (BOOL)isSingleOperandOperation:(id)operation
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
    mySet = [NSSet setWithObjects: @"x",@"y", nil];
    if ([mySet containsObject:operation]){
        return true;
    }
    return false;
}

- (double)performOperation:(NSString *)operation
{
    if (operation){
        [self.programStack addObject:operation];
    }
    double x = [[self class] 
                runProgram:self.program 
                usingVariableValues: self.variableDictionary];
    NSLog(@"returning from performOperation with %g", x);
    return x;
}


+ (double)runProgram:(id)program
{
    //NSLog(@"entering runProgram with %@ ", program);
    NSMutableArray *stack;
    if ([program isKindOfClass:[NSArray class]]) {
        stack = [program mutableCopy];
    }
    //NSLog(@"runProgram: %@", stack);
    
    double x=[self popOperandOffProgramStack:stack]; 
    //NSLog(@"returning from runProgram with: %g",x);
    return x;
}

+ (double)runProgram:(id)program
                    usingVariableValues:(NSDictionary *)variableValues
{
    //NSLog(@"entering runProgram with variables with %@ ", program);
    NSMutableArray *stack = [[NSMutableArray alloc]init]; 
        for (id x in program){
            if ([variableValues objectForKey:[x description]])
            {
                [stack addObject:[variableValues objectForKey:[x description]]];
            } else {
                [stack addObject:x];
            }
        }
    //NSLog(@"exiting runProgram with variables with %@ ",stack);
    return [self runProgram: stack];
    
}


+ (NSSet *)variablesUsedInProgram:(id)program;
{
    // iterate through the program and return a set of strings that are the variables
    NSMutableSet *variables = [NSMutableSet setWithObjects:nil];
    for (id x in program){
        if ([x isKindOfClass:[NSNumber class]]){
            continue;
        }
        else if (([self isNoOperandOperation:x]) || ([self isSingleOperandOperation:x ] || ([self isDoubleOperation:x]))) {
            continue;
        } else {
            [variables addObject:x];
        }
    }
    NSLog(@"variablesUsedInProgram: %@",variables);
    if ([variables count] > 1){
        return [[NSSet class] setWithSet:variables];
    } else {
        return nil;
    }
}

- (NSString *)getVariablesUsedInProgram{
    NSDictionary *dict = self.variableDictionary;
    NSMutableString *variablesString = [[NSMutableString alloc]init ];
    for (id key in dict){
        id value= [dict objectForKey:key];
        [variablesString appendFormat:@"%@=%@ ",key,value]; 
        }
        
    
    return variablesString;
}

- (NSString *)getDescriptionOfProgram
{
    NSString *x = @"";
    NSMutableArray *y = [self getMutableProgram];
    x=[[self class] descriptionOfProgram:y];
    return x;
    NSLog(@"description is: %@",x);
}
     
+ (NSString *)descriptionOfProgram:(id)stack
{
    NSMutableString *programFragment = [[NSMutableString alloc]init];
    NSLog(@"entering CalculatorBrain:descriptionOfProgram with %@ ",[stack description]);
    
    if (![stack isKindOfClass:[NSArray class]]){
        NSLog(@"descriptionOfProgram:stack was nil, exiting");
        return Nil; // TODO
    }
    
    NSMutableArray *s = [stack mutableCopy];
    
    id topOfStack = [s lastObject];
    if (topOfStack) [s removeLastObject];
    
    if ([topOfStack isKindOfClass:[NSNumber class]])
    {
        [programFragment appendFormat:@"%g",[topOfStack doubleValue]];
    }
    
    else if ([self isDoubleOperation: topOfStack])
    {
        NSString *firstOperand = [self descriptionOfProgram:stack];
        NSString *secondOperand = [self descriptionOfProgram:stack];
        [programFragment appendFormat:@"(%@ %@ %@)",secondOperand,topOfStack,firstOperand];
        
    } else if ([self isSingleOperandOperation:topOfStack])
    {
        [programFragment appendFormat: @"(%@ %@)",topOfStack, [self descriptionOfProgram:stack]];
    } else if ([self isNoOperandOperation: topOfStack])
    {
        [programFragment appendFormat: @"%@",topOfStack];
    } else if ([self isVariable: topOfStack])
    {
        [programFragment appendFormat: @"%@",topOfStack];
    } else if ([stack count]){
        [programFragment appendFormat:@"%@",[self descriptionOfProgram:stack]];
    }
    
    NSLog(@"exiting CalculatorBrain:descriptionOfProgram with %@ ",[programFragment description]);
    return programFragment;
    
}

- (id)popOffProgramStack{
    
    id topOfStack = [self.programStack lastObject];
    if (topOfStack){
        [self.programStack removeLastObject];
    }
    return topOfStack;
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
