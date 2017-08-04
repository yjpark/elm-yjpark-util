var _yjpark$elm_yjpark_util$Native_Ext = function() {


function render_json(target, json, openDepth) {
  return render_json_with_config(target, json, openDepth, null);
}

function render_into_target(target, html) {
  var target_node = document.getElementById(target);
  if (target_node != null) {
    var last;
    while (last = target_node.lastChild) target_node.removeChild(last);
    target_node.appendChild(html);
    return true;
  }
  return false;
}

function render_into_target_with_retry(target, html, delay) {
  if (!render_into_target(target, html)) {
    setTimeout(function() {
      render_into_target_with_retry(target, html);
    }, delay);
  }
}

function render_json_with_config(target, json, openDepth, config) {
  const formatter = new libs.JSONFormatter(json, openDepth, config);
  var html = formatter.render();
  render_into_target_with_retry(target, html, 10);
  return html;
}

function open_url(url, name) {
    window.open(url, name);
}


return {
  render_json: F3(render_json),
  render_json_with_config: F4(render_json_with_config),
  open_url: F2(open_url)
};

}();

