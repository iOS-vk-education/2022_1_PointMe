import UIKit
import PinLayout


final class CreatingPostViewController: UIViewController, AlertMessages {
    
    // MARK: - Private properties (UI)
    
    private lazy var loadingAlert: UIAlertController = {
        let alert = UIAlertController(
            title: "Ожидание",
            message: "Пожалуйста подождите...",
            preferredStyle: UIAlertController.Style.alert
        )
        
        let loadingIndicator = UIActivityIndicatorView(
            frame: CGRect(
                x: 10,
                y: 5,
                width: 50,
                height: 50
            )
        )
        
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating()

        alert.view.addSubview(loadingIndicator)
        
        let alertAction: UIAlertAction = UIAlertAction(title: "Отмена", style: UIAlertAction.Style.default) { [weak self] _ in
            self?.didTapForBackViewController()
        }
        alert.addAction(alertAction)
        
        return alert
    }()
    
    
    private lazy var titleTextField: UITextField = {
        let textField: UITextField = UITextField()
        
        textField.backgroundColor = .textFieldTitlePlaceColor
        textField.layer.cornerRadius = Constants.Container.baseCornerRadius
        textField.leftView = Constants.Container.paddingView4TextField
        textField.leftViewMode = .always
        textField.rightView = Constants.Container.paddingView4TextField
        textField.rightViewMode = .always
        textField.font = .textFieldPlaceholderFont
        textField.placeholder = "Введите название места"
        
        return textField
    }()
    
    
    private lazy var mapView: UIView = {
        let mapView: UIView = UIView()
        
        mapView.backgroundColor = .systemPink
        mapView.layer.cornerRadius = Constants.Container.baseCornerRadius
        
        return mapView
    }()
    
    
    private lazy var photosCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(AddPhotoCell.self, forCellWithReuseIdentifier: AddPhotoCell.id)
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.id)
        collectionView.delegate = self
        collectionView.dataSource = self
        
        return collectionView
    }()
    
    
    private lazy var commentTextView: UITextView = {
        let commentTextView: UITextView = UITextView()
        
        commentTextView.backgroundColor = .textFieldTitlePlaceColor
        commentTextView.layer.cornerRadius = Constants.Container.baseCornerRadius
        commentTextView.textContainerInset = Constants.Container.commentTextContainerInset
        commentTextView.font = .textFieldPlaceholderFont
        commentTextView.text = "Оставьте комментарий"
        commentTextView.textColor = UIColor.lightGray
        commentTextView.delegate = self
        
        return commentTextView
    }()
    
    
    private lazy var descMarkLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "Оценка"
        label.textColor = .standartLabelColor
        label.font = .labelAddMark
        
        return label
    }()
    
    
    private lazy var markLabel: UILabel = {
        let label: UILabel = UILabel()
        
        label.text = "0/5"
        label.textColor = .standartLabelColor
        label.textAlignment = .center
        label.font = .labelAddMark
        
        return label
    }()
    
    
    private lazy var circleArray: [UIView] = {
        var circles: [UIView] = []
        
        (0 ... 5).forEach { _ in
            let circleMarkView: UIView = UIView()
            let gesture: UITapGestureRecognizer = UITapGestureRecognizer(
                target: self,
                action: #selector(didTapMarkView)
            )
            
            circleMarkView.layer.cornerRadius = Constants.Container.circleMarkSize.width / 2
            circleMarkView.layer.borderColor = UIColor.buttonAddMarkColor.cgColor
            circleMarkView.layer.borderWidth = Constants.Container.circleMarkBorderWidth
            circleMarkView.backgroundColor = .clear
            circleMarkView.isUserInteractionEnabled = true
            circleMarkView.addGestureRecognizer(gesture)
            circles.append(circleMarkView)
        }
        
        return circles
    }()
    
    
    private lazy var pushButton: UIButton = {
        let button = UIButton()
        
        button.setTitle("Опубликовать", for: .normal)
        button.titleLabel?.font = .buttonTitle
        button.backgroundColor = .buttonColor
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = Constants.Container.baseCornerRadius
        
        let gesture: UILongPressGestureRecognizer = UILongPressGestureRecognizer(
            target: self,
            action: #selector(didTapPushButton)
        )
        gesture.minimumPressDuration = 0
        button.addGestureRecognizer(gesture)
        
        return button
    }()
    
    
    private lazy var scrollView: UIScrollView = {
        let scrollView: UIScrollView = UIScrollView()
        
        scrollView.contentInset = Constants.Container.scrollViewContainerInset
        
        return scrollView
    }()
    
    
    private let containerView: UIView = UIView()
    
    
    private let model: CreatingPostModel = CreatingPostModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .addPostScreenBackgroundColor
        
        setupNavigationBar()
        
        [scrollView].forEach {
            view.addSubview($0)
        }
        
        [containerView].forEach {
            scrollView.addSubview($0)
        }
        
        [titleTextField, mapView, photosCollectionView, commentTextView, descMarkLabel, markLabel, pushButton].forEach {
            containerView.addSubview($0)
        }
        
        circleArray.forEach {
            containerView.addSubview($0)
        }
    }
    
    // MARK: - Setups
    
    private func setupNavigationBar() {
        self.title = "Добавить пост"
        if let appearance = self.navigationController?.navigationBar.standardAppearance {
            appearance.titleTextAttributes = [.font: UIFont.standartTitleNavBar]
            self.navigationController?.navigationBar.standardAppearance = appearance
        }
        self.navigationController?.navigationBar.topItem?.backButtonTitle = ""
    }
    
    // MARK: - Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        scrollView.pin
            .all(view.pin.safeArea)
        
        containerView.pin
            .horizontally()
        
        titleTextField.pin
            .horizontally(Constants.Container.titleTextFieldMarginHor)
            .top()
            .height(Constants.Container.titleTextFieldHeight)
        
        mapView.pin
            .below(of: titleTextField)
            .marginTop(Constants.Container.mapViewMarginTop)
            .horizontally(Constants.Container.mapViewMarginHor)
            .height(Constants.Container.mapViewHeight)
        
        photosCollectionView.pin
            .below(of: mapView)
            .marginTop(Constants.Container.photosCollectionViewMarginTop)
            .horizontally()
            .height(Constants.Container.photosCollectionViewHeight)
        
        commentTextView.pin
            .below(of: photosCollectionView)
            .marginTop(Constants.Container.commentTextViewMarginTop)
            .horizontally(Constants.Container.commentTextViewMarginHor)
            .height(Constants.Container.commentTextViewHeight)
        
        descMarkLabel.pin
            .below(of: commentTextView)
            .marginTop(Constants.Container.labelAddMarkMarginTop)
            .height(markLabel.font.pointSize)
            .left(Constants.Container.labelAddMarkMarginLeft)
            .sizeToFit(.height)
        
        circleArray[0].pin
            .below(of: descMarkLabel)
            .marginTop(Constants.Container.markValueLabelMarginTop)
            .size(Constants.Container.circleMarkSize)
            .left(Constants.Container.circleMarkMarginLeft)
        
        circleArray[1].pin
            .below(of: descMarkLabel)
            .marginTop(Constants.Container.markValueLabelMarginTop)
            .size(Constants.Container.circleMarkSize)
            .after(of: circleArray[0])
            .marginLeft(Constants.Container.circleMarkSpaceBetween)
        
        circleArray[2].pin
            .below(of: descMarkLabel)
            .marginTop(Constants.Container.markValueLabelMarginTop)
            .size(Constants.Container.circleMarkSize)
            .after(of: circleArray[1])
            .marginLeft(Constants.Container.circleMarkSpaceBetween)
        
        circleArray[3].pin
            .below(of: descMarkLabel)
            .marginTop(Constants.Container.markValueLabelMarginTop)
            .size(Constants.Container.circleMarkSize)
            .after(of: circleArray[2])
            .marginLeft(Constants.Container.circleMarkSpaceBetween)
        
        circleArray[4].pin
            .below(of: descMarkLabel)
            .marginTop(Constants.Container.markValueLabelMarginTop)
            .size(Constants.Container.circleMarkSize)
            .after(of: circleArray[3])
            .marginLeft(Constants.Container.circleMarkSpaceBetween)
        
        markLabel.pin
            .after(of: circleArray[4])
            .marginLeft(Constants.Container.markValueLabelMarginLeft)
            .height(circleArray[4].frame.height)
            .below(of: descMarkLabel)
            .marginTop(Constants.Container.markValueLabelMarginTop)
            .sizeToFit(.height)
        
        pushButton.pin
            .below(of:circleArray[0])
            .marginTop(Constants.Container.buttonMarginTop)
            .horizontally(Constants.Container.buttonMarginHor)
            .height(Constants.Container.buttonHeight)
        
        containerView.pin
            .top()
            .wrapContent()
        
        scrollView.contentSize = containerView.frame.size
    }
    
    // MARK: - Actions
    
    @objc private func didTapMarkView(recognizer: UITapGestureRecognizer) {
        var isFindLastMark: Bool = false
        var counter: Int = 0
        
        circleArray.forEach { [weak self] markView in
            markView.backgroundColor = isFindLastMark ? .clear : .buttonAddMarkColor
            counter = isFindLastMark ? counter : counter + 1
            if markView == recognizer.view {
                isFindLastMark.toggle()
                markLabel.text = "\(counter)/5"
                self?.model.updateMark(mark: counter)
            }
        }
    }
    
    
    @objc private func didTapPushButton(recognizer: UILongPressGestureRecognizer) {
        if recognizer.state == .began {
            UIView.animate(withDuration: Constants.Button.durationAnimation) { [weak self] in
                self?.pushButton.alpha = Constants.Button.tapOpacity
            }
        }
        
        if recognizer.state == .ended {
            UIView.animate(withDuration: Constants.Button.durationAnimation) { [weak self] in
                self?.pushButton.alpha = Constants.Button.identityOpacity
            } completion: { [weak self] _ in
                guard let self = self else { return }
                self.present(self.loadingAlert, animated: true, completion: nil)
                
                let title = self.titleTextField.text
                let comment = self.commentTextView.text
                
                self.model.addPost(title: title, comment: comment) { result in
                    switch result {
                    case .success:
                        self.loadingAlert.dismiss(animated: true, completion: nil)
                        self.showInfoAlert(
                            forTitleText: "Подтверждение",
                            forBodyText: "Вы успешно добавили пост!",
                            viewController: self,
                            action: nil // FIX ME!!! - добавить переход назад
                        )
                        break
                    case .failure(let error):
                        self.loadingAlert.dismiss(animated: true, completion: nil)
                        self.showWarningAlert(
                            forTitleText: "\("Ошибка")",
                            forBodyText: error.localizedDescription,
                            viewController: self
                        )
                        break
                    }
                }
            }
        }
    }
    
    
    private func didTapForBackViewController() {
        navigationController?.popViewController(animated: true)
    }
}


