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
    @IBOutlet var songOfTimeLabel: UILabel!
    @IBOutlet var playpauseButton: UIButton!
    
    let player = AVPlayer()
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
        progressBarSlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .normal)
        progressBarSlider.setThumbImage(UIImage(systemName: "circle.fill"), for: .highlighted)
        playSong()
        passTime()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: nil, queue: .main) { (_) in
            self.nextSong()
            self.playSong()
            self.player.removeTimeObserver(self.timeObserver)

        }
    }
    
    func playSong() {
        let playerItem = AVPlayerItem(url: songs[currentSongIndex].songUrl)
        player.replaceCurrentItem(with: playerItem)
        timePass = AVPlayerItem(url: songs[currentSongIndex].songUrl).asset.duration.seconds
        albumCoverImageView.image = songs[currentSongIndex].albumCover
        songOfTitleLabel.text = songs[currentSongIndex].songOfTitle
        singerLabel.text = songs[currentSongIndex].singer
        player.play()
        playpauseButton.setImage(UIImage(systemName: "pause.fill"), for: .normal)
        
        let duration = CMTimeGetSeconds(playerItem.asset.duration)
        songOfTimeLabel.text = timeFormatChange(time: duration)
        
        progressBarSlider.setValue(Float(0), animated: true)
        let targetTime: CMTime = CMTimeMake(value: Int64(0), timescale: 1)
        player.seek(to: targetTime)
        
        progressBarSlider.minimumValue = 0
        progressBarSlider.maximumValue = Float(duration)
        
        addProgressObserver(playerItem: playerItem)
        
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
    
    var timeObserver: Any?
    func addProgressObserver(playerItem: AVPlayerItem) {
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: Int64(1.0), timescale: Int32(1.0)), queue: .main) {
            [weak self] (time: CMTime) in
            let currentTime = CMTimeGetSeconds(time)
            self?.progressBarSlider.setValue(Float(currentTime), animated: true)        }
    }
    
    func passTime() {
        player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: Int64(1), timescale: Int32(1)), queue: .main , using: { (CMTime) in
            if self.player.currentItem?.status == .readyToPlay {
                let currentTime = CMTimeGetSeconds(self.player.currentTime())
                self.progressBarSlider.value = Float(currentTime)
                self.timePassLabel.text = self.timeFormatChange(time: currentTime)
                self.songOfTimeLabel.text = "\(self.timeFormatChange(time: Float64(self.progressBarSlider.maximumValue - self.progressBarSlider.value)))"
            }
        })
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
        playSong()
       }
    
    @IBAction func previousSong() {
        if currentSongIndex == 0 {
            currentSongIndex = 6
        }
        else {
            currentSongIndex -= 1
        }
        playSong()
        }
    
    @IBAction func progressBarChangeSlider(_ sender: UISlider) {
        player.seek(to: CMTimeMake(value: Int64(progressBarSlider.value), timescale: 1))
    }
    
}
