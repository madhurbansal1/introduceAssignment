//
//  firebaseManager.swift
//  introduceAssignment
//
//  Created by madhur bansal on 5/11/21.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

public class firebaseManager
{
    var db: Firestore!
    var storage:StorageReference!
    
    init()
    {
        let settings = FirestoreSettings()
        Firestore.firestore().settings = settings
        self.db = Firestore.firestore()
        
        storage = Storage.storage().reference()
    }
    
    func fetchUsers(completion:@escaping([userStruct])->Void)
    {
        var userArray:[userStruct] = []
        let docRef = db.collection("users").order(by: "timestamp", descending: true)
        
        docRef.getDocuments { (snapshot, error) in
            if error == nil
            {
                if let snapshot = snapshot
                {
                    for document in snapshot.documents
                    {
                        let data = document.data()
                        print(data)
                        let name = data["name"] as! String
                        let city = data["homeTown"] as! String
                        let gender = data["gender"] as! String
                        let number = data["number"] as! Int
                        let imageStr = data["imageStr"] as! String
                        let firebaseId = data["firebaseId"] as! String
                        let DOBStr = data["dateOfBirth"] as! String
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd-MM-yyyy"
                        let dateOfBirth = dateFormatter.date(from: DOBStr)
                        let age = dateOfBirth?.age
                        let element = userStruct(firebaseId: firebaseId, name: name, phoneNumber: number, gender: gender, age: age!, city: city, imageStr: imageStr)
                        print(element)
                        userArray.append(element)
                    }
                    completion(userArray)
                }
            }
            else
            {
                completion([])
                print(error?.localizedDescription as Any)
            }
        }
    }
    
    func deleteUser(firebaseId:String,completion:@escaping(String)->Void)
    {
        let docRef = db.collection("users").document(firebaseId)
        
        deleteImage(firebaseId: firebaseId) { (success) in
            if success
            {
                docRef.delete { (error) in
                    if error == nil
                    {
                        completion("user is deleted")
                    }
                    else
                    {
                        completion(error!.localizedDescription)
                    }
                }
            }
            else
            {
                completion("problem encountered while deleting image")
            }
        }
    }
    
    func enrollUser(profileImage:UIImage,name:String,number:Int,telephoneNumber:Int,gender:String,country:String,state:String,homeTown:String,dateOfbirth:String,completion:@escaping(String)->Void)
    {
        let docRef = db.collection("users")
        
        var userData:[String:Any] = [:]
        let aDoc = docRef.document()
        
        uploadImage(image: profileImage, firebaseId: aDoc.documentID) { (imageStr) in
            let timestamp = NSDate().timeIntervalSince1970
            userData = ["number":number,"gender":gender,"state":state,"telephoneNumber":telephoneNumber,"homeTown":homeTown,"country":country,"name":name,"imageStr":imageStr,"dateOfBirth":dateOfbirth,"firebaseId":aDoc.documentID,"timestamp":timestamp]
            
            aDoc.setData(userData) { (error) in
                if error == nil
                {
                    completion("user is enrolled")
                }
                else
                {
                    completion(error!.localizedDescription)
                }
            }

        }
    }
    
    private func uploadImage(image:UIImage,firebaseId:String,completion:@escaping(String)->Void)
    {
        var data = Data()
        data = image.jpegData(compressionQuality: 0.8)!
        let imagePath = "profileImages/\(firebaseId).png"
        let ref = storage.child(imagePath)
                
        ref.putData(data).observe(.success) { (snapshot) in
            ref.downloadURL{ (url, error) in
                if error == nil
                {
                    print(url?.absoluteString as Any)
                    completion(url!.absoluteString)
                }
                else
                {
                    print(error?.localizedDescription as Any)
                    completion("")
                }
            }
        }
    }
    
    private func deleteImage(firebaseId:String,completion:@escaping(Bool)->Void)
    {
        let imagePath = "profileImages/\(firebaseId).png"
        let ref = storage.child(imagePath)
        
        ref.delete { (error) in
            if error == nil
            {
                completion(true)
            }
            else
            {
                print(error?.localizedDescription as Any)
                completion(false)
            }
        }
    }
}