extension CreatingPostViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.countImage + 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: AddPhotoCell.id,
                for: indexPath
            ) as? AddPhotoCell else {
                return UICollectionViewCell()
            }
            cell.setup()

            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ImageCell.id,
            for: indexPath
        ) as? ImageCell else {
            return UICollectionViewCell()
        }
        
        cell.setup(indexPathCell: indexPath, urlImage: model.getImageURL(for: indexPath.item - 1))
        cell.delegat = self
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.item == 0 {
            return Constants.CollectionPhoto.sizeCell4AddPhoto
        }
        
        return Constants.CollectionPhoto.sizeCell4Photo
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.CollectionPhoto.contentContainerInset
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.CollectionPhoto.lineSpacing4Section
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.item == 0 else {
            return
        }
        
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}


extension CreatingPostViewController: ImageCellDelegate {
    func didTapDeleteImageButton(indexPathCell: IndexPath) {
        photosCollectionView.deleteItems(at: [indexPathCell])
        self.model.removeByIndexURL(for: indexPathCell.item - 1)
        photosCollectionView.reloadData()
    }
}


extension CreatingPostViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            
            model.appendURL(url: imagePath)
            let indexPath = IndexPath(item: model.countImage, section: 0)
            photosCollectionView.insertItems(at: [indexPath])
        }
        
        dismiss(animated: true)
    }

    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}


