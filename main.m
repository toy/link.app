//
//  main.m
//  link
//
//  Created by toy on 19.12.10.
//  Copyright 2010 Ivan Kuchin. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FNGlue.h"

NSArray* getPathToFrontFinderWindow(){
	FNApplication *finder = [FNApplication applicationWithName: @"Finder"];
	NSArray *paths = [[finder selection] getItem];

	return paths;
}

int main(int argc, char *argv[]) {
	id pool = [[NSAutoreleasePool alloc] init];

	NSFileManager *fileManager = [[NSFileManager alloc] init];

	[getPathToFrontFinderWindow() enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSString *url, *src, *ext, *srcWOExt, *dst;
		BOOL isDir;

		url = [[[(FNReference *)obj URL] get] send];
		src = [[NSURL URLWithString:url] path];
		ext = [src pathExtension];
		srcWOExt = [src stringByDeletingPathExtension];

		if ([fileManager fileExistsAtPath:src isDirectory:&isDir]) {
			for (int i = 1; ; i++) {
				dst = [NSString stringWithFormat:@"%@ %d", srcWOExt, i];
				if ([ext length] > 0) {
					dst = [dst stringByAppendingPathExtension:ext];
				}
				if (![fileManager fileExistsAtPath:dst]) {
					if (isDir) {
						[fileManager createSymbolicLinkAtPath:dst withDestinationPath:src error:nil];
					} else {
						[fileManager linkItemAtPath:src toPath:dst error:nil];
					}
					break;
				}
			}
		}
	}];

	[pool release];
	return 0;
}

