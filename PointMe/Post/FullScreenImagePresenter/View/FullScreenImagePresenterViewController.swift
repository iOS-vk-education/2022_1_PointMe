import UIKit
import PinLayout


final class FullScreenImagePresenterViewController: UIViewController {
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(FullScreenImagePresenterCell.self, forCellWithReuseIdentifier: FullScreenImagePresenterCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    var isNavControllerHide: Bool = false
    
    let model: FullScreenImagePresenterModel = FullScreenImagePresenterModel()
    
    init(context: FullScreenImagePresenterContext) {
        super.init(nibName: nil, bundle: nil)
        model.setImageData(imageData: context.imageData)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        title = "\(1) из \(model.countData)"
        view.addSubview(photosCollectionView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        navigationController?.setNavigationBarHidden(isNavControllerHide, animated: true)
        
        photosCollectionView.pin
            .top(view.pin.safeArea.top)
            .bottom(view.pin.safeArea.bottom)
            .horizontally()
    }
}
    
extension FullScreenImagePresenterViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.countData
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: FullScreenImagePresenterCell.id,
            for: indexPath
        ) as? FullScreenImagePresenterCell else {
            return UICollectionViewCell()
        }
        
        cell.delegate = self
        cell.setup(imageData: model.getImageData(index: indexPath.item))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return view.frame.size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x / view.frame.width)
        title = "\(index + 1) из \(model.countData)"
    }
}

extension FullScreenImagePresenterViewController: FullScreenImagePresenterCellDelegate {
    func didTapCell() {
        isNavControllerHide.toggle()
        navigationController?.setNavigationBarHidden(isNavControllerHide, animated: false)
    }
}

struct FullScreenImagePresenterContext {
    let imageData: [Data?]
}
