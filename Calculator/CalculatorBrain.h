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
- (void)pushOperation:(NSString *) operation;
- (void)pushVariable:(NSString *)variable;
- (id)performOperation:(NSString *)operation;
- (void)clearsEverything;
- (void)removeLastItem;

@property (readonly) id program;
@property (readonly) id variables;

+ (id)runProgram:(id)program;
+ (id)runProgram:(id)program usingVariablesValues:(NSDictionary *)variableValues;
+ (NSString *)descriptionOfProgram:(id)program;
+ (NSSet *)variablesUsedInProgram:(id)program;
+ (BOOL) isOperation:(NSString *)operation;
+ (BOOL)isValidProgram:(id)program;

@end
