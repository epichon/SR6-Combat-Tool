//
//  EchoArrayController.m
//  DBBuilder
//
//  Created by Ed Pichon on 2020/7/02.
//  Copyright © 2020 Ed Pichon. All rights reserved.
//

#import "EchoArrayController.h"
#import "SR6Echo.h"

@implementation EchoArrayController

-(IBAction)add:(id)sender {
    
    SR6Echo *myEcho = (SR6Echo *)[self newObject];
    myEcho.echoUUID = [NSUUID UUID];
}


@end
