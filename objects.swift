
import Foundation
import simd

protocol Hitable {
    func hit(r: Ray, _ tmin: Float, _ tmax: Float) -> HitCount?
}

struct HitCount {
    var t: Float
    var p: float3
    var normal: float3
    var mat_ptr: Material
}

struct ListHitable: Hitable  {
    var list: [Hitable]
    
    func hit(r: Ray, _ tmin: Float, _ tmax: Float) -> HitCount? {
        var hit_anything: HitCount?
        for item in list {
          if let aHit = item.hit(r: r, tmin, hit_anything?.t ?? tmax) {
                hit_anything = aHit
            }
        }
        return hit_anything
    }
}

struct Sphere: Hitable  {
    var center: float3
    var radius: Float
    var mat: Material
    
    init(c: float3, r: Float, m: Material) {
        center = c
        radius = r
        mat = m
    }
    
    func hit(r: Ray, _ tmin: Float, _ tmax: Float) -> HitCount? {
        let oc = r.origin - center
        let a = dot(r.direction, r.direction)
        let b = dot(oc, r.direction)
        let c = dot(oc, oc) - radius * radius
        let discriminant = b * b - a * c
        if discriminant > 0 {
            var t = (-b - sqrt(discriminant) ) / a
            if t < tmin {
                t = (-b + sqrt(discriminant) ) / a
            }
            if tmin < t && t < tmax {
                let point = r.point(atParam: t)
                let normal = (point - center) / float3(radius)
                return HitCount(t: t, p: point, normal: normal, mat_ptr: mat)
            }
        }
        return nil
    }
}
