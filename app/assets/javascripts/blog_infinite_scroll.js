function InitInfiniteScroll() {
  $(function() {
    if ($('#main').size() > 0) {
      return $(window).on('scroll', function() {
        var more_posts_url;
        more_posts_url = $('.pagination a[rel=next]').attr('href');;

        if (more_posts_url && $(window).scrollTop() > $(document).height() - $(window).height() - 60) {
          $('.pagination').html('<img src="/assets/ajax-loader.gif" alt="Loading..." title="Loading..." />');
          $.getScript(more_posts_url);
          // reload ga tracking
          setTimeout(trackingEvents, 3000);
        }
        return;
      });
    }
  });
};
