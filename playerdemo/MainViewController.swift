import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet var albumCoverImageView: UIImageView!
    @IBOutlet var songOfTitleLabel: UILabel!
    @IBOutlet var singerLabel: UILabel!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var progressBarSlider: UISlider!
    @IBOutlet var volumeBarSlider: UISlider!
    @IBOutlet var timePassLabel: UILabel!
    @IBOutlet var timeRemainLabel: UILabel!
    @IBOutlet var playpauseButton: UIButton!
    
    let player = AVPlayer()
    var playerItem: AVPlayerItem?
    var currentSongIndex = 0
    var timePass: Double = 0
    
    let songs:[SongData] = [
        SongData(songOfTitle: "不思議", singer: "星野源", albumCover: UIImage(named: "不思議"), songUrl: Bundle.main.url(forResource: "不思議", withExtension: "mp3")!),
        SongData(songOfTitle: "時よ", singer: "星野源", albumCover: UIImage(named: "時よ"), songUrl: Bundle.main.url(forResource: "時よ", withExtension: "mp3")!),
        SongData(songOfTitle: "戀", singer: "星野源", albumCover: UIImage(named: "戀"), songUrl: Bundle.main.url(forResource: "戀", withExtension: "mp3")!),
        SongData(songOfTitle: "Family Song", singer: "星野源", albumCover: UIImage(named: "Family Song"), songUrl: Bundle.main.url(forResource: "Family Song", withExtension: "mp3")!),
        SongData(songOfTitle: "IDEA", singer: "星野源", albumCover: UIImage(named: "IDEA"), songUrl: Bundle.main.url(forResource: "IDEA", withExtension: "mp3")!),
        SongData(songOfTitle: "POP VIRUS", singer: "星野源", albumCover: UIImage(named: "POP VIRUS"), songUrl: Bundle.main.url(forResource: "POP VIRUS", withExtension: "mp3")!),
        SongData(songOfTitle: "SUN", singer: "星野源", albumCover: UIImage(named: "SUN"), songUrl: Bundle.main.url(forResource: "SUN", withExtension: "mp3")!)
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSong(index: 0)
        
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            self.nextSong()
            self.player.play()
        }
    }
    
    func playSong(index: Int) {
        player.replaceCurrentItem(with: AVPlayerItem(url: songs[index].songUrl))
        timePass = AVPlayerItem(url: songs[index].songUrl).asset.duration.seconds
        albumCoverImageView.image = songs[index].albumCover
        songOfTitleLabel.text = songs[index].songOfTitle
        singerLabel.text = songs[index].singer
        playpauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
    }
    
    func passTime() {
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { (CMTime) in
            if self.player.currentItem?.status == .readyToPlay {
                self.progressBarSlider.value = Float(CMTimeGetSeconds(self.player.currentTime()))
                self.timePassLabel.text = self.timeFormatChange(time: CMTimeGetSeconds(self.player.currentTime()))
            }
        })
    }
                                    
    func timeLabelUpdate() {
        guard let duration = playerItem?.asset.duration else {
            return
        }
        let seconds = CMTimeGetSeconds(duration)
            timeRemainLabel.text = timeFormatChange(time: seconds)
            progressBarSlider.minimumValue = 0
            progressBarSlider.maximumValue = Float(seconds)
            progressBarSlider.isContinuous = true
    }
    
    func timeFormatChange(time: Float64) -> String {
        let songLength = Int(time)
        let min = Int(songLength / 60)
        let sec = Int(songLength % 60)
        var time = ""
        if min < 10 {
          time = "0\(min):"
        }
        else {
          time = "\(min)"
        }
        if sec < 10 {
          time += "0\(sec)"
        }
        else {
          time += "\(sec)"
        }
        return time
    }
 
    @IBAction func playpuaseChange(_ sender: UIButton) {
        if player.timeControlStatus == .playing {
            playpauseButton.setImage(UIImage(systemName: "play.fill"), for: .normal)
            player.pause()
        }
        else if player.timeControlStatus == .paused {
            playpauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
            player.play()
        }
    }
    
    
    @IBAction func nextSong() {
        if currentSongIndex == 6 {
            currentSongIndex = 0
        }
        else {
            currentSongIndex += 1
        }
        player.replaceCurrentItem(with: AVPlayerItem(url: songs[currentSongIndex].songUrl))
        albumCoverImageView.image = songs[currentSongIndex].albumCover
        songOfTitleLabel.text = songs[currentSongIndex].songOfTitle
        singerLabel.text = songs[currentSongIndex].singer
       }
    
    @IBAction func previousSong() {
        if currentSongIndex == 0 {
            currentSongIndex = 6
        }
        else {
            currentSongIndex -= 1
        }
        player.replaceCurrentItem(with: AVPlayerItem(url: songs[currentSongIndex].songUrl))
        albumCoverImageView.image = songs[currentSongIndex].albumCover
        songOfTitleLabel.text = songs[currentSongIndex].songOfTitle
        singerLabel.text = songs[currentSongIndex].singer
        }
    
    @IBAction func timeObserverSlider(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(progressBarSlider.value), timescale: 1))
    }
    
}
