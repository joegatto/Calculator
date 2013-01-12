//
//  CalculatorViewController.m
//  Calculator
//
//  Created by João Carlos Lopes Gatto on 6/7/12.
//  Copyright (c) 2012 Gatto IT. All rights reserved.
//

#import "CalculatorViewController.h"
#import "CalculatorBrain.h"

@interface CalculatorViewController ()
@property (nonatomic) BOOL userIsInTheMiddleOfEnteringANumber;
@property (nonatomic, strong) CalculatorBrain *brain;
@property (nonatomic, strong) NSDictionary *testVariableValues;
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize descriptionDisplay = _descriptionDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

@synthesize testVariableValues = _testVariableValues;

- (CalculatorBrain *)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (NSDictionary *)testVariableValues {
    if (!_testVariableValues) {
		_testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:0], @"x",
                               [NSNumber numberWithDouble:4.8], @"a",
                               [NSNumber numberWithDouble:0], @"b", nil];
	}
	return _testVariableValues;
}

- (NSDictionary *)programVariableValues {
    
	// Find the variables in the current program in the brain as an array
	NSArray *variableArray =
	[[CalculatorBrain variablesUsedInProgram:self.brain.program] allObjects];
    
	// Return a description of a dictionary which contains keys and values for the keys
	// that are in the variable array
	return [self.testVariableValues dictionaryWithValuesForKeys:variableArray];
}

- (void)synchronizeView {
    
	// Find the result by running the program passing in the test variable values
	id result = [CalculatorBrain runProgram:self.brain.program usingVariablesValues:self.testVariableValues];
    
	// If the result is a string, then display it, otherwise get the Number's description
	if ([result isKindOfClass:[NSString class]]) {
        self.display.text = result;
        self.descriptionDisplay.text = @"ERROR";
    } else {
        self.display.text = [NSString stringWithFormat:@"%g", [result doubleValue]];
        // Now the calculation label, from the latest description of program
        self.descriptionDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    }
    
	// And the user isn't in the middle of entering a number
	self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)digitPressed:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"."] && [self.display.text rangeOfString:@"."].location != NSNotFound) {
        return;
    }
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingFormat:@"%@", sender.currentTitle];
    } else {
        self.userIsInTheMiddleOfEnteringANumber = YES;
        if ([sender.currentTitle isEqualToString:@"."]) {
            self.display.text = @"0.";
            return;
        }
        self.display.text = sender.currentTitle;
    }
}

- (IBAction)enterPressed {
    if ([self.display.text doubleValue] != 0) {
        [self.brain pushOperand:[self.display.text doubleValue]];
        [self synchronizeView];
    }
}

- (IBAction)changeSignPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [NSString stringWithFormat:@"%g", [self.display.text doubleValue] * -1];
    } else {
        [self operationPressed:sender];
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if (self.userIsInTheMiddleOfEnteringANumber) {
		[self enterPressed];
	}
    
	[self.brain pushOperation:[sender currentTitle]];
    [self synchronizeView];
}

- (IBAction)variablePressed:(UIButton *)sender {
    [self.brain pushVariable:sender.currentTitle];
	[self synchronizeView];
}

- (IBAction)testPressed:(UIButton *)sender {
    if (([sender.currentTitle isEqualToString:@"Test 1"])){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:-4], @"x",
                                   [NSNumber numberWithDouble:3], @"a",
                                   [NSNumber numberWithDouble:4], @"b", nil];
    } else if (([sender.currentTitle isEqualToString:@"Test 2"])){
        self.testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithDouble:-5], @"x", nil];
    } else if (([sender.currentTitle isEqualToString:@"Test 3"])){
        self.testVariableValues = nil;  
    };
    [self synchronizeView]; 
}

- (IBAction)undoPressed:(UIButton *)sender {
    [self.brain removeLastItem];
    [self synchronizeView];	
}

- (IBAction)clearPressed:(UIButton *)sender {
    [self.brain clearsEverything];
    [self synchronizeView];
    self.descriptionDisplay.text = @"";
}

- (IBAction)backspacePressed:(UIButton *)sender {
    self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
    if([self.display.text length] == 0) { 
        [self synchronizeView];
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
}
@end
