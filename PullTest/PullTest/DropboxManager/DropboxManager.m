#import "DropboxManager.h"
#import "FileInfo.h"
#import "SKViewController.h"
#import "SKLocationFileInfo.h"
@interface DropboxManager ()
// aux
- (void)downloadAllFiles:(DBMetadata *)metadata;
// util
- (NSString *)incomingPathOfUser:(NSString *)userName;
- (NSString *)encodeFileName:(NSString *)fileName;
- (NSNumber *)sizeOfFile:(NSString *)path;
- (void)handlePollingTimer:(NSTimer *)timer;
- (BOOL)isDelegateValid;
- (BOOL)isIncomingFile:(NSString *)path;
- (BOOL)hasThumbnail:(NSString *)path;
@end

@implementation DropboxManager
{
    NSTimer *_pullingTimer;
    NSMutableDictionary *_downloadingFile;
}
@synthesize dbSession;
@synthesize restClient=_restClient;
@synthesize delegate;
@synthesize myName;
@synthesize downloadPath;
@synthesize mainController;

#pragma mark - initialization
- (DropboxManager *)initWithAppKey:(NSString *)key
                         appSecret:(NSString *)secret
                          userName:(NSString *)userName
                      downloadPath:(NSString *)path
{
    NSLog(@"name:%@ path:%@",userName,path);
    dbSession = [[DBSession alloc] initWithAppKey:key appSecret:secret root:kDBRootDropbox];
    [DBSession setSharedSession:dbSession];
    myName = userName;
    downloadPath = path;
    _pullingTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(handlePollingTimer:) userInfo:nil repeats:YES];
    _downloadingFile = [[NSMutableDictionary alloc] init];
    return self;
}

- (DBRestClient *)restClient
{
    if (_restClient == nil && [self isLinked]) {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        [_restClient setDelegate:self];
    }
    return _restClient;
}


- (void)linkFromController:(UIViewController *)mainController
{
    if (![[DBSession sharedSession] isLinked]) {
        [[DBSession sharedSession] linkFromController:mainController];
    }
}

- (BOOL)isLinked
{
    return [[DBSession sharedSession] isLinked];
}

- (NSString *)sendFriendRequest
{
    NSString *destPath = [self getFriendRequestPath];
    NSString *destFile = [self getUserProfileFileName:myName];
    NSString *fullPath = [destPath stringByAppendingPathComponent:destFile];
    NSString *srcPath = [self getUserProfileFullPath:myName];
    if ([[NSFileManager defaultManager] fileExistsAtPath:srcPath]) {
        [self.restClient uploadFile:destFile toPath:destPath withParentRev:nil fromPath:srcPath];
        return fullPath;
    } else {
        NSLog(@"can not find local file: %@", srcPath);
    }
    return nil;
}

- (NSString *)uploadLocationFile:(NSString*) srcPath fileName:(NSString *)filename latitude:(double)_latitude
longitude:(double) _longitue keepHours:(int) _keepHours 
{
    NSString *destPath = [self getLocationSharePath];
    NSString *destFile = [SKLocationFileInfo encodeLocationFileName:filename latitude:_latitude longitude:_longitue keepHours:_keepHours userName:myName];
    NSString *fullPath = [destPath stringByAppendingPathComponent:destFile];
    if ([[NSFileManager defaultManager] fileExistsAtPath:srcPath]) {
        [self.restClient uploadFile:destFile toPath:destPath withParentRev:nil fromPath:srcPath];
        return fullPath;
    } else {
        NSLog(@"can not find local file: %@", srcPath);
    }
    return nil;
}

- (NSString *)uploadFile:(NSString *)srcPath toUser:(NSString *)user
{
    NSString *destPath = [self incomingPathOfUser:user];
    NSString *destFile = [self encodeFileName:srcPath];
    NSString *fullPath = [destPath stringByAppendingPathComponent:destFile];
    if ([[NSFileManager defaultManager] fileExistsAtPath:srcPath]) {
        [self.restClient uploadFile:destFile toPath:destPath withParentRev:nil fromPath:srcPath];
        return fullPath;
    } else {
        NSLog(@"can not find local file: %@", srcPath);
    }
    return nil;
}

