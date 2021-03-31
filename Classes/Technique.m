#import "UIImageAdditions.h"
#import "Category.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "NSFileManagerAdditions.h"
#define IPAD     UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad
@implementation Technique {
    NSURLConnection *_connection;
}
@synthesize summary;

- (void)dealloc {
    [_connection cancel];
}



- (void)setState:(TechniqueState)state {
    if(state == _state)
        return;
    [self willChangeValueForKey:@"state"];
    _state = state;
    [self didChangeValueForKey:@"state"];
}

- (NSURL*)videoUrl {
    return [NSURL fileURLWithPath:self.videoPath];
}

- (void)setCode:(NSString*)code {
    _code = code;
    [self updateState];
}

- (void)setCategory:(Category*)category {
    _category = category;
    [self updateState];
}


- (void)updateState {
    if(self.code == nil || self.category == nil)
        return;
    TechniqueState newState = self.isAvailable ? Downloaded : NotDownloaded;
    if(self.state != Downloaded && newState == Downloaded) {
        [self checkIfNewFileIsAvailable];
    }
    self.state = newState;
}

- (void)checkIfNewFileIsAvailable {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:self.url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:20];
    request.HTTPMethod = @"HEAD";
    _connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSString *serverModifiedString = [[(NSHTTPURLResponse *)response allHeaderFields] objectForKey:@"Last-Modified"];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT"];
    formatter.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss z";
    NSDate *servedModified = [formatter dateFromString:serverModifiedString];

    NSFileManager *mgr = [NSFileManager defaultManager];
    NSDictionary *attributes = [mgr attributesOfItemAtPath:self.videoPath error:nil];
    NSDate *localModified = attributes[NSFileModificationDate];

    if([localModified compare:servedModified] == NSOrderedAscending) {
        MLog(@"Downloaded copy of %@ is outdated!!!!!!!",self.url);
        self.state = NotDownloaded;
        NSError *error = nil;
        [[NSFileManager defaultManager] removeItemAtPath:self.videoPath error:&error];
        NSAssert(error == nil, @"Delete of failed %@", error);
    } else {
        MLog(@"Downloaded copy of %@ is up to date",self.url);
    }
    return;

}

- (NSString*)identity {
    return [self.category.code stringByAppendingString:self.code];
}

- (Technique*)video {
    return self;
}

- (NSString*)imageName {
    return self.identity;
}

- (UIImage*)image {
    return [UIImage checkedImageNamed:self.imageName];
}

- (NSString*)videoPath {
    NSString* dir = [[NSFileManager defaultManager] applicationSupportDirectory];
    //return [[NSBundle mainBundle] pathForResource:self.identity ofType:@"m4v"];
    return [NSString stringWithFormat:@"%@/%@.%@", dir, self.identity, @"m4v"];
}

- (UIView*)imageView {
    return [UIImageView checkedImageViewNamed:self.imageName];
}

- (BOOL)isAvailable {
    return [[NSFileManager defaultManager] fileExistsAtPath:self.videoPath];
}

- (void)startDownload {
    NSAssert(self.state == NotDownloaded, @"Download already in progress");
    ASIHTTPRequest* request = [ASIHTTPRequest requestWithURL:self.url];
    request.temporaryFileDownloadPath = [self.videoPath stringByAppendingPathExtension:@"download"];
    request.allowResumeForFileDownloads = YES;
    request.delegate = self;
    request.timeOutSeconds = 30;
    request.didFailSelector = @selector(requestWentWrong:);
    request.didFinishSelector = @selector(requestDone:);
    request.username = decode("eurppd");
    request.password = decode("dnhuvehujd");
    request.downloadDestinationPath = self.videoPath;
    [self.downloads addOperation:request];
    [self.downloads go];
    self.state = Downloading;
}

- (NSURL *)url {
    NSString* lang = [[NSBundle mainBundle] infoDictionary][@"CFBundleDevelopmentRegion"];
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://golftech.se/golftechvideos/%@/%@.mp4", lang, self.identity]];
    return url;
}

- (ASINetworkQueue*)downloads {
    static ASINetworkQueue* downloads = nil;
    if(downloads != nil)
        return downloads;
    downloads = [ASINetworkQueue new];
    downloads.showAccurateProgress = YES;
    [downloads setMaxConcurrentOperationCount:2];
    return downloads;
}

#pragma mark ASIHTTPRequest delegate

- (void)requestDone:(ASIHTTPRequest*)request {
    //MLog(@"Done downloading %@ %d %@", request.url, request.responseStatusCode, request.responseStatusMessage);
    self.state = Downloaded;
    if(IPAD) {
     self.onDownloadCompleted();
    }
}

- (void)requestWentWrong:(ASIHTTPRequest*)request {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Nedladdningen misslyckades", @"Nedladdningen misslyckades") message:request.error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
    [alert show];
    self.state = NotDownloaded;
    if(IPAD) {
        self.onDownloadCompleted();
    }
    
}

@end