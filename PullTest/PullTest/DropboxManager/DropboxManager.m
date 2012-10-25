#import "DropboxManager.h"
#import "FileInfo.h"

@interface DropboxManager ()
-(NSNumber *)sizeOfFile:(NSString *)path;
@end

@implementation DropboxManager
{
}
@synthesize myName;

- (DropboxManager *)initWithAppKey:(NSString *)key
                         appSecret:(NSString *)secret
                          userName:(NSString *)userName
                      downloadPath:(NSString *)path
{
    dbSession = [[DBSession alloc] initWithAppKey:key appSecret:secret root:kDBRootDropbox];
    [DBSession setSharedSession:dbSession];
    myName = userName;
    downloadPath = path;

    return self;
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
    if (restClient == nil) {
        restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        [restClient setDelegate:self];
    }
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    NSNumber *size = [self sizeOfFile:srcPath];
    NSString *destPath = [NSString stringWithFormat:@"/user/%@/incoming/",user];
    NSString *destFile = [NSString stringWithFormat:@"%lf+%@+%@+%@",timestamp,myName,size,[srcPath lastPathComponent]];
    NSLog(@"%@%@", destPath, destFile);
    [restClient uploadFile:destFile toPath:destPath withParentRev:nil fromPath:srcPath];
}

- (void)restClient:(DBRestClient*)client uploadedFile:(NSString*)destPath from:(NSString*)srcPath metadata:(DBMetadata*)metadata
{
    //NSLog(@"File uploaded successfully to path: %@", metadata.path);
    if(delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)]) {
        FileInfo *info = [[FileInfo alloc] initWithPath:destPath];
        [delegate uploadedFile:info.fileName
                        toUser:info.toUser];
    }
}

- (void)restClient:(DBRestClient*)client uploadFileFailedWithError:(NSError*)error
{
    NSLog(@"File upload failed with error - %@", error);
    [delegate uploadFileFailedWithError:error];
}

- (void)restClient:(DBRestClient*)client uploadProgress:(CGFloat)progress forFile:(NSString *)destPath from:(NSString *)srcPath
{
    NSLog(@"from:%@, to:%@, progress:%.2f", srcPath, destPath, progress); //Correct way to visualice the float
    if(delegate && [delegate conformsToProtocol:@protocol(DropboxManagerDelegate)]) {
        FileInfo *info = [[FileInfo alloc] initWithPath:destPath inProgress:progress];
        [delegate uploadProgress:info.progress
                         forFile:info.fileName
                          toUser:info.toUser
                        uploaded:info.processdSize
                           total:info.totalSize];
    }
}


-(NSNumber *)sizeOfFile:(NSString *)path
{
    NSError *error = nil;
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    NSNumber *size = [attrs objectForKey:NSFileSize];
    return size;    
}

@end
