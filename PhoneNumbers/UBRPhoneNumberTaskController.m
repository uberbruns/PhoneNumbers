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



- (BOOL)addPhoneNumber:(NSString *)phoneNumber country:(NSString*)countryCode {
	
	NSArray * phoneNumberComponent = [phoneNumber componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	[_phoneNumbers addObject:@{@"number":[phoneNumberComponent componentsJoinedByString:@""], @"cc": countryCode}];
	return TRUE;
	

}



- (NSArray *)processPhoneNumbers {

//	NSLog(@"INPUT:");
//	NSLog(@"%@", _phoneNumbers);

    
	// Import Python Lib
    NSMutableArray * lines = [NSMutableArray array];
    [lines addObject: @"import phonenumbers"];
    
	// Process Phone Numbers, Build Python Script
    for (NSDictionary * d in _phoneNumbers) {
		[lines addObject:@"x = None"];
        [lines addObject:[NSString stringWithFormat:@"for match in phonenumbers.PhoneNumberMatcher(\"%@\", \"%@\"):", d[@"number"], d[@"cc"]]];
        [lines addObject:@"    x = match"];
        [lines addObject:@"    break"];
        [lines addObject:@"if x != None and phonenumbers.is_possible_number(x.number) and phonenumbers.is_valid_number(x.number):"];
        [lines addObject:@"    print phonenumbers.format_number(x.number, phonenumbers.PhoneNumberFormat.INTERNATIONAL)"];
		[lines addObject:@"else:"];
        [lines addObject:@"    print \"--\""];

    }
    [_phoneNumbers removeAllObjects];

	// Execute Python and Return
    NSString * results = [self executePython:lines];
    return [results componentsSeparatedByString:@"\n"];
    
}



@end
