//
//  UBRLibTaskController.h
//  UberNumbers
//
//  Created by Karsten Bruns on 10.02.13.
//  Copyright (c) 2013 Karsten Bruns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UBRPythonTaskController.h"

@interface UBRPhoneNumberTaskController : UBRPythonTaskController

- (void)addPhoneNumber:(NSString *)phoneNumber country:(NSString*)countrCode;
- (NSArray *)processPhoneNumbers;

@end
