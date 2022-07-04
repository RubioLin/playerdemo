import UIKit

class LaunchScreenViewController: UIViewController {
    
    let hoshinoGen = "Hoshino Gen"
    var bezierText:BezierText!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "secondaryColor")
        bezierText = BezierText(frame: CGRect(x: .zero, y: .zero, width: 300, height: 100))
        bezierText.center = view.center
        view.addSubview(bezierText)
        bezierText.show(text: hoshinoGen)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Thread.sleep(forTimeInterval: TimeInterval(5))
        pageChange()
        
    }

    func pageChange() {
        let mainViewController = UIStoryboard(name: "Main", bundle: .main)
        let mVC = mainViewController.instantiateViewController(withIdentifier: "MVC")
        mVC.modalPresentationStyle = .fullScreen
        mVC.modalTransitionStyle = .flipHorizontal
        present(mVC, animated: true, completion: nil)
    }
}
