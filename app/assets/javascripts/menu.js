(function (window, document) {
  var menu = document.getElementsByTagName('header')[0],
  WINDOW_CHANGE_EVENT = ('onorientationchange' in window) ? 'orientationchange':'resize';

  function toggleHorizontal() {
    [].forEach.call(
      document.getElementsByTagName('header')[0].querySelectorAll('.custom-can-transform'),
      function(el){
        el.classList.toggle('pure-menu-horizontal');
      }
      );
  }

  function toggleMenu() {
    if (menu.classList.contains('open')) {
      setTimeout(toggleHorizontal, 500);
    }
    else {
      toggleHorizontal();
    }
    menu.classList.toggle('open');
    document.getElementById('toggle').classList.toggle('x');
  }

  function closeMenu() {
    if (menu.classList.contains('open')) {
      toggleMenu();
    }
  }

  document.getElementById('toggle').addEventListener('click', function (e) {
    toggleMenu();
  });

  window.addEventListener(WINDOW_CHANGE_EVENT, closeMenu);
})(this, this.document);
