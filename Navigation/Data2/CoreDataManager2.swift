//
//  CoreDataManager.swift
//  Navigation
//
//  Created by Наталья Босякова on 27.02.2023.
//

import UIKit
import CoreData
import StorageService

class CoreDataManager {
    
    var myFavoritePosts: [MyFavoritePost2] = []
    
    lazy var persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "Navigation2")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func addPostToFavorite(post: Post2) {
        let newMyFavoritePost = MyFavoritePost2(context: persistentContainer.viewContext)
        newMyFavoritePost.postId = post.id
        //newMyFavoritePost.date_create = NSDate().
        saveContext()
    }
    
    func getPosts2() {
        let fetchRequest = MyFavoritePost2.fetchRequest()
        do {
            let _ = try persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    func deletePostFromFavorite(post: Post2) {
        let fetchRequest = MyFavoritePost2.fetchRequest()
        do {
            myFavoritePosts = try persistentContainer.viewContext.fetch(fetchRequest)
        }
        catch {
            print(error.localizedDescription)
            myFavoritePosts = []
        }
    }
    
    func delete(entityName: String) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
        } catch let error as NSError {
            debugPrint(error)
        }
    }
    
    func getPosts()->[Post2] {
        
        var posts: [Post2] = []
        let fetchRequest = Post2.fetchRequest()
        var isNeededToCreatePosts = false
        
        do {
            posts = try persistentContainer.viewContext.fetch(fetchRequest)
            isNeededToCreatePosts = posts.count == 0
        }
        catch {
            print(error.localizedDescription)
        }
        
        //isNeededToCreatePosts = true
        
        if isNeededToCreatePosts {
            delete(entityName: "Post2")
            saveContext()
            fillPosts()
            do {
                posts = try persistentContainer.viewContext.fetch(fetchRequest)
            }
            catch {
                print(error.localizedDescription)
            }
        }
        
        return posts
        
    }
    
    func fillPosts() {
        
        let authors = ["Alice", "Bob", "Carol", "Dave"]
        let descriptions = [
            "the best day",
            "Vacation 2024. Исследования установили, что даже ожидание отпуска делает человека счастливее и повышает производительность труда. Связано это с тем, что в предвкушении отдыха специалист становится более стрессоустойчивым и собранным. Работа без отпуска накапливает стресс и хроническую усталость.",
            "Dave's party",
            "~ ♡ ~"]
        
        var imageNumber = 0
        
        for index in 0...3 {
            let newPost = Post2(context: persistentContainer.viewContext)
            newPost.author = authors[index]
            newPost.postDescription = descriptions[index]
            newPost.dateAdded = Date()
            newPost.imageData = UIImage(named: "PostImage"+String(imageNumber))!.pngData()
            imageNumber = imageNumber + 1
            newPost.likes = 0
            newPost.views = 0
            saveContext()
        }
    }
}
