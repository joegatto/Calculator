//
//  CalculatorBrain.m
//  Calculator
//
//  Created by João Carlos Lopes Gatto on 6/8/12.
//  Copyright (c) 2012 Gatto IT. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *programStack;
@property (nonatomic, strong) NSMutableDictionary *dictVariableValues;
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;
@synthesize dictVariableValues = _dictVariableValues;

- (NSMutableArray *)programStack {
    if(!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (NSMutableDictionary *)dictVariableValues {
    if(!_dictVariableValues) {
        _dictVariableValues = [[NSMutableDictionary alloc] init];
    }
    return _dictVariableValues;
}

- (id)program {
    return [self.programStack copy];
}

- (id)variables {
    return [self.dictVariableValues copy];
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program usingVariablesValues:self.dictVariableValues];
}

+ (NSString *) descriptionOfProgram:(id)program {
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self descriptionOfTopOfStack:stack];
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        return [topOfStack doubleValue];
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] + [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"*"]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"-"]){
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffStack:stack] * M_PI / 180);
        } else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffStack:stack] * M_PI / 180);
        } else if([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"π"]){
            result = M_PI;
        } else if ([operation isEqualToString:@"log"]) {
            if ([self popOperandOffStack:stack] >= 0) {
                result = log([self popOperandOffStack:stack]);
            }
        } else if ([@"+/-" isEqualToString:operation]) {   
            result = (-1) * [self popOperandOffStack:stack];
        }
    }
    
    return result;
}

+ (NSString *)descriptionOfTopOfStack:(NSMutableArray *)stack {

    id topOfStack = [stack lastObject];
    if (topOfStack) [stack removeLastObject];
    
    if([topOfStack isKindOfClass:[NSNumber class]]){
        return topOfStack;
    } else if ([topOfStack isKindOfClass:[NSString class]]) {
        NSString *operation = topOfStack;
        if([operation isEqualToString:@"+"]){
            result = [self popOperandOffStack:stack] "+" [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"*"]){
            result = [self popOperandOffStack:stack] * [self popOperandOffStack:stack];
        } else if([operation isEqualToString:@"-"]){
            double subtrahend = [self popOperandOffStack:stack];
            result = [self popOperandOffStack:stack] - subtrahend;
        } else if([operation isEqualToString:@"/"]){
            double divisor = [self popOperandOffStack:stack];
            if (divisor) result = [self popOperandOffStack:stack] / divisor;
        } else if([operation isEqualToString:@"sin"]){
            result = sin([self popOperandOffStack:stack] * M_PI / 180);
        } else if([operation isEqualToString:@"cos"]){
            result = cos([self popOperandOffStack:stack] * M_PI / 180);
        } else if([operation isEqualToString:@"sqrt"]){
            result = sqrt([self popOperandOffStack:stack]);
        } else if([operation isEqualToString:@"π"]){
            result = M_PI;
        } else if ([operation isEqualToString:@"log"]) {
            if ([self popOperandOffStack:stack] >= 0) {
                result = log([self popOperandOffStack:stack]);
            }
        } else if ([@"+/-" isEqualToString:operation]) {
            result = (-1) * [self popOperandOffStack:stack];
        }
    }
    
    return result;
}

+ (double)runProgram:(id)program {
    NSMutableArray *stack;
    if([program isKindOfClass:[NSArray class]]){
        stack = [program mutableCopy];
    }
    return [self popOperandOffStack:stack];
}

+ (double)runProgram:(id)program usingVariablesValues:(NSDictionary *)variableValues {
    NSMutableArray *stack;
    if (variableValues) {
        if([program isKindOfClass:[NSArray class]]){
            stack = [program mutableCopy];
        }
    }
    return [self popOperandOffStack:stack];
}

+ (NSSet *)variablesUsedInProgram:(id)program {
    
}

+ (BOOL) isOperation:(NSString *)operation {
    
}

- (void)clearsEverything {
    [self.programStack removeAllObjects];
}

@end
