#import "DropboxManager.h"
#import "FileInfo.h"

@interface DropboxManager ()
- (NSString *)incomingPathOfUser:(NSString *)userName;
- (NSString *)encodeFileName:(NSString *)fileName;
- (NSNumber *)sizeOfFile:(NSString *)path;
- (void)handlePollingTimer:(NSTimer *)timer;
@end

@implementation DropboxManager
{
    NSTimer *_pullingTimer;
    NSMutableDictionary *_downloading;
}
@synthesize myName;

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
    _pullingTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(handlePollingTimer:) userInfo:nil repeats:YES];
    _downloading = [[NSMutableDictionary alloc] init];
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

- (void)uploadFile:(NSString *)srcPath toUser:(NSString *)user
{
    NSString *destPath = [self incomingPathOfUser:user];
    NSString *destFile = [self encodeFileName:srcPath];
    NSLog(@"%@%@", destPath, destFile);
    [self.restClient uploadFile:destFile toPath:destPath withParentRev:nil fromPath:srcPath];
}

// ========== upload callbacks ==========
- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata
{
    NSLog(@"File uploaded successfully to path: %@", metadata.path);
    if (delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)]) {
        FileInfo *info = [FileInfo fileInfoByPath:destPath];
        [delegate uploadedFile:info.fileName
                        toUser:info.toUser];
    }
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
    NSLog(@"File upload failed with error - %@", error);
    if (delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)]) {
        [delegate uploadFileFailedWithError:error];
    }
}

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath
{
    NSLog(@"upload file: from:%@, to:%@, progress:%.2f%%", srcPath, destPath, progress*100);
    NSLog(@"thread:%@", [NSThread currentThread]);
    if (delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)]) {
        FileInfo *info = [FileInfo fileInfoByPath:destPath inProgress:progress];
        [delegate uploadProgress:info.progress
                         forFile:info.fileName
                          toUser:info.toUser
                        uploaded:info.processdSize
                           total:info.totalSize];
    }
}

// ========== download callbacks ==========
- (void)restClient:(DBRestClient*)client loadedFile:(NSString*)destPath
       contentType:(NSString*)contentType metadata:(DBMetadata*)metadata
{
    NSLog(@"File downloaded successfully from path:[[%@]] to path:[[%@]]", metadata.path, destPath);
    [self.restClient deletePath:metadata.path];
    if (delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)]) {
        FileInfo *info = [FileInfo fileInfoByPath:metadata.path];
        [delegate uploadedFile:info.fileName
                        toUser:info.toUser];
    }
}

- (void)restClient:(DBRestClient*)client loadProgress:(CGFloat)progress forFile:(NSString*)destPath
{
    NSLog(@"download file: to:%@, progress:%.2f%%", destPath, progress*100);
    if (delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)]) {
        FileInfo *info = [FileInfo fileInfoByPath:destPath inProgress:progress];
        [delegate downloadProgress:info.progress
                           forFile:info.fileName
                          fromUser:info.fromUser
                        downloaded:info.processdSize
                             total:info.totalSize];
    }

}

- (void)restClient:(DBRestClient*)client loadFileFailedWithError:(NSError*)error
{
    NSLog(@"File download failed with error - %@", error);
    //[_downloading removeObjectForKey:<#(id)#>]
    if (delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)]) {
        [delegate downloadFileFailedWithError:error];
    }
}

// ========== metadata callbacks ==========
- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata*)metadata
{
    if (metadata.isDirectory) {
        NSLog(@"Folder '%@' contains:", metadata.path);
        for (DBMetadata *file in metadata.contents) {
            NSLog(@"\t%@", file.filename);
            NSString *fullPath = [metadata.path stringByAppendingPathComponent:file.filename];
            FileInfo *info = [FileInfo fileInfoByPath:fullPath];
            NSString *destPath = [downloadPath stringByAppendingPathComponent:info.fileName];
            if (![_downloading objectForKey:fullPath]) {
                [_downloading setObject:fullPath forKey:fullPath];
                [self.restClient loadFile:fullPath intoPath:destPath];
            }
        }
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

// ========== delete callbacks ==========
- (void)restClient:(DBRestClient*)client deletedPath:(NSString *)path
{
    [_downloading removeObjectForKey:path];
    NSLog(@"file deleted:%@", path);
}

- (void)restClient:(DBRestClient*)client deletePathFailedWithError:(NSError*)error
{
    NSLog(@"file delete failed with error: %@", error);
}

// ========== extended functions ==========
- (NSString *)incomingPathOfUser:(NSString *)userName
{
    return [NSString stringWithFormat:@"/user/%@/incoming/",userName];
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
    }
}
@end
