//
//  ComplexFormArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "ComplexFormArrayController.h"
#import "SR6ComplexForm.h"

@implementation ComplexFormArrayController

-(IBAction)add:(id)sender {
    
    SR6ComplexForm *myCF = (SR6ComplexForm *)[self newObject];
    myCF.complexFormUUID = [NSUUID UUID];
}

@end
