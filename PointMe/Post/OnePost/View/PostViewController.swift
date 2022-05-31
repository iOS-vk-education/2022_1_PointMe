import UIKit
import PinLayout
import YandexMapsMobile
import CoreLocation

final class PostViewController: UIViewController {
    
    private lazy var userImageButton: UIButton = {
        let userImageButton: UIButton = UIButton()
        
        userImageButton.layer.masksToBounds = true
        userImageButton.imageView?.contentMode = .scaleAspectFill
        userImageButton.layer.cornerRadius = Constants.UserHeader.userImageSize.width / 2
        userImageButton.layer.borderWidth = Constants.UserHeader.userImageBorderWidth
        userImageButton.layer.borderColor = UIColor.userImageBorderColor.cgColor
        userImageButton.addTarget(self, action: #selector(userImageTap), for: .touchUpInside)
        
        return userImageButton
    }()
    
    var delegateUserImage: TapAvatarDelegate?
    private var uid: String = ""
    
    @objc
    private func userImageTap() {
        if(uid != DatabaseManager.shared.currentUserUID) {
            let builder = SomeOneAccountBuilder()
            let viewController = builder.build(uid: uid)
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
    
    private lazy var usernameLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.font = .usernameLabel
        label.textColor = .labelUsernameColor
        
        return label
    }()
    
    
    private lazy var dateLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.font = .dateLabel
        label.textColor = .labelUsernameColor
        
        return label
    }()
    
    
    private lazy var separatorView: UIView = {
        let separatorView: UIView = UIView()
        
        separatorView.backgroundColor = .separatorColor
        
        return separatorView
    }()
    
    
    private lazy var titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        
        titleLabel.font = .titlePost
        titleLabel.numberOfLines = 2
        titleLabel.textColor = .titlePostColor
        
        return titleLabel
    }()
    
    
    private lazy var chartButton: UIButton = {
        let button: UIButton = UIButton()

        button.addTarget(self, action: #selector(didTapChartButton), for: .touchUpInside)
        button.tintColor = .chartButtonColor

        return button
    }()
    
    
    private lazy var mapView: YMKMapView = {
        let mapView: YMKMapView = YMKMapView()
        
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = Constants.Container.mapViewCornerRadius
        
        return mapView
    }()
    
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ImagePresentCell.self, forCellWithReuseIdentifier: ImagePresentCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    
    private lazy var commentLabel: UILabel = {
        let commentLabel: UILabel = UILabel()
        
        commentLabel.numberOfLines = 15
        commentLabel.font = .commentPost
        commentLabel.textColor = .commentPostColor
        
        return commentLabel
    }()
    
    
    private lazy var circleArray: [UIView] = {
        var circles: [UIView] = []
        
        (0 ... 5).forEach { _ in
            let circleMarkView: UIView = UIView()
            
            circleMarkView.layer.cornerRadius = Constants.Container.circleMarkSize.width / 2
            circleMarkView.layer.borderColor = UIColor.buttonAddMarkColor.cgColor
            circleMarkView.layer.borderWidth = Constants.Container.circleMarkBorderWidth
            circleMarkView.backgroundColor = .clear
            circles.append(circleMarkView)
        }
        
        return circles
    }()
    
    
    private lazy var markLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.textColor = .standartLabelColor
        label.textAlignment = .center
        label.font = .labelAddMark
        
        return label
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        
        scrollView.contentInset = Constants.Container.scrollViewContainerInset
        
        return scrollView
    }()
    
    
    private let containerView: UIView = UIView()
    
    private let model: PostViewControllerModel = PostViewControllerModel()
    
    private var placemark: YMKPlacemarkMapObject?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .backgroundPostViewController
        
        if let standardAppearance = self.navigationController?.navigationBar.standardAppearance,
            let scrollAppearance = self.navigationController?.navigationBar.scrollEdgeAppearance {
            standardAppearance.titleTextAttributes = [.font: UIFont.standartTitleNavBar]
            scrollAppearance.titleTextAttributes = [.font: UIFont.standartTitleNavBar]
        }
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .navBarItemColor
        
