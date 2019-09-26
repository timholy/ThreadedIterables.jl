function testTmapStable()::Bool
	arr = randArray();
	return minimum(map(x->2x, arr) .== tmap(x->2x, arr));
end

function testTmapUnstable()::Bool
	arr = randStrArray();
	str = lipsum();
	return minimum(map(x->str[1:x], arr) .== tmap(x->str[1:x], arr));
end

function testTmapEmpty()::Bool
	return map(x->2x, []) == tmap(x->2x, []);
end

function testTmapStableMultiple()::Bool
	arr1, arr2 = rand2Arrays();
	return minimum(map((x, y)->2x + 3y, arr1, arr2) .== tmap((x, y)->2x + 3y, arr1, arr2));
end

function testTmapUnstableMultiple()::Bool
	arr1, arr2 = rand2StrArrays();
	str = lipsum();
	return minimum(map((x, y)->str[1:x + y], arr1, arr2) .== tmap((x, y)->str[1:x + y], arr1, arr2));
end

function testTmapMultipleEmpty()::Bool
	return map((x, y)->2x + 3y, [], []) == tmap((x, y)->2x + 3y, [], []);
end

function testTmap!()::Bool
	n = rand(1:2);
	srcDim = rand(1:3, n);
	destDim = srcDim[randperm(n)];
	srcArr = rand(1:1000, srcDim...);
	destArr = rand(1:1000, destDim...);
	tSrcArr = deepcopy(srcArr);
	tDestArr = deepcopy(destArr);
	map!(x->2x, destArr, srcArr);
	tmap!(x->2x, tDestArr, tSrcArr);
	return minimum(destArr .== tDestArr);
end

function testTmap!Empty()::Bool
	destDim = rand(1:3, rand(1:2));
	destArr = rand(1:1000, destDim...);
	tDestArr = deepcopy(destArr);
	map!(x->2x, destArr, []);
	tmap!(x->2x, tDestArr, []);
	return minimum(destArr .== tDestArr);
end

function testTmap!Multiple()::Bool
	n = rand(1:2);
	srcDim = rand(1:3, n);
	destDim = srcDim[randperm(n)];
	srcArr1 = rand(1:1000, srcDim...);
	srcArr2 = rand(1:1000, srcDim...);
	destArr = rand(1:1000, destDim...);
	tSrcArr1 = deepcopy(srcArr1);
	tSrcArr2 = deepcopy(srcArr2);
	tDestArr = deepcopy(destArr);
	map!((x, y)->2x + 3y, destArr, srcArr1, srcArr2);
	tmap!((x, y)->2x + 3y, tDestArr, tSrcArr1, tSrcArr2);
	return minimum(destArr .== tDestArr);
end

function testTmap!MultipleEmpty()::Bool
	destDim = rand(1:3, rand(1:2));
	destArr = rand(1:1000, destDim...);
	tDestArr = deepcopy(destArr);
	map!((x, y)->2x + 3y, destArr, [], []);
	tmap!((x, y)->2x + 3y, tDestArr, [], []);
	return minimum(destArr .== tDestArr);
end

function testTmapMultipleDimensionMismatch()
	tmap((x, y)->2x + 3y, [1, 2], [3, 4, 5]);
end
