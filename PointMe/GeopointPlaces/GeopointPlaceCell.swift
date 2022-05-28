import UIKit

final class GeopointPlaceCell: UITableViewCell {
    static let id: String = "GeopointPlaceCell"
    
    private var indexCell: Int?
    
    var delegate: GeoplacePostCellDelegate?
    
    private lazy var bodyView: UIView = {
        let bodyView: UIView = UIView()
        
        bodyView.layer.cornerRadius = 10
        bodyView.backgroundColor = .white
        
        return bodyView
    }()
    
    private lazy var titleLabel: UILabel = {
        let titleLabel: UILabel = UILabel()
        
        titleLabel.numberOfLines = 1
        titleLabel.font = .titleLabelFont
        titleLabel.textColor = .titleLabelColor
        titleLabel.textAlignment = .center
        
        return titleLabel
    }()
    
    private lazy var markLabel: UILabel = {
        let commentLabel: UILabel = UILabel()
        
        commentLabel.numberOfLines = 1
        
        return commentLabel
    }()
    
    private lazy var circleArray: [UIView] = {
        var circles: [UIView] = []
        
        (0 ... 5).forEach { _ in
            let circleMarkView: UIView = UIView()
            
            circleMarkView.layer.cornerRadius = 32 / 2
            circleMarkView.layer.borderColor = UIColor.buttonAddMarkColor.cgColor
            circleMarkView.layer.borderWidth = 2
            circleMarkView.backgroundColor = .clear
            circles.append(circleMarkView)
        }
        
        return circles
    }()
    
    private lazy var openReviewButton: UIButton = {
        let openReviewButton: UIButton = UIButton(type: .system)
        
        openReviewButton.backgroundColor = .openReviewButtonColor
        openReviewButton.setTitle("Открыть отзыв", for: .normal)
        openReviewButton.setTitleColor(.white, for: .normal)
        openReviewButton.layer.cornerRadius = 10
        openReviewButton.titleLabel?.font = .openReviewButtonFont
        openReviewButton.addTarget(self, action: #selector(didTapReviewButton), for: .touchUpInside)
        
        return openReviewButton
    }()
    
    func setup(model: PostData4Map, index: Int) {
        contentView.backgroundColor = .defaultBackgroundColor
        
        contentView.addSubview(bodyView)
        [titleLabel, openReviewButton, markLabel].forEach {
            bodyView.addSubview($0)
        }
        
        circleArray.forEach {
            bodyView.addSubview($0)
        }
        
        setupLayout()
        
        titleLabel.text = model.title
        markLabel.text = "Оценка:"
        indexCell = index
        setupCircleArray(mark: model.mark)
    }
    
    private func setupCircleArray(mark: Int) {
        (0 ..< 5).forEach {
            circleArray[$0].backgroundColor = $0 < mark ? .buttonAddMarkColor : .clear
        }
    }
    
    private func setupLayout() {
        bodyView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bodyView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            bodyView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            bodyView.leftAnchor.constraint(equalTo: contentView.leftAnchor),
            bodyView.rightAnchor.constraint(equalTo: contentView.rightAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: bodyView.topAnchor, constant: 10),
            titleLabel.leftAnchor.constraint(equalTo: bodyView.leftAnchor, constant: 15),
            titleLabel.rightAnchor.constraint(equalTo: bodyView.rightAnchor, constant: -15),
            titleLabel.heightAnchor.constraint(equalToConstant: titleLabel.font.pointSize * 1.5)
        ])
        
        markLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            markLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10),
            markLabel.leftAnchor.constraint(equalTo: bodyView.leftAnchor, constant: 15),
            markLabel.rightAnchor.constraint(equalTo: bodyView.centerXAnchor, constant: -15),
            markLabel.heightAnchor.constraint(equalToConstant: markLabel.font.pointSize * 1.2)
        ])
        
        circleArray[0].translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleArray[0].topAnchor.constraint(equalTo: markLabel.bottomAnchor, constant: 5),
            circleArray[0].leftAnchor.constraint(equalTo: bodyView.leftAnchor, constant: 15),
            circleArray[0].heightAnchor.constraint(equalToConstant: 32),
            circleArray[0].widthAnchor.constraint(equalToConstant: 32)
        ])
        
        circleArray[1].translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleArray[1].topAnchor.constraint(equalTo: markLabel.bottomAnchor, constant: 5),
            circleArray[1].leftAnchor.constraint(equalTo: circleArray[0].rightAnchor, constant: 13),
            circleArray[1].heightAnchor.constraint(equalToConstant: 32),
            circleArray[1].widthAnchor.constraint(equalToConstant: 32)
        ])
        
        circleArray[2].translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleArray[2].topAnchor.constraint(equalTo: markLabel.bottomAnchor, constant: 5),
            circleArray[2].leftAnchor.constraint(equalTo: circleArray[1].rightAnchor, constant: 13),
            circleArray[2].heightAnchor.constraint(equalToConstant: 32),
            circleArray[2].widthAnchor.constraint(equalToConstant: 32)
        ])
        
        circleArray[3].translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleArray[3].topAnchor.constraint(equalTo: markLabel.bottomAnchor, constant: 5),
            circleArray[3].leftAnchor.constraint(equalTo: circleArray[2].rightAnchor, constant: 13),
            circleArray[3].heightAnchor.constraint(equalToConstant: 32),
            circleArray[3].widthAnchor.constraint(equalToConstant: 32)
        ])
        
        circleArray[4].translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            circleArray[4].topAnchor.constraint(equalTo: markLabel.bottomAnchor, constant: 5),
            circleArray[4].leftAnchor.constraint(equalTo: circleArray[3].rightAnchor, constant: 13),
            circleArray[4].heightAnchor.constraint(equalToConstant: 32),
            circleArray[4].widthAnchor.constraint(equalToConstant: 32)
        ])
        
        openReviewButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            openReviewButton.bottomAnchor.constraint(equalTo: bodyView.bottomAnchor, constant: -10),
            openReviewButton.leftAnchor.constraint(equalTo: bodyView.leftAnchor, constant: 15),
            openReviewButton.rightAnchor.constraint(equalTo: bodyView.rightAnchor, constant: -15),
            openReviewButton.heightAnchor.constraint(equalToConstant: 45)
        ])
        
    }
    
    @objc private func didTapReviewButton() {
        delegate?.didTapButton(senderIndex: indexCell)
    }
}


protocol GeoplacePostCellDelegate {
    func didTapButton(senderIndex: Int?)
}
