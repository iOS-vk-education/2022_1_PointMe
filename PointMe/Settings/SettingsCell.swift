import UIKit

final class SettingsCell: UITableViewCell {
    
    private let titleLabel: UILabel = UILabel()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        setupCell()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupCell()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func setupConstraint() {
        contentView.addSubview(titleLabel)
        
        titleLabel.pin
            .vCenter()
            .horizontally(12)
    }
    
    private func setupCell() {
        titleLabel.font = UIFont.settingsTitle
        titleLabel.tintColor = .defaultBlackColor
        titleLabel.textAlignment = .left
    }
    
    func configure(title: String) {
        titleLabel.text = title
    }
}