        view.addSubview(scrollView)
        scrollView.addSubview(containerView)
        
        [titleLabel, mapView, chartButton, userImageButton, usernameLabel, dateLabel, separatorView, commentLabel, markLabel].forEach {
            containerView.addSubview($0)
        }
        
        if model.isImagesExist {
            containerView.addSubview(photosCollectionView)
        }
        
        circleArray.forEach {
            containerView.addSubview($0)
        }
        
        userImageButton.setImage(UIImage(named: "avatar"), for: .normal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setup(context: PostContextWithoutAvatar) {
        uid = context.uid
        model.fetchDataWithAvatar(context: context) { [weak self] result in
            switch result {
            case .success():
                print("debug: success fill data without avatar")
                self?.fillData()
                break
            case .failure(_):
                break
            }
        }
    }
    
    func setup(context: PostContext) {
        uid = context.uid
        model.fetchData(context: context) { [weak self] result in
            switch result {
            case .success():
                print("debug: success fill data")
                self?.fillData()
                break
            case .failure(_):
                break
            }
        }
    }
    
    
    func fillData() {
        usernameLabel.text = model.username
        dateLabel.text = model.date
        titleLabel.text = model.title
        commentLabel.text = model.commentText
        markLabel.text = "\(model.mark)/5"
        setupCircleArray()
        
        photosCollectionView.reloadData()
        
        let imageForButton: UIImage? = model.isChartPost ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        chartButton.setBackgroundImage(imageForButton, for: .normal)
        
        if let dataAvatar = model.avatar {
            userImageButton.setImage(UIImage(data: dataAvatar), for: .normal)
        }
        
        viewDidLayoutSubviews()
        
        let point = CLLocationCoordinate2D(latitude: model.currentLocation.latitude, longitude: model.currentLocation.longitude)
        setMap(location: point)
    }
    
    
    private func setupCircleArray() {
        (0 ..< 5).forEach {
            circleArray[$0].backgroundColor = $0 < model.mark ? .buttonAddMarkColor : .clear
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin
            .all(view.pin.safeArea)
        
        containerView.pin
            .horizontally()
        
        userImageButton.pin
            .top(Constants.UserHeader.userImageMarginTop)
            .left(Constants.UserHeader.userImageMarginLeft)
            .size(Constants.UserHeader.userImageSize)
        
        separatorView.pin
            .below(of: userImageButton)
            .marginTop(Constants.UserHeader.separatorMarginTop)
            .height(Constants.UserHeader.separatorWidth)
            .horizontally()
        
        usernameLabel.pin
            .after(of: userImageButton)
            .marginLeft(Constants.UserHeader.usernameLabelMarginLeft)
            .top(Constants.UserHeader.usernameLabelMarginTop)
            .height(Constants.UserHeader.usernameLabelHeight)
            .width(200)
        
        dateLabel.pin
            .after(of: userImageButton)
            .marginLeft(Constants.UserHeader.dateLabelMarginLeft)
            .top(Constants.UserHeader.dateLabelMarginTop)
            .height(Constants.UserHeader.dateLabelHeight)
            .width(200)
        
        chartButton.pin
            .below(of: separatorView)
            .marginTop(Constants.Container.chartButtonMarginTop)
            .right(Constants.Container.chartButtonMarginRight)
            .size(Constants.Container.chartButtonSize)
        
        titleLabel.pin
            .below(of: separatorView)
            .marginTop(Constants.Container.titleMarginTop)
            .left(Constants.Container.titleMarginLeft)
            .width(70%)
            .before(of: chartButton)
            .marginRight(Constants.Container.titleMarginRight)
            .height(titleLabel.font.pointSize * 3)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(
                equalTo: titleLabel.bottomAnchor,
                constant: Constants.Container.mapViewMarginTop
            ),
            mapView.leftAnchor.constraint(
                equalTo: view.leftAnchor,
                constant: Constants.Container.mapViewMarginHor
            ),
            mapView.rightAnchor.constraint(
                equalTo: view.rightAnchor,
                constant: -Constants.Container.mapViewMarginHor
            ),
            mapView.heightAnchor.constraint(
                equalToConstant: Constants.Container.mapViewHeight
            )
        ])
        
        if model.isImagesExist {
            
            photosCollectionView.pin
                .below(of: mapView)
                .marginTop(Constants.Container.photosCollectionViewMarginTop)
                .horizontally()
                .height(Constants.Container.photosCollectionViewHeight)
            
            commentLabel.pin
                .below(of: photosCollectionView)
                .marginTop(Constants.Container.commentLabelMarginTop)
                .horizontally(Constants.Container.commentLabelMarginHor)
                .sizeToFit(.width)
        } else {
            commentLabel.pin
                .below(of: mapView)
                .marginTop(Constants.Container.commentLabelMarginTop)
                .horizontally(Constants.Container.commentLabelMarginHor)
                .sizeToFit(.width)
        }
        
        circleArray[0].pin
            .below(of: commentLabel)
            .marginTop(Constants.Container.circleMarkMarginTop)
            .size(Constants.Container.circleMarkSize)
            .left(Constants.Container.circleMarkMarginLeft)
        
        circleArray[1].pin
            .below(of: commentLabel)
            .marginTop(Constants.Container.circleMarkMarginTop)
            .size(Constants.Container.circleMarkSize)
            .after(of: circleArray[0])
            .marginLeft(Constants.Container.circleMarkSpaceBetween)
        
        circleArray[2].pin
            .below(of: commentLabel)
            .marginTop(Constants.Container.circleMarkMarginTop)
            .size(Constants.Container.circleMarkSize)
            .after(of: circleArray[1])
            .marginLeft(Constants.Container.circleMarkSpaceBetween)
        
        circleArray[3].pin
            .below(of: commentLabel)
            .marginTop(Constants.Container.circleMarkMarginTop)
            .size(Constants.Container.circleMarkSize)
            .after(of: circleArray[2])
            .marginLeft(Constants.Container.circleMarkSpaceBetween)
        
        circleArray[4].pin
            .below(of: commentLabel)
            .marginTop(Constants.Container.circleMarkMarginTop)
            .size(Constants.Container.circleMarkSize)
            .after(of: circleArray[3])
            .marginLeft(Constants.Container.circleMarkSpaceBetween)
        
        markLabel.pin
            .after(of: circleArray[4])
            .marginLeft(Constants.Container.markValueLabelMarginLeft)
            .height(circleArray[4].frame.height)
            .below(of: commentLabel)
            .marginTop(Constants.Container.markValueLabelMarginTop)
            .sizeToFit(.height)
        
        containerView.pin
            .top()
            .wrapContent(.vertically)
        
        scrollView.contentSize = containerView.frame.size
    }
    
    
    @objc private func didTapChartButton() {
        model.toggleChartPost(completion: { [weak self] result in
            guard let self = self else {
                return
            }
            
            switch result {
            case .success():
                let imageForButton: UIImage? = self.model.isChartPost ?
                    UIImage(systemName: "star.fill") :
                    UIImage(systemName: "star")
                self.chartButton.setBackgroundImage(imageForButton, for: .normal)
                break
            case .failure(_):
                print("failure toggle button chart")
                break
            }
        })
    }
    
