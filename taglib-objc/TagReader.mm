//
//  TagReader.m
//  TagLib-ObjC
//
//  Created by Me on 01/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TagReader.h"

#import <fileref.h>

using namespace TagLib;

@interface TagReader ()
{
    FileRef *_file;
}

@end

@implementation TagReader
@synthesize path=_path;

- (id)initWithFileAtPath:(NSString *)path
{
    if (self = [super init]) {
        [self loadFileAtPath:path];
    }
    return self;
}
- (id)init
{
    return [self initWithFileAtPath:nil];
}

- (void)loadFileAtPath:(NSString *)path
{
    _path = path;
    
    if (_file != NULL) {
        delete _file;
    }
    
    if (_path != nil) {
        _file = new FileRef([path UTF8String]);
    } else {
        _file = NULL;
    }
}

- (void)dealloc
{
    _path = nil;
    if (_file != NULL) {
        delete _file;
    }
}

@end
