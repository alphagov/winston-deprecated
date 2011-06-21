function render_panel(name) {
  $('#' + name).load('dashboard?panel=' + name)
}

function activate_panel(name,seconds) {
  render_panel(name);
  if (seconds > 0) {
    setInterval("render_panel('"+name+"')", (seconds * 1000));
  }
}
