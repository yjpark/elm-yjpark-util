// From npm package:
//   "guid": "0.0.12",
var _yjpark$elm_yjpark_util$Native_Mdl = function() {

function reset_index(mdl) {
  var index = mdl.hacky_index_;
  mdl.hacky_index_ = 0;
  console.error("[Mdl.reset_index]", mdl, index);
  return index;
}


function new_index(mdl) {
  var index = mdl.hacky_index_;
  mdl.hacky_index_ = mdl.hacky_index_ + 1;
  console.error("[MDL.new_index]", mdl, index);
  return index;
}


return {
  reset_index: reset_index,
  new_index: new_index
};

}();
