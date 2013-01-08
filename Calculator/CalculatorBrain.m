//
//  CalculatorBrain.m
//  Calculator
//
//  Created by João Carlos Lopes Gatto on 6/8/12.
//  Copyright (c) 2012 Gatto IT. All rights reserved.
//

#import "CalculatorBrain.h"

@interface CalculatorBrain()
@property (nonatomic, strong) NSMutableArray *operandStack;
@end

@implementation CalculatorBrain
@synthesize operandStack = _operandStack;

- (NSMutableArray *)operandStack {
    if(!_operandStack) {
        _operandStack = [[NSMutableArray alloc] init];
    }
    return _operandStack;
}

- (void)pushOperand:(double)operand {
    [self.operandStack addObject:[NSNumber numberWithDouble:operand]];
}

- (double)popOperand {
    NSNumber *operandObject = [self.operandStack lastObject];
    if(operandObject) [self.operandStack removeLastObject];
    return [operandObject doubleValue];
}

- (double)performOperation:(NSString *)operation {
    double result = 0;
    
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
    
    return result;
}

- (void)clearsEverything {
    _operandStack = [[NSMutableArray alloc] init];
}

@end