    private func setMap(location: CLLocationCoordinate2D) {
        let point = YMKPoint(latitude: location.latitude, longitude: location.longitude)
        
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(target: point, zoom: 15, azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil
        )
        
        guard let iconPin = UIImage(named: "pin") else {
            return
        }
        
        let mapObjects: YMKMapObjectCollection = mapView.mapWindow.map.mapObjects
        
        if placemark != nil {
            mapObjects.clear()
        }
        
        placemark = mapObjects.addPlacemark(with: location.pointYMK)
        placemark?.opacity = 1
        placemark?.setIconWith(iconPin, style: YMKIconStyle(
            anchor: CGPoint(x: 0.5, y: 1) as NSValue,
            rotationType: YMKRotationType.noRotation.rawValue as NSNumber,
            zIndex: 0,
            flat: false,
            visible: true,
            scale: 0.7,
            tappableArea: YMKRect(min: CGPoint(x: 0, y: 0), max: CGPoint(x: 1, y: 1))
        ))
    }
}

extension PostViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.countDataImages
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImagePresentCell.id,
            for: indexPath
        ) as? ImagePresentCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(dataImage: model.getDataImageByIndex(index: indexPath.item))
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.CollectionPhoto.sizeCell4Photo
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.CollectionPhoto.contentContainerInset
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionPhoto.lineSpacing4Section
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let context: FullScreenImagePresenterContext = FullScreenImagePresenterContext(imageData: model.sendDataImages())
        let fullScreenImageViewController: FullScreenImagePresenterViewController = FullScreenImagePresenterViewController(context: context)
        navigationController?.pushViewController(fullScreenImageViewController, animated: true)
    }
}

