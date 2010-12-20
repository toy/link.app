//
//  NSArray+Map.m
//  link
//
//  Created by toy on 20.12.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "NSArray+Map.h"

@implementation NSArray (Map)

- (NSArray *)mapUsingBlock: (id (^)(id obj, NSUInteger idx))block {
	NSMutableArray *results = [NSMutableArray array];
	[self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		id result = block(obj, idx);
		[results addObject: result ? result : [NSNull null]];
	}];
	return results;
}

@end
