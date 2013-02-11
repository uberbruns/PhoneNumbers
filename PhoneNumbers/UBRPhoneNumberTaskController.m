//
//  UBRLibTaskController.m
//  UberNumbers
//
//  Created by Karsten Bruns on 10.02.13.
//  Copyright (c) 2013 Karsten Bruns. All rights reserved.
//

#import "UBRPhoneNumberTaskController.h"

@interface UBRPhoneNumberTaskController () {
	NSMutableArray * _phoneNumbers;
}
@end



@implementation UBRPhoneNumberTaskController


- (id)init {
	
    self = [super init];
    if (self) {
        _phoneNumbers = [NSMutableArray array];
    }
    return self;
	
}



- (void)addPhoneNumber:(NSString *)phoneNumber country:(NSString*)countryCode {
    
    [_phoneNumbers addObject:@{@"number":phoneNumber, @"cc": countryCode}];
    
}



- (NSArray *)processPhoneNumbers {
    
	// Import Python Lib
    NSMutableArray * lines = [NSMutableArray array];
    [lines addObject: @"import phonenumbers"];
    
	// Process Phone Numbers, Build Python Script
    for (NSDictionary * d in _phoneNumbers) {
        [lines addObject:[NSString stringWithFormat:@"x = phonenumbers.parse(\"%@\", \"%@\")", d[@"number"], d[@"cc"]]];
        [lines addObject:@"print phonenumbers.format_number(x, phonenumbers.PhoneNumberFormat.INTERNATIONAL)"];
    }
    [_phoneNumbers removeAllObjects];

	// Execute Python and Return
    NSString * results = [self executePython:lines];
    return [results componentsSeparatedByString:@"\n"];
    
}



@end
