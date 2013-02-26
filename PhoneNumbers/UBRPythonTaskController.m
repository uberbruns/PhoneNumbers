//
//  UBRPythonTaskController.m
//  PhoneNumbers
//
//  Created by Karsten Bruns on 11.02.13.
//  Copyright (c) 2013 Karsten Bruns. All rights reserved.
//

#import "UBRPythonTaskController.h"


@interface UBRPythonTaskController () {
	NSString * _libPath;
}
@end



@implementation UBRPythonTaskController

- (id)init {
    
    self = [super init];
    
    if (self) {
        _libPath = [[NSBundle mainBundle] pathForResource:@"Python" ofType:nil];
    }
    
    return self;
}



- (NSString *)executePython:(NSArray *)linesInput {
    
    NSMutableArray * lines = [NSMutableArray arrayWithArray:linesInput];
    [lines addObject:@"quit()"];
	
    NSString * pythonCode = [lines componentsJoinedByString:@"\n"];
    NSPipe * stdInPipe = [NSPipe pipe];
    NSPipe * stdOutPipe = [NSPipe pipe];
	   
    NSTask * task = [[NSTask alloc] init];
    task.launchPath = @"/usr/bin/python";
    task.currentDirectoryPath = _libPath;
    task.standardInput = stdInPipe;
    task.standardOutput = stdOutPipe;
    [task launch];
    
    [[stdInPipe fileHandleForWriting] writeData:[pythonCode dataUsingEncoding:NSUTF8StringEncoding]];
    [[stdInPipe fileHandleForWriting] closeFile];
    
    NSData * data = [[stdOutPipe fileHandleForReading] readDataToEndOfFile];
    NSString * string = [[NSString alloc] initWithBytes: data.bytes length:data.length encoding: NSUTF8StringEncoding];
	
//	NSLog(@"PYTHON OUTPUT:");
//	NSLog(@"%@", string);
	
    return string;
    
}


@end
