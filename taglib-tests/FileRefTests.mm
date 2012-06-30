//
//  FileRefTests.m
//  TagLib-ObjC
//
//  Created by Me on 30/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FileRefTests.h"

#include <string>

#include <tag.h>
#include <fileref.h>

#include <oggflacfile.h>
#include <vorbisfile.h>

#define TEST_ARTIST "test artist"
#define TEST_TITLE "test title èéÈ"
#define TEST_GENRE "Test! èéÈ"
#define TEST_ALBUM "test album èéÈ"
#define TEST_TRACK 12345
#define TEST_YEAR 2040

#define TEST_ARTIST_2 "ttest artist"
#define TEST_TITLE_2 "ytest title"
#define TEST_GENRE_2 "uTest!"
#define TEST_ALBUM_2 "ialbummmm"
#define TEST_TRACK_2 7
#define TEST_YEAR_2 2080

using namespace std;
using namespace TagLib;

@implementation FileRefTests

- (void)saveFileRefWithName:(NSString *)name extension:(NSString *)ext
{
    NSString *originalPath = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:ext];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *destinationPath = [[documentsDirectory stringByAppendingPathComponent:name] stringByAppendingPathExtension:ext];
    
    [[NSFileManager defaultManager] removeItemAtPath:destinationPath error:nil];
    
    NSError *error = nil;
    [[NSFileManager defaultManager] copyItemAtPath:originalPath toPath:destinationPath error:&error];
    STAssertNil(error, @"Could not copy file from bundle");
    
    const char *filePath = [destinationPath UTF8String];
    
    FileRef *f = new FileRef(filePath);
    STAssertFalse(f->isNull(), @"(1) Returned a NULL FileRef");
    f->tag()->setArtist(TEST_ARTIST);
    f->tag()->setTitle(TEST_TITLE);
    f->tag()->setGenre(TEST_GENRE);
    f->tag()->setAlbum(TEST_ALBUM);
    f->tag()->setTrack(TEST_TRACK);
    f->tag()->setYear(TEST_YEAR);
    f->save();
    delete f;
    
    f = new FileRef(filePath);
    STAssertFalse(f->isNull(), @"(2) Returned a NULL FileRef");
    STAssertTrue(f->tag()->artist() == String(TEST_ARTIST), @"Artist not equal");
    STAssertTrue(f->tag()->title() == String(TEST_TITLE), @"Title not equal");
    STAssertTrue(f->tag()->genre() == String(TEST_GENRE), @"Genre not equal");
    STAssertTrue(f->tag()->album() == String(TEST_ALBUM), @"Album not equal");
    STAssertTrue(f->tag()->track() == TagLib::uint(TEST_TRACK), @"Track not equal");
    STAssertTrue(f->tag()->year() == TagLib::uint(TEST_YEAR), @"Year not equal");
    
    f->tag()->setArtist(TEST_ARTIST_2);
    f->tag()->setTitle(TEST_TITLE_2);
    f->tag()->setGenre(TEST_GENRE_2);
    f->tag()->setAlbum(TEST_ALBUM_2);
    f->tag()->setTrack(TEST_TRACK_2);
    f->tag()->setYear(TEST_YEAR_2);
    f->save();
    delete f;
    
    f = new FileRef(filePath);
    STAssertFalse(f->isNull(), @"(3) Returned a NULL FileRef");
    STAssertTrue(f->tag()->artist() == String(TEST_ARTIST_2), @"Artist not equal");
    STAssertTrue(f->tag()->title() == String(TEST_TITLE_2), @"Title not equal");
    STAssertTrue(f->tag()->genre() == String(TEST_GENRE_2), @"Genre not equal");
    STAssertTrue(f->tag()->album() == String(TEST_ALBUM_2), @"Album not equal");
    STAssertTrue(f->tag()->track() == TagLib::uint(TEST_TRACK_2), @"Track not equal");
    STAssertTrue(f->tag()->year() == TagLib::uint(TEST_YEAR_2), @"Year not equal");
    delete f;
}
    
- (void)testMusepack
{
    [self saveFileRefWithName:@"click" extension:@"mpc"];
}

- (void)testASF
{
    [self saveFileRefWithName:@"silence-1" extension:@"wma"];
}

- (void)testVorbis
{
    [self saveFileRefWithName:@"empty" extension:@"ogg"];
}

- (void)testSpeex
{
    [self saveFileRefWithName:@"empty" extension:@"spx"];
}

- (void)testFLAC
{
    [self saveFileRefWithName:@"no-tags" extension:@"flac"];
}

- (void)testMP3
{
    [self saveFileRefWithName:@"xing" extension:@"mp3"];
}

- (void)testTrueAudio
{
    [self saveFileRefWithName:@"empty" extension:@"tta"];
}

- (void)testMP4_1
{
    [self saveFileRefWithName:@"has-tags" extension:@"m4a"];
}

- (void)testMP4_2
{
    [self saveFileRefWithName:@"no-tags" extension:@"m4a"];
}

- (void)testMP4_3
{
    [self saveFileRefWithName:@"no-tags" extension:@"3g2"];
}

- (void)testAPE
{
    [self saveFileRefWithName:@"mac-399" extension:@"ape"];
}

- (void)testOGA_FLAC
{
    FileRef *f = new FileRef([[[NSBundle bundleForClass:[self class]] pathForResource:@"empty_flac" ofType:@"oga"] UTF8String]);
    
    STAssertTrue(dynamic_cast<Ogg::Vorbis::File *>(f->file()) == NULL, @"Invalid cast, should be NULL");
    STAssertFalse(dynamic_cast<Ogg::FLAC::File *>(f->file()) == NULL, @"Valid cast, this should be NULL");
}

- (void)testOGA_Vorbis
{
    FileRef *f = new FileRef([[[NSBundle bundleForClass:[self class]] pathForResource:@"empty_vorbis" ofType:@"oga"] UTF8String]);
    
    STAssertFalse(dynamic_cast<Ogg::Vorbis::File *>(f->file()) == NULL, @"Valid cast, this should be NULL");
    STAssertTrue(dynamic_cast<Ogg::FLAC::File *>(f->file()) == NULL, @"Invalid cast, should be NULL");
}

@end
