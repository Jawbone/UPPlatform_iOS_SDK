//
//  UPDefines.h
//  UPPlatformSDK
//
//  Created by Andy Roth on 5/5/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#ifndef UPPlatformSDK_UPDefines_h
#define UPPlatformSDK_UPDefines_h

#define UP_TARGET_OSX (!TARGET_OS_IPHONE && !TARGET_IPHONE_SIMULATOR)

#if UP_TARGET_OSX
#define UPImage NSImage
#else
#define UPImage UIImage
#endif

#endif
