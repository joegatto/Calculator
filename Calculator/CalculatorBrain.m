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
@end

@implementation CalculatorBrain
@synthesize programStack = _programStack;

- (NSMutableArray *)programStack {
    if(!_programStack) {
        _programStack = [[NSMutableArray alloc] init];
    }
    return _programStack;
}

- (id)program {
    return [self.programStack copy];
}

- (void)pushOperand:(double)operand {
    [self.programStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)performOperation:(NSString *)operation {
    [self.programStack addObject:operation];
    return [CalculatorBrain runProgram:self.program];
}

+ (NSString *) descriptionOfProgram:(id)program {
    return @"Implement this in assignment 2";
}

+ (double)popOperandOffStack:(NSMutableArray *)stack {
    double result = 0;
    
    return result;
}

+ (double)runProgram:(id)program {
    return [self popOperandOffStack:[program mutableCopy]];
}

/*
    
    
    if([operation isEqualToString:@"+"]){
        result = [self popOperand] + [self popOperand];
    } else if([operation isEqualToString:@"*"]){
        result = [self popOperand] * [self popOperand];
    } else if([operation isEqualToString:@"-"]){
        double subtrahend = [self popOperand];
        result = [self popOperand] - subtrahend;
    } else if([operation isEqualToString:@"/"]){
        double divisor = [self popOperand];
        if (divisor) result = [self popOperand] / divisor;
    } else if([operation isEqualToString:@"sin"]){
        result = sin([self popOperand] * M_PI / 180);
    } else if([operation isEqualToString:@"cos"]){
        result = cos([self popOperand] * M_PI / 180);
    } else if([operation isEqualToString:@"sqrt"]){
        result = sqrt([self popOperand]);
    } 
    
    [self pushOperand:result];
    
    
}
 */

- (void)clearsEverything {
    _programStack = [[NSMutableArray alloc] init];
}

@end
