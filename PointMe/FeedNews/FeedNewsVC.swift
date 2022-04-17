import UIKit

class FeedNewsViewController: UIViewController {
    
    private lazy var button: UIButton = {
        let button: UIButton = UIButton()
        
        button.setTitle("Tap", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
        
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .defaultBackgroundColor
        title = "Новости"
        
        view.addSubview(button)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        button.pin
            .center()
            .size(CGSize(width: 100, height: 50))
    }
    
    @objc func didTap() {
        let vc = PostViewController()
        vc.setup()
        navigationController?.pushViewController(vc, animated: true)
    }
}
