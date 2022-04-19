//
//  BaseRepository.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 01/04/2022.
//

import Foundation
import CoreData
import RealmSwift

class BaseRepository: NSObject {
    
    override init() {
        super.init()
        debugPrint("Default Realm is at \(realDB.configuration.fileURL?.absoluteString ?? "undefined")")
    }
    let coreData = CoreDataStack.shared
    let realDB = try! Realm()
    
    
    //https://stackoverflow.com/questions/2262704/iphone-core-data-production-error-handling
    func handleError(_ anError: Error?) -> String{
        if let anError = anError, (anError as NSError).domain == "NSCocoaErrorDomain" {
            let nsError = anError as NSError
            if nsError.domain.compare("NSCocoaErrorDomain") == .orderedSame {
                    var messages:String = "Reason(s):\n"
                    var errors = [AnyObject]()
                    if (nsError.code == NSValidationMultipleErrorsError) {
                        errors = nsError.userInfo[NSDetailedErrorsKey] as! [AnyObject]
                    } else {
                        errors = [AnyObject]()
                        errors.append(nsError)
                    }
                    if (errors.count > 0) {
                        for error in errors {
                            if (error as? NSError)!.userInfo.keys.contains("conflictList") {
                                messages =  messages.appending("Generic merge conflict. see details : \(error)")
                            } else {
                                let entityName = "\(String(describing: (nsError.userInfo["NSValidationErrorObject"] as! NSManagedObject).entity.name))"
                                let attributeName = "\(String(describing: nsError.userInfo["NSValidationErrorKey"]))"
                                var msg = ""
                                switch (error.code) {
                                case NSManagedObjectValidationError:
                                    msg = "Generic validation error.";
                                    break;
                                case NSValidationMissingMandatoryPropertyError:
                                    msg = String(format:"The attribute '%@' mustn't be empty.", attributeName)
                                    break;
                                case NSValidationRelationshipLacksMinimumCountError:
                                    msg = String(format:"The relationship '%@' doesn't have enough entries.", attributeName)
                                    break;
                                case NSValidationRelationshipExceedsMaximumCountError:
                                    msg = String(format:"The relationship '%@' has too many entries.", attributeName)
                                    break;
                                case NSValidationRelationshipDeniedDeleteError:
                                    msg = String(format:"To delete, the relationship '%@' must be empty.", attributeName)
                                    break;
                                case NSValidationNumberTooLargeError:
                                    msg = String(format:"The number of the attribute '%@' is too large.", attributeName)
                                    break;
                                case NSValidationNumberTooSmallError:
                                    msg = String(format:"The number of the attribute '%@' is too small.", attributeName)
                                    break;
                                case NSValidationDateTooLateError:
                                    msg = String(format:"The date of the attribute '%@' is too late.", attributeName)
                                    break;
                                case NSValidationDateTooSoonError:
                                    msg = String(format:"The date of the attribute '%@' is too soon.", attributeName)
                                    break;
                                case NSValidationInvalidDateError:
                                    msg = String(format:"The date of the attribute '%@' is invalid.", attributeName)
                                    break;
                                case NSValidationStringTooLongError:
                                    msg = String(format:"The text of the attribute '%@' is too long.", attributeName)
                                    break;
                                case NSValidationStringTooShortError:
                                    msg = String(format:"The text of the attribute '%@' is too short.", attributeName)
                                    break;
                                case NSValidationStringPatternMatchingError:
                                    msg = String(format:"The text of the attribute '%@' doesn't match the required pattern.", attributeName)
                                    break;
                                default:
                                    msg = String(format:"Unknown error (code %i).", error.code) as String
                                    break;
                                }
                                messages = messages.appending("\(entityName).\(attributeName):\(msg)\n")
                            }
                        }
                    }
                    return messages
                }
        }
        return ""
    }
    
}
