import Foundation
import UIKit

class SongData {
    let songOfTitle: String
    let singer: String
    let albumCover: UIImage?
    let songUrl:URL
    
    init(songOfTitle:String,
         singer:String,
         albumCover:UIImage?,
         songUrl:URL) {
        self.songOfTitle = songOfTitle
        self.singer = singer
        self.albumCover = albumCover
        self.songUrl = songUrl
    }
}