#pragma mark - callbacks for uploading
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata
{
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    if ([self isDelegateValid]) {
        FileInfo *info = [FileInfo fileInfoByPath:destPath];
        [delegate uploadedFile:info.fileName
                        toUser:info.toUser
                        fileId:info.fullPath];
    }
    [self.mainController showUploadedHud];
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
    NSLog(@"File upload failed with error - %@", error);
    if ([self isDelegateValid]) {
        [delegate uploadFileFailedWithError:error];
    }
}

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath
{
    NSLog(@"upload file: from:%@, to:%@, progress:%.2f%%", srcPath, destPath, progress*100);
    NSLog(@"thread:%@", [NSThread currentThread]);
    if ([self isDelegateValid]) {
        FileInfo *info = [FileInfo fileInfoByPath:destPath inProgress:progress];
        [delegate uploadProgress:info.progress
                         forFile:info.fileName
                          toUser:info.toUser
                        uploaded:info.processdSize
                           total:info.totalSize
                          fileId:info.fullPath];
    }
}

#pragma mark - callbacks for downloading
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata
{
    NSLog(@"File downloaded successfully from path:[[%@]] to path:[[%@]]", metadata.path, destPath);
    
    if ([self isIncomingFile:metadata.path]) {
        [self.restClient deletePath:metadata.path];
        if ([self isDelegateValid]) {
            FileInfo *info = [FileInfo fileInfoByPath:metadata.path];
            NSString *srcPath = [_downloadingFile objectForKey:destPath];
            [delegate downloadedFile:info.fileName
                            fromUser:info.fromUser
                              fileId:srcPath];
            [_downloadingFile removeObjectForKey:destPath];
        }
        [self.mainController showDownloadedHud];
    } else if ([self isFriendsFolder:metadata.path]) {
        [[self getUpperView]._gmGridView reloadData];
    } else {
        [self.mainController showDownloadedHud];
    }


}

- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath
{
    NSLog(@"download file: to:%@, progress:%.2f%%", destPath, progress*100);
    if ([self isDelegateValid]) {
        FileInfo *info = [FileInfo fileInfoByPath:destPath inProgress:progress];
        NSString *srcPath = [_downloadingFile objectForKey:destPath];
        [delegate downloadProgress:info.progress
                           forFile:info.fileName
                          fromUser:info.fromUser
                        downloaded:info.processdSize
                             total:info.totalSize
                            fileId:srcPath];
    }

}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    NSLog(@"File download failed with error - %@", error);
    if (delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)]) {
        [delegate downloadFileFailedWithError:error];
    }
}

#pragma mark - callbacks for thumbnail
- (void)restClient:(DBRestClient*)client loadedThumbnail:(NSString*)destPath metadata:(DBMetadata*)metadata
{
    NSLog(@"Thumbnail downloaded successfully from path:[[%@]] to path:[[%@]]", metadata.path, destPath);
}

- (void)restClient:(DBRestClient*)client loadThumbnailFailedWithError:(NSError*)error
{
    NSLog(@"Thumbnail download failed with error: %@", error);
}

#pragma mark - callbacks for matadata
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    if ([self isIncomingFile:metadata.path]) {
        [self downloadAllFiles:metadata];
    } else if ([self isFriendsFolder:metadata.path]) {
        [self listAndUpdateUsers:metadata];
    } else if ([SKLocationFileInfo isLocationShareFolder:metadata.path]) {
        [self listLocationFiles:metadata];
    }
    
}

- (void)restClient:(DBRestClient*)client metadataUnchangedAtPath:(NSString*)path
{
    NSLog(@"metadata unchanged at %@", path);
}

