import Foundation
import Files

struct FilesGenerator {
    
    let name, nameTableView, nameTableViewModel, nameTableCellViewModel, nameTableViewCell: String
    
    let modelName: String
    
    let folder: Folder
    let tableViewFile, tableViewModelFile, tableCellViewModelFile, tableCellFile: File
    
    init(screenNameSingularForm: String, modelName: String) throws {
        
        self.modelName = modelName
        
        name = screenNameSingularForm
        nameTableView = name + "s" + "TableView"
        nameTableViewModel = name + "s" + "TableViewModel"
        nameTableCellViewModel = name + "CellViewModel"
        nameTableViewCell = name + "TableViewCell"
        
        folder = try FileSystem().currentFolder.createSubfolder(named: name + "s" + "TableView")
        tableViewFile = try folder.createFile(named: nameTableView + ".swift")
        tableViewModelFile = try folder.createFile(named: nameTableViewModel + ".swift")
        tableCellViewModelFile = try folder.createFile(named: nameTableCellViewModel + ".swift")
        tableCellFile = try folder.createFile(named: nameTableViewCell + ".swift")
    }
    
    func generate() throws {
        try createTableView()
        try createTableViewModel()
        try createTableCellViewModel()
        try createTableCellView()
    }
    
    private func createTableView() throws {
        try tableViewFile.write(string: """
            \(header(for: nameTableView))
            
            import UIKit
            import RxSwift
            
            class \(nameTableView): GenericTableView<\(nameTableViewModel), \(nameTableViewCell)> {
            
            }
            """)
    }
    
    private func createTableViewModel() throws {
        try tableViewModelFile.write(string: """
            \(header(for: nameTableViewModel))
            
            import UIKit
            import RxSwift
            
            class \(nameTableViewModel): GenericTableViewModel<\(nameTableCellViewModel)> {
            
                override func getItems() -> Observable<[\(modelName)]> {
                    return Observable.just(Mocks.awardsAchieved())
                }
            
                override func mapToItemViewModel(_ item: \(modelName)) -> \(nameTableCellViewModel) {
                    return \(nameTableCellViewModel)(model: item)
                }
            }
            """)
    }
    
    private func createTableCellViewModel() throws  {
        
        try tableCellViewModelFile.write(string: """
            \(header(for: nameTableCellViewModel))
            
            import UIKit
            import RxSwift
            import Stevia
            
            class \(nameTableCellViewModel): GenericCellViewModelType {
            
                typealias ItemType = \(modelName)
            
                var model: \(modelName)
            
                init(model: \(modelName)) {
                    self.model = model
                }
            }
            """)
    }
    
    private func createTableCellView() throws  {
        try tableCellFile.write(string: """
            \(header(for: nameTableViewCell))
            
            import Foundation
            import RxFlow
            import Stevia
            
            class \(nameTableViewCell): UITableViewCell {
            
                override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
                    super.init(style: .default, reuseIdentifier: nil)
                }
            
                required init?(coder aDecoder: NSCoder) { return nil }
            }
            
            extension \(nameTableViewCell): Configurable {
            
                func configure(with viewModel: AnyObject) {
                    guard let viewModel = viewModel as? \(nameTableCellViewModel) else { return }
            
                }
            }
            """)
    }
    
    private func header(for fileName: String) -> String {
        return  """
        //
        //  \(fileName).swift
        //  DogWalkTrophy
        //
        //  Created by Maciej Krolikowski on 23/04/2018.
        //  Copyright © 2018 Maciej Krolikowski. All rights reserved.
        //
        """
    }
}

let fileGenerator = try FilesGenerator(screenNameSingularForm: "ShopDetailsAward", modelName: "Product")
try fileGenerator.generate()



