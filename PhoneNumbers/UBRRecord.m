//
//  UBRRecord.m
//  UberNumbers
//
//  Created by Karsten Bruns on 10.02.13.
//  Copyright (c) 2013 Karsten Bruns. All rights reserved.
//

#import "UBRRecord.h"

@implementation UBRRecord



- (void)applyFormattedNumber {
	
	if (!self.formattedPhoneNumber || self.formattedPhoneNumber.length < 3) {
		return;
	}

    ABMultiValue * oldNumbers = [self.abPerson valueForProperty:@"Phone"];
    
    
	if (oldNumbers && [oldNumbers isKindOfClass:[ABMultiValue class]]) {

		ABMutableMultiValue * newNumbers = [[ABMutableMultiValue alloc] init];

        for (NSUInteger i = 0; i < [oldNumbers count]; i++) {
            
            id value = [oldNumbers valueAtIndex:i];
            NSString * oldIdentifier = [oldNumbers identifierAtIndex:i];
            NSString * label = [oldNumbers labelAtIndex:i];
            
            if (i == self.phoneNumberIndex) {
                value = self.formattedPhoneNumber;
            }
                        
            NSString * newValueIdentifier = [newNumbers addValue:value withLabel:label];
            if ([oldNumbers.primaryIdentifier isEqualToString:oldIdentifier]) {
                [newNumbers setPrimaryIdentifier:newValueIdentifier];
            }
            
        }

		[self.abPerson setValue:newNumbers forProperty:@"Phone"];

    }

}



- (void)setAbPerson:(ABPerson *)newAbPerson {

    _abPerson = newAbPerson;
    ABPerson * person = _abPerson;
    int showAsFlags = [[person valueForProperty:kABPersonFlags] intValue] & kABShowAsMask;
    BOOL isCompany = (showAsFlags == kABShowAsCompany);
    
    NSMutableArray * nameComponents = [NSMutableArray array];
    
    if (isCompany) {

        if ([person valueForProperty:@"Organization"]) {
            [nameComponents addObject:[person valueForProperty:@"Organization"]];
        }
        
    }

    if ([person valueForProperty:@"Last"]) {
        [nameComponents addObject:[person valueForProperty:@"Last"]];
    }
    
    if ([person valueForProperty:@"First"]) {
        [nameComponents addObject:[person valueForProperty:@"First"]];
    }
    
    
    if (nameComponents.count < 1) {
        [nameComponents addObject:@"-"];
    }

    
    self.title = [nameComponents componentsJoinedByString:@", "];

}



@end
