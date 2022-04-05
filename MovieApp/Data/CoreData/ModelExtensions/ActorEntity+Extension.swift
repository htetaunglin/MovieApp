//
//  ActorEntityX.swift
//  MovieApp
//
//  Created by Htet Aung Lin on 02/04/2022.
//

import Foundation
import CoreData

extension ActorEntity {
    func toActorInfoResponse() -> ActorInfoResponse {
        let movieEntities = (self.credits?.allObjects as? [MovieEntity]) ?? [MovieEntity]()
        return ActorInfoResponse(
            adult: self.adult,
            gendre: Int(self.gender),
            id: Int(self.id),
            knownFor: movieEntities.map{ $0.toMovieResult() },
            knownForDepartment: self.knownForDepartment,
            name: self.name,
            popularity: self.popularity,
            profilePath: self.profilePath)
    }
    
    func toActorDetailResponse() -> ActorDetailResponse {
//        let movieEntities = (self.credits?.allObjects as? [MovieEntity]) ?? [MovieEntity]()
        return ActorDetailResponse(
            adult: adult,
            alsoKnownAs: [],
            biography: biography,
            birthday: birthday,
            deathday: deathday,
            gender: Int(gender),
            homepage: homePage,
            id: Int(id),
            imdbID: imdbID,
            knownForDepartment: knownForDepartment,
            name: name,
            placeOfBirth: placeOfBirth,
            popularity: popularity,
            profilePath: profilePath)
    }
}

extension ActorInfoResponse {
    func toActorEntity(context: NSManagedObjectContext, belongToType: BelongsToTypeEntity) -> ActorEntity {
        let entity = ActorEntity(context: context)
        entity.id = Int32(self.id ?? 0)
        entity.adult = self.adult ?? false
        entity.profilePath = self.profilePath
        entity.popularity = self.popularity ?? 0
        entity.knownForDepartment = self.knownForDepartment
        entity.alsoKnownAs = ""
        entity.gender = Int32(self.gendre ?? 0)
        entity.homePage = ""
        entity.name = self.name
        self.knownFor?.forEach{
            entity.addToCredits($0.toMovieEntity(context: context, groupType: belongToType))
        }
        return entity
    }
}

extension ActorDetailResponse {
    func toActorEntity(context: NSManagedObjectContext) -> ActorEntity? {
        let fetchRequest: NSFetchRequest<ActorEntity> = ActorEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K = %@", "id", "\(self.id ?? 0)")
        do {
            let results = try context.fetch(fetchRequest)
            if let firstResult = results.first {
                // Update
                firstResult.id = Int32(self.id ?? 0)
                firstResult.adult = self.adult ?? false
                firstResult.profilePath = self.profilePath
                firstResult.popularity = self.popularity ?? 0
                firstResult.knownForDepartment = self.knownForDepartment
                firstResult.alsoKnownAs = self.alsoKnownAs?.joined(separator: ", ")
                firstResult.gender = Int32(self.gender ?? 0)
                firstResult.homePage = self.homepage
                firstResult.name = self.name
                firstResult.birthday = self.birthday
                firstResult.placeOfBirth = self.placeOfBirth
                firstResult.imdbID = self.imdbID
                firstResult.deathday = self.deathday
                firstResult.biography = self.biography
                return firstResult
            } else {
                // New
                let entity = ActorEntity(context: context)
                entity.id = Int32(self.id ?? 0)
                entity.adult = self.adult ?? false
                entity.profilePath = self.profilePath
                entity.popularity = self.popularity ?? 0
                entity.knownForDepartment = self.knownForDepartment
                entity.alsoKnownAs = self.alsoKnownAs?.joined(separator: ", ")
                entity.gender = Int32(self.gender ?? 0)
                entity.homePage = self.homepage
                entity.name = self.name
                entity.birthday = self.birthday
                entity.imdbID = self.imdbID
                entity.deathday = self.deathday
                entity.biography = self.biography
                return entity
            }
        } catch {
            return nil
        }
    }
}
