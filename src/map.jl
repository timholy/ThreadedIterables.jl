export tmap, tmap!;

"""
    tmap(f::Function, c::AbstractArray)::AbstractArray

Multi-threaded version of [map(f, c)](https://docs.julialang.org/en/v1.2/base/collections/#Base.map).
"""
function tmap(f::Function, c...)
	ensureThreaded();
	if !all(i->length(i) == length(c[1]), c)
		throw(DimensionMismatch("dimensions must match"));
	end
	# TODO: Allocate an array using eltype of f applied to the first element of c[1]. Then go over all elements and use Base.promote_type if the eltype doesn't match. Also, probably this needs to be done per-thread and then joined.
	ret = similar(c[1], Any);
	Threads.@threads for i in eachindex(c[1])
		ret[i] = f(getindex.(c, i)...);
	end
	return reshape([ret...],size(ret)...);
end

"""
    tmap!(f::Function, destination::AbstractArray, collection::AbstractArray)::Nothing

Multi-threaded version of [map!(f, destination, collection)](https://docs.julialang.org/en/v1.2/base/collections/#Base.map!).
"""
function tmap!(f::Function, destination::T, collection...)::T where T<:AbstractArray
	ensureThreaded();
	typ = eltype(destination);
	dind = eachindex(destination);
	cind = minimum(eachindex.(collection));
	Threads.@threads for i in 1:length(cind);
		destination[dind[i]] = convert(typ, f(getindex.(collection, cind[i])...));
	end
	return destination;
end
