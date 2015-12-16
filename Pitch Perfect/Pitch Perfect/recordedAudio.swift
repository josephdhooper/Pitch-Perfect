//
//  recordedAudio.swift
//  Pitch Perfect
//
//  Created by Joseph Hooper on 11/25/15.
//  Copyright © 2015 josephdhooper. All rights reserved.
//  Note: The initialization code was sourced from the following: http://stackoverflow.com/questions/29688058/initializing-in-swift

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl: NSURL, title: String!)
    {
        self.filePathUrl = filePathUrl
        self.title = title
    }
}