- (void)restClient:(DBRestClient*)client loadMetadataFailedWithError:(NSError*)error
{
    NSLog(@"metadata download failed with error - %@", error);
}

#pragma mark - callbacks for deleting
- (void)restClient:(DBRestClient*)client deletedPath:(NSString *)path
{
    [_downloadingFile removeObjectForKey:path];
    NSLog(@"file deleted:%@", path);
}

- (void)restClient:(DBRestClient*)client deletePathFailedWithError:(NSError*)error
{
    NSLog(@"file delete failed with error: %@", error);
}

#pragma mark - auxiliary functions
- (void)downloadAllFiles:(DBMetadata *)metadata
{
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
            NSString *fullPath  = [metadata.path stringByAppendingPathComponent:file.filename];
            FileInfo *info      = [FileInfo fileInfoByPath:fullPath];
            NSString *localPath = [downloadPath stringByAppendingPathComponent:info.fileName];
            if (![_downloadingFile objectForKey:localPath]) {
                [_downloadingFile setObject:fullPath forKey:localPath];
                if ([self hasThumbnail:fullPath]) {
                    [self.restClient loadThumbnail:fullPath ofSize:@"m" intoPath:[localPath stringByAppendingString:@".thumb"]];
                }
                [self.restClient loadFile:fullPath intoPath:localPath];
                if ([self isDelegateValid]) {
                    FileInfo *info = [FileInfo fileInfoByPath:fullPath];
                    [delegate downloadStartForFile:info.fileName toPath:localPath fromUser:info.fromUser fileId:info.fullPath];
                }
            }
        }
    }
}

-(void)listLocationFiles:(DBMetadata *)metadata {
    //BOOL is_user_list_changed = NO;
    NSMutableArray *loc_info_array = [[NSMutableArray alloc] initWithCapacity:10];
    for (DBMetadata *file in metadata.contents) {
        SKLocationFileInfo *loc_info = [[SKLocationFileInfo alloc] initWithPath:file.filename];
        [loc_info_array addObject:loc_info];
    }
    [self.mainController.locationSearchViewController setViewMapPin:loc_info_array];
}

-(void)listAndUpdateUsers:(DBMetadata *)metadata {
    
    if (metadata.isDirectory) {
        NSLog(@"[listAndUpdateUsers] Friends Folder '%@' contains:", metadata.path);
        
        NSString *localPath =
        [downloadPath stringByAppendingPathComponent:@"friends"];
        
        NSMutableSet *local_user_set = [[NSMutableSet alloc] init];
        NSFileManager *file_mgr = [NSFileManager defaultManager];
        NSDirectoryEnumerator *dir_enum = [file_mgr enumeratorAtPath:
                                           localPath];
        
        NSString *local_filename;
        while (local_filename=[dir_enum nextObject]) {
            
            if ([[local_filename pathExtension] isEqualToString:@"png"]) {
                [local_user_set addObject:local_filename];
                
            }
        }
        
        BOOL is_user_list_changed = NO;
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"[listAndUpdateUsers] file:%@",file);
            if ([[file.filename pathExtension] isEqualToString:@"png"]) {
                
                NSFileManager *file_mgr = [NSFileManager defaultManager];
                if (![file_mgr fileExistsAtPath:localPath]) {
                    if (![file_mgr createDirectoryAtPath:localPath
                             withIntermediateDirectories:YES
                                              attributes:nil
                                                   error:nil]) {
                        NSLog(@"[listAndUpdateUsers] create folder failed! %@",localPath);
                    }
                    
                }
                
                
                NSString *target_local_filepath = [localPath stringByAppendingPathComponent:file.filename];
                
                // NOTE: now we only download profile one time... no update
                if (![file_mgr fileExistsAtPath:target_local_filepath]) {
                    NSLog(@"[listAndUpdateUsers] localPath:%@, target_local_filepath:%@, file.filename:%@",
                          localPath,target_local_filepath,file.filename);
                    [self.restClient loadFile:file.path intoPath:target_local_filepath];
                    is_user_list_changed = YES;
                }
                
                [local_user_set removeObject:file.filename];
            }
        }
        
        if (is_user_list_changed) {
            NSLog(@"[listAndUpdateUsers] user list changed, reload upper panel");
            [[self getUpperView]._gmGridView reloadData];
        }
        /*
        for (NSString* will_delete_user_name in local_user_set) {
            
        }
         */
    }
}

