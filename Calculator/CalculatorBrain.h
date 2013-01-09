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
@property (readonly) id variables;

+ (double)runProgram:(id)program;
+ (double)runProgram:(id)program usingVariablesValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (BOOL) isOperation:(NSString *)operation;

@end
