//
//  SettingsViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/5/2.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Eureka

class SettingsViewController: FormViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        setUpSections()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setUpSections() {
        form +++ Section("Section1")
            <<< TextRow { row in
                row.title = "Text Row"
                row.placeholder = "Enter text here"
            }.onCellSelection({ (_, _) in
                 print ("WALALA")
            })

            <<< PushRow<String>("Relationship Status") {
                $0.title = "Relationship Status"
                $0.value = "12312312313" //maritalStatus.capitalizedString

                }.cellSetup {cell, _ in
                    cell.textLabel?.textColor = UIColor.white
                    cell.detailTextLabel?.textColor = UIColor.white

//                    row.presentationMode = .show(controllerProvider: ControllerProvider.callback {
//                        return MyViewController<T>(){ _ in }
//                        }, completionCallback: { vc in
//                            vc.navigationController?.popViewController(animated: true)
//                    })

                    cell.tintColor = UIColor.white
                }.onPresent { _, to in
                    to.view.layoutSubviews()

                    // Appearance

                }.onCellSelection({ (_, _) in
                    print("yay")
                })

            <<< LabelRow {
                $0.title = "LabelRow"
                $0.value = "tap the row"
                }
                .onCellSelection { _, _ in
                    print ("CUTE")
            }

            <<< PhoneRow {
                $0.title = "Phone Row"
                $0.placeholder = "And numbers here"
            }
            +++ Section("Section2")
            <<< DateRow {
                $0.title = "Date Row"
                $0.value = Date(timeIntervalSinceReferenceDate: 0)
            }
            +++ Section("Section3")
            <<< EmailRow {
                $0.title = "mail"
                $0.placeholder = "輸入email帳號"
            }
            <<< SliderRow {
                $0.maximumValue = 100
                $0.minimumValue = 0
                $0.steps = 25
            }

            +++ Section("Testing hidden row")
            <<< SwitchRow("switchRowTag") {
                $0.title = "this"
            }
            <<< LabelRow {

                $0.hidden = Condition.function(["switchRowTag"], { form in
                    return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                })
                $0.title = "row"
            }
            <<< LabelRow {

                $0.hidden = Condition.function(["switchRowTag"], { form in
                    return !((form.rowBy(tag: "switchRowTag") as? SwitchRow)?.value ?? false)
                })
                $0.title = "is hidden"
            }

    }
}
