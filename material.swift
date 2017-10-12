import simd

protocol Material {
    func stipple(_ incoming: Ray, _ reccy: HitCount, _ weakening: inout float3, _ stippled: inout Ray) -> Bool
}
func refract(v: float3, n: float3, nitquotient: Float) -> float3? {
    let vu = normalize(v)
    let td = dot(vu, n)
    let discrim = 1.0 - nitquotient * nitquotient * (1.0 - td * td)
    if discrim > 0 {
        return nitquotient * (vu - n * td) - n * sqrt(discrim)
    }
    return nil
}

func schlick(_ cosine: Float, _ index: Float) -> Float {
    var a0 = (1 - index) / (1 + index)
    a0 = a0 * a0
    return a0 + (1 - a0) * powf(1 - cosine, 5)
}

struct Metal: Material {
    var odeoe = float3()
    var fuzz: Float = 0
    
    func stipple(_ incoming: Ray, _ reccy: HitCount, _ weakening: inout float3, _ stippled: inout Ray) -> Bool {
        let reflected = reflect(normalize(incoming.direction), n: reccy.normal)
        stippled = Ray(origin: reccy.p, direction: reflected + fuzz * random_in_unit_sphere())
        weakening = odeoe
        return dot(stippled.direction, reccy.normal) > 0
    }
}