extension CreatingPostViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Оставьте комментарий"
            textView.textColor = UIColor.lightGray
        }
    }
}


private extension CreatingPostViewController {
    struct Constants {
        struct Button {
            static let tapOpacity: CGFloat = 0.7
            static let identityOpacity: CGFloat = 1.0
            static let durationAnimation: TimeInterval = 0.1
        }
        
        struct Container {
            static let paddingView4TextField: UIView = UIView(
                frame: .init(
                    x: 0,
                    y: 0,
                    width: 20,
                    height: 45
                )
            )
            static let commentTextContainerInset: UIEdgeInsets = UIEdgeInsets(
                top: 15,
                left: 10,
                bottom: 15,
                right: 10
            )
            static let scrollViewContainerInset: UIEdgeInsets = UIEdgeInsets(
                top: 15,
                left: 0,
                bottom: 15,
                right: 0
            )
            
            static let baseCornerRadius: CGFloat = 10
            
            static let titleTextFieldHeight: CGFloat = 45
            static let titleTextFieldMarginHor: CGFloat = 25
            
            static let mapViewHeight: CGFloat = 260
            static let mapViewMarginHor: CGFloat = 25
            static let mapViewMarginTop: CGFloat = 15
            
            static let commentTextViewMarginTop: CGFloat = 15
            static let commentTextViewMarginHor: CGFloat = 25
            static let commentTextViewHeight: CGFloat = 125
            
            static let labelAddMarkMarginLeft: CGFloat = 25
            static let labelAddMarkMarginTop: CGFloat = 22
            
            static let markValueLabelMarginLeft: CGFloat = 15
            static let markValueLabelMarginTop: CGFloat = 10
            
            static let circleMarkMarginTop: CGFloat = 10
            static let circleMarkMarginLeft: CGFloat = 25
            static let circleMarkSize: CGSize = CGSize(width: 38, height: 38)
            static let circleMarkSpaceBetween: CGFloat = 13
            static let circleMarkBorderWidth: CGFloat = 2
            
            static let buttonMarginTop: CGFloat = 15
            static let buttonMarginHor: CGFloat = 25
            static let buttonHeight: CGFloat = 60
            
            static let photosCollectionViewMarginTop: CGFloat = 15
            static let photosCollectionViewHeight: CGFloat = 180
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
