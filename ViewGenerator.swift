import Foundation
import Files

struct FilesGenerator {
    
    let nameView, nameViewModel, nameSubclass: String
    
//    let folder: Folder
//    let file: File
    
    init(viewName: String, subclassName: String) throws {

        self.nameView = viewName
        self.nameViewModel = viewName + "ViewModel"
        self.nameSubclass = subclassName
        
//        folder = try FileSystem().currentFolder.createSubfolder(named: nameView)
//        file = try folder.createFile(named: nameView + ".swift")
    }
    
    func generate() throws {
        try createView()
    }
    
    func printCode() {
        print(createViewString())
    }
    
    private func createView() throws {
//        try vFile.write(string: """
//            \(header(for: nameView))
//
//            import UIKit
//            import Cartography
//            import Stevia
//            import RxSwift
//
//            class \(nameViewModel): BaseViewModel {
//
//            }
//
//            class \(nameView): \(nameSubclass) {
//
//                let viewModel: \(nameViewModel)
//
//                init(viewModel: \(nameViewModel)) {
//                    self.viewModel = viewModel
//                    super.init(frame: .zero)
//
//                    setupViews()
//                    setupRx()
//                }
//
//                func setupViews() {
//
//                }
//
//                func setupRx() {
//
//                }
//
//                required init?(coder aDecoder: NSCoder) { return nil}
//            }
//            """)
//        try file.write(string: createViewString())
    }
    
    private func createViewString() -> String {
        return """
        \(header(for: nameView))
        
        import UIKit
        import Cartography
        import Stevia
        import RxSwift

        class \(nameViewModel): BaseViewModel {

        }

        class \(nameView): \(nameSubclass) {

            let viewModel: \(nameViewModel)

            init(viewModel: \(nameViewModel)) {
                self.viewModel = viewModel
                super.init(frame: .zero)

                setupViews()
                setupRx()
            }

            func setupViews() {

            }

            func setupRx() {

            }

            required init?(coder aDecoder: NSCoder) { return nil}
        }
        """
    }
    
    private func header(for fileName: String) -> String {
        return  """
        //
        //  \(fileName).swift
        //  DogWalkTrophy
        //
        //  Created by Maciej Krolikowski on \(todaysDateString()).
        //  Copyright © 2018 Maciej Krolikowski. All rights reserved.
        //
        """
    }
    
    func todaysDateString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        return dateFormatter.string(from: Date())
    }
}


let viewName = CommandLine.arguments[1]
let subclassName = CommandLine.arguments[2]

let fileGenerator = try FilesGenerator(viewName: viewName, subclassName: subclassName)
//try fileGenerator.generate()
fileGenerator.printCode()

