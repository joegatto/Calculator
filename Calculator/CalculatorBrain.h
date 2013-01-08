//
//  CalculatorBrain.h
//  Calculator
//
//  Created by João Carlos Lopes Gatto on 6/8/12.
//  Copyright (c) 2012 Gatto IT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CalculatorBrain : NSObject

- (void)pushOperand:(double)operand;
- (double)performOperation:(NSString *)operation;
- (void)clearsEverything;

@property (readonly) id program;

+ (double)runProgram:(id)program;
+ (NSString *)descriptionOfProgram:(id)program;

@end
