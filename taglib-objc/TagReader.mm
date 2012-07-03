//
//  TagReader.m
//  TagLib-ObjC
//
//  Created by Me on 01/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TagReader.h"

#include <fileref.h>
#include <mpegfile.h>
#include <id3v2tag.h>
#include <id3v2frame.h>
#include <id3v2header.h>
#include <attachedpictureframe.h>

using namespace TagLib;

static inline NSString *NSStr(TagLib::String _string)
{
    if (_string.isNull() == false) {
        return [NSString stringWithUTF8String:_string.toCString(true)];
    } else {
        return nil;
    }
}
static inline TagLib::String TLStr(NSString *_string)
{
    return TagLib::String([_string UTF8String], TagLib::String::UTF8);
}

@interface TagReader ()
{
    FileRef _file;
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
    
    if (_path != nil) {
        _file = FileRef([path UTF8String]);
    } else {
        _file = FileRef();
    }
}

- (BOOL)save
{
    _file.save();
    sleep(1);
    return YES;
}

- (NSString *)title
{
    return NSStr(_file.tag()->title());
}
- (void)setTitle:(NSString *)title
{
    _file.tag()->setTitle(TLStr(title));
}
- (NSString *)artist
{
    return NSStr(_file.tag()->artist());
}
- (void)setArtist:(NSString *)artist
{
    _file.tag()->setArtist(TLStr(artist));
}
- (NSString *)album
{
    return NSStr(_file.tag()->album());
}
- (void)setAlbum:(NSString *)album
{
    _file.tag()->setAlbum(TLStr(album));
}
- (NSNumber *)year
{
    return [NSNumber numberWithUnsignedInt:_file.tag()->year()];
}
- (void)setYear:(NSNumber *)year
{
    _file.tag()->setYear([year unsignedIntValue]);
}
- (NSString *)comment
{
    return NSStr(_file.tag()->comment());
}
- (void)setComment:(NSString *)comment
{
    _file.tag()->setComment(TLStr(comment));
}
- (NSNumber *)track
{
    return [NSNumber numberWithUnsignedInt:_file.tag()->track()];
}
- (void)setTrack:(NSNumber *)track
{
    _file.tag()->setTrack([track unsignedIntValue]);
}
- (NSString *)genre
{
    return NSStr(_file.tag()->genre());
}
- (void)setGenre:(NSString *)genre
{
    _file.tag()->setGenre(TLStr(genre));
}
- (NSData *)albumArt
{
    MPEG::File *file = dynamic_cast<MPEG::File *>(_file.file());
    if (file != NULL) {
        ID3v2::Tag *tag = file->ID3v2Tag();
        if (tag) {
            ID3v2::FrameList frameList = tag->frameListMap()["APIC"];
            ID3v2::AttachedPictureFrame *picture = NULL;
            
            if (!frameList.isEmpty() && NULL != (picture = dynamic_cast<ID3v2::AttachedPictureFrame *>(frameList.front()))) {
                TagLib::ByteVector bv = picture->picture();
                return [NSData dataWithBytes:bv.data() length:bv.size()];
            }
        }
    }
    return nil;
}
- (void)setAlbumArt:(NSData *)albumArt
{
    MPEG::File *file = dynamic_cast<MPEG::File *>(_file.file());
    if (file != NULL) {
        ID3v2::Tag *tag = file->ID3v2Tag();
        if (tag) {
            ID3v2::AttachedPictureFrame *picture = new ID3v2::AttachedPictureFrame();
            
            TagLib::ByteVector bv = ByteVector((const char *)[albumArt bytes], [albumArt length]);
            picture->setPicture(bv);
            picture->setMimeType(String("image/jpg"));
            picture->setType(ID3v2::AttachedPictureFrame::FrontCover);
            
            tag->removeFrames("APIC");
            tag->addFrame(picture);
        }
    }
}

- (void)dealloc
{
    _path = nil;
}

@end
