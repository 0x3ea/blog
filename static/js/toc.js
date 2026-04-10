(function () {
  var tocSidebar = document.querySelector('.toc-sidebar');
  if (!tocSidebar) return;

  var tocLinks = tocSidebar.querySelectorAll('a');
  if (!tocLinks.length) return;

  // Collect heading elements from main content
  var headings = [];
  tocLinks.forEach(function (link) {
    var id = link.getAttribute('href');
    if (!id) return;
    var el = document.querySelector(id);
    if (el) headings.push({ el: el, link: link });
  });

  // Active heading tracking via IntersectionObserver
  var activeLink = null;
  var observer = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (entry) {
        var item = headings.find(function (h) { return h.el === entry.target; });
        if (!item) return;
        if (entry.isIntersecting) {
          if (activeLink) activeLink.classList.remove('active');
          item.link.classList.add('active');
          activeLink = item.link;
        }
      });
    },
    { rootMargin: '-80px 0px -70% 0px', threshold: 0 }
  );

  headings.forEach(function (h) { observer.observe(h.el); });

  // Smooth scroll on click
  tocLinks.forEach(function (link) {
    link.addEventListener('click', function (e) {
      var id = link.getAttribute('href');
      if (!id) return;
      var target = document.querySelector(id);
      if (!target) return;
      e.preventDefault();
      target.scrollIntoView({ behavior: 'smooth', block: 'start' });
      // Update active state immediately
      if (activeLink) activeLink.classList.remove('active');
      link.classList.add('active');
      activeLink = link;
    });
  });
})();
