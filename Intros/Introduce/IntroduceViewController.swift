import Foundation
import UIKit
import RxSwift
import RxCocoa
import CleanroomLogger

class PresentCodeViewController: UIViewController {
    var viewModel: IntroduceViewModelType!
    
    @IBOutlet
    weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        viewModel.qrCodeImage.driveNext { image in
            self.imageView.image = image
        }
        .addDisposableTo(rx_disposeBag)
    }
}

class IntroduceViewController: UIViewController, UIPageViewControllerDataSource {
    var viewModel: IntroduceViewModelType!
    
//    @IBOutlet
//    var prepareViewController: PrepareIntroductionViewController! = IntroducePage.storyboard.instantiateViewControllerWithIdentifier("prepareIntro") as! PrepareIntroductionViewController
    var prepareViewController: PrepareIntroductionViewController {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("prepareIntro") as! PrepareIntroductionViewController
        vc.viewModel = viewModel
        return vc
    }
    
    var codeViewController: PresentCodeViewController {
        let vc = storyboard?.instantiateViewControllerWithIdentifier("presentCode") as! PresentCodeViewController
        vc.viewModel = viewModel
        return vc
    }
    
//    @IBOutlet
//    var codeViewController: PresentCodeViewController! = IntroducePage.storyboard.instantiateViewControllerWithIdentifier("presentCode") as! PresentCodeViewController
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if let _ = viewController as? PrepareIntroductionViewController {
            return codeViewController
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if let _ = viewController as? PresentCodeViewController {
            return prepareViewController
        }
        
        return nil
    }
    
    override func viewDidLoad() {
        let pageVC = UIPageViewController(transitionStyle: .Scroll, navigationOrientation: .Vertical, options: nil)
        pageVC.dataSource = self
        
        pageVC.setViewControllers([prepareViewController], direction: .Forward, animated: false, completion: nil)
        
        addChildViewController(pageVC)
        view.addSubview(pageVC.view)
    }
}