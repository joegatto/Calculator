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

// Getter for the brain, it uses lazy instantiation to return a valid brain object
- (CalculatorBrain *)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

// Getter for the testVariableValues, it uses lazy instantiation to return a valid NSDictionay object
- (NSDictionary *)testVariableValues {
    if (!_testVariableValues) {
		_testVariableValues = [NSDictionary dictionaryWithObjectsAndKeys:
                               [NSNumber numberWithDouble:0], @"x",
                               [NSNumber numberWithDouble:4.8], @"a",
                               [NSNumber numberWithDouble:0], @"b", nil];
	}
	return _testVariableValues;
}

// This method is responsible for synchronize the view with the latest calculation in the brain, find the result by
// running the program passing in the test variable values, if the result is a string, then display it, otherwise
// get the Number's description, updates the calculation label, from the latest description of program and the user
// isn't in the middle of entering a number
- (void)synchronizeView {
	id result = [CalculatorBrain runProgram:self.brain.program usingVariablesValues:self.testVariableValues];
    
	if ([result isKindOfClass:[NSString class]]) {
        self.display.text = result;
        self.descriptionDisplay.text = @"ERROR";
    } else {
        self.display.text = [NSString stringWithFormat:@"%g", [result doubleValue]];

        self.descriptionDisplay.text = [CalculatorBrain descriptionOfProgram:self.brain.program];
    }
    
	self.userIsInTheMiddleOfEnteringANumber = NO;
}

// This action handles user hitting the digits button, it checks if the digit pressed is a "." AND
// if a "." was not already included, if there is already a "."in the display it returns nothing.
// If user is in the middle of entering a number, it appends the current title to current text on the display.
// If is not in the middle of entering a number, it sets the variable userIsInTheMiddleOfEnteringANumber to YES
// and at last, set the current tittle of the button to display.
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

// This action handles user hitting the enter button
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
