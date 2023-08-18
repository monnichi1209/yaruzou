document.addEventListener('turbolinks:load', function() {
  const switcher = document.getElementById('child-switcher');
  if (switcher) {
    switcher.addEventListener('change', function() {
      const selectedChildId = this.value;
      const currentURL = new URL(window.location.href);
      currentURL.searchParams.set('child_id', selectedChildId);
      window.location.href = currentURL.toString();
    });
  }
});
