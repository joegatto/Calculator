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
@end

@implementation CalculatorViewController
@synthesize display = _display;
@synthesize historyDisplay = _historyDisplay;
@synthesize userIsInTheMiddleOfEnteringANumber = _userIsInTheMiddleOfEnteringANumber;
@synthesize brain = _brain;

- (CalculatorBrain *)brain {
    if(!_brain) _brain = [[CalculatorBrain alloc] init];
    return _brain;
}

- (IBAction)digitPressed:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:@"."] && [self.display.text rangeOfString:@"."].location != NSNotFound) {
        return;
    }
    if (self.userIsInTheMiddleOfEnteringANumber) {
        self.display.text = [self.display.text stringByAppendingFormat:@"%@", sender.currentTitle];
    } else {
        self.display.text = sender.currentTitle;
        self.userIsInTheMiddleOfEnteringANumber = YES;
    }
}

- (IBAction)enterPressed {
    if ([self.display.text doubleValue] != 0) {
        [self.brain pushOperand:[self.display.text doubleValue]];
        if ([self.historyDisplay.text rangeOfString:@"= "].location != NSNotFound) {
            self.historyDisplay.text = [self.historyDisplay.text substringToIndex:[self.historyDisplay.text length] - 2];
        }
        self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@"%@", [self.display.text stringByAppendingFormat:@" "]];
        self.display.text = 0;
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (IBAction)changeSignPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        self.display.text = [NSString stringWithFormat:@"%g", [self.display.text doubleValue] * -1];
    }
}

- (IBAction)operationPressed:(UIButton *)sender {
    if(self.userIsInTheMiddleOfEnteringANumber){
        [self enterPressed];
    }
    NSString *operation = [sender currentTitle];
    double result = [self.brain performOperation:operation];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@"%@", [[sender currentTitle] stringByAppendingFormat:@" "]];
    self.historyDisplay.text = [self.historyDisplay.text stringByAppendingFormat:@"= "];
    self.display.text = [NSString stringWithFormat:@"%g", result];
}

- (IBAction)clearPressed:(UIButton *)sender {
    [self.brain clearsEverything];
    self.display.text = @"0";
    self.historyDisplay.text = @"";
    self.userIsInTheMiddleOfEnteringANumber = NO;
}

- (IBAction)backspacePressed:(UIButton *)sender {
    self.display.text = [self.display.text substringToIndex:[self.display.text length] - 1];
    if([self.display.text length] == 0) { 
        self.display.text = @"0";
        self.userIsInTheMiddleOfEnteringANumber = NO;
    }
}

- (void)viewDidUnload {
    [self setHistoryDisplay:nil];
    [super viewDidUnload];
}
@end
