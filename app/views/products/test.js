var rating_hash = {};
var count_hash = {};

data.forEach(function(obj) {
    if (rating_hash[obj.location] == null) {
	rating_hash.push({obj.location: obj.rating});
	count_hash.push({obj.location: 1});
    }
    else {
	rating_hash[obj.location] += obj.rating;
	count_hash[obj.location] += 1;
    }
})

rating_hash.forEach(function(obj) {
    obj.rating = (obj.rating / count_hash[obj.location]) / 5;    
})
