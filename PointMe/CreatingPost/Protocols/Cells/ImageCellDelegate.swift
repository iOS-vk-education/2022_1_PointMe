import Foundation


protocol ImageCellDelegate: AnyObject {
    func didTapDeleteImageButton(indexPathCell: IndexPath)
}