private extension PostViewController {
    struct Constants {
        struct UserHeader {
            static let userImageSize: CGSize = CGSize(width: 60, height: 60)
            static let userImageMarginTop: CGFloat = 15
            static let userImageMarginLeft: CGFloat = 25
            static let userImageBorderWidth: CGFloat = 2
            
            static let separatorWidth: CGFloat = 1
            static let separatorMarginTop: CGFloat = 15
            
            static let usernameLabelHeight: CGFloat = 30
            static let usernameLabelMarginLeft: CGFloat = 9
            static let usernameLabelMarginTop: CGFloat = 15
            
            static let dateLabelHeight: CGFloat = 30
            static let dateLabelMarginTop: CGFloat = 45
            static let dateLabelMarginLeft: CGFloat = 9
        }
        
        struct Container {
            static let scrollViewContainerInset: UIEdgeInsets = UIEdgeInsets(
                top: 15,
                left: 0,
                bottom: 15,
                right: 0
            )
            
            static let titleMarginTop: CGFloat = 12
            static let titleMarginRight: CGFloat = 10
            static let titleMarginLeft: CGFloat = 25
            static let titleHeight: CGFloat = 60
            
            static let chartButtonMarginTop: CGFloat = 27
            static let chartButtonMarginRight: CGFloat = 25
            static let chartButtonSize: CGSize = CGSize(width: 30, height: 30)
            
            static let mapViewCornerRadius: CGFloat = 10
            static let mapViewHeight: CGFloat = 260
            static let mapViewMarginHor: CGFloat = 25
            static let mapViewMarginTop: CGFloat = 15
            
            static let photosCollectionViewMarginTop: CGFloat = 15
            static let photosCollectionViewHeight: CGFloat = 180
            
            static let commentLabelMarginTop: CGFloat = 15
            static let commentLabelMarginHor: CGFloat = 25
            
            static let markValueLabelMarginLeft: CGFloat = 15
            static let markValueLabelMarginTop: CGFloat = 25
            
            static let circleMarkMarginTop: CGFloat = 25
            static let circleMarkMarginLeft: CGFloat = 25
            static let circleMarkSize: CGSize = CGSize(width: 38, height: 38)
            static let circleMarkSpaceBetween: CGFloat = 13
            static let circleMarkBorderWidth: CGFloat = 2
        }
        
        struct CollectionPhoto {
            static let contentContainerInset: UIEdgeInsets = UIEdgeInsets(
                top: 0,
                left: 25,
                bottom: 0,
                right: 25
            )
            
            static let lineSpacing4Section: CGFloat = 15
            static let sizeCell4AddPhoto: CGSize = CGSize(width: 135, height: 135)
            static let sizeCell4Photo: CGSize = CGSize(width: 180, height: 180)
        }
    }
}
