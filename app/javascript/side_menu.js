document.addEventListener('DOMContentLoaded', function() {
  const toggleButton = document.getElementById('toggle-menu');
  const sideMenu = document.querySelector('.side-menu');

  toggleButton.addEventListener('click', () => {
    if (sideMenu.style.left === '0px') {
      sideMenu.style.left = '-200px'; 
    } else {
      sideMenu.style.left = '0px';
    }
  });
});