#pragma mark - utilities
- (NSString *)getLocationSharePath
{
    return [NSString stringWithFormat:@"/user/location_share"];
}



- (NSString *)incomingPathOfUser:(NSString *)userName
{
    return [NSString stringWithFormat:@"/user/%@/incoming/",userName];
}

- (NSString *)friendsPathOfUser:(NSString *)userName
{
    return [NSString stringWithFormat:@"/user/%@/friends/",userName];
}

- (NSString *)getFriendRequestPath
{
    return @"/user/friend_request/";
}

- (NSString *)getUserFriendRequestFilePath:(NSString*)userName
{
    return [NSString stringWithFormat:@"/user/friend_request/%@.png",userName];
}

- (NSString *)getUserProfileFileName:(NSString*)userName
{
    return [NSString stringWithFormat:@"%@.png",userName];
}

- (NSString *)getUserProfileFullPath:(NSString *)userName
{
    return [NSString stringWithFormat:@"/user/%@/%@.png",userName,userName];
}


- (NSString *)encodeFileName:(NSString *)fileName
{
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *size = [self sizeOfFile:fileName];
    return [NSString stringWithFormat:@"%lf+%@+%@+%@",timestamp,myName,size,[fileName lastPathComponent]];
}

- (NSNumber *)sizeOfFile:(NSString *)path
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    NSNumber *size = [attrs objectForKey:NSFileSize];
    return size;    
}

- (void)handlePollingTimer:(NSTimer *)timer
{
    NSLog(@"polling:%@ thread:%@", timer, [NSThread currentThread]);
    if ([self isLinked]) {
        NSLog(@"request metadata myname:%@ rest:%@",myName,self.restClient);
        NSString *fullPath = [self incomingPathOfUser:myName];
        [self.restClient loadMetadata:fullPath];
        NSString *friendsPath = [self friendsPathOfUser:myName];
        [self.restClient loadMetadata:friendsPath];
    }
}

- (BOOL)isDelegateValid
{
    return delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)];
}

- (BOOL)isIncomingFile:(NSString *)path
{
    if ([path hasPrefix:@"/user/"]) {
        NSRange range = [path rangeOfString:@"/incoming"];
        if (range.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isFriendsFolder:(NSString *)path
{
    if ([path hasPrefix:@"/user/"]) {
        NSRange range = [path rangeOfString:@"/friends"];
        if (range.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)isExistedFriendFolder:(NSString *)path {
    if ([path hasPrefix:@"/user/"]) {
        NSRange range = [path rangeOfString:@"/friends/"];
        if (range.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}



- (BOOL)isFriendRequestFolder:(NSString *)path
{
    if ([path hasPrefix:@"/user/"]) {
        NSRange range = [path rangeOfString:@"/friend_request"];
        if (range.location != NSNotFound) {
            return YES;
        }
    }
    return NO;
}


- (BOOL)hasThumbnail:(NSString *)path
{
    NSArray *supportedExt = [NSArray arrayWithObjects:@"jpg",@"jpeg",@"png",@"tiff",@"tif",@"gif",@"bmp",nil];
    path = [[path pathExtension] lowercaseString];
    for (NSString *ext in supportedExt) {
        if ([path hasSuffix:ext]) {
            return YES;
        }
    }
    return NO;
}

- (UpperStyledPullableView*) getUpperView {
    return (UpperStyledPullableView*)[self.mainController.view viewWithTag:2377];
}

@end
